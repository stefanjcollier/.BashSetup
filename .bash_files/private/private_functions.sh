alias find_cpp='for file in $(find . -type f | grep -v '.pyc$' | grep -v '/migrations/'); do res=$(cat $file| grep cached_pretty_postcode); if [[ -n $res ]]; then echo; echo; echo "------[ $file ]------"; cat $file | grep 'cached_pretty_postcode' ; fi; done'

function bump {
	if [[ ! -z `git status -s 2>/dev/null` ]]; then
		echo "Cannot change branch to develop"
		echo -e  "\033[1;31mThe environment is not clean, stash your changes first.\033[0m"
		echo
		git status --short
		echo
		return 1
	fi
	git checkout develop --quiet
	if [[ ! -z `git status | grep "ahead of" ` ]]; then 
		echo "This branch has diverged from develop. You're a mess who committed to develop. 😝"
		echo ""
		echo "Fix:"
		echo "  To keep your commits, you will need to checkout to a new branch"
		echo ""
		echo " $ git checkout -b ${USER}/i-am-a-develop-committer-$(date  "+%Y-%m-%d")"
		echo " $ git branch -D develop"
		echo " $ git checkout develop"
		echo ""
		echo " $ bump"
		echo ""
		return 2
	fi
	echo '-----------------------------------------'
	echo '--[📩]-[ Pulling latest version down ]---'
	echo '-----------------------------------------'
	git pull
	
	cd src
	number=$(python -c "import zeus; print(zeus.__version__)")
	tag="v$number"
	echo '-----------------------------------------'
	echo "--[🏷]-[ Tagging as version $tag ]-------"
	echo '-----------------------------------------'
	git tag $tag

	echo '-----------------------------------------'
	echo '--[📮]-[ Sending tag to origin ]---------'
	echo '-----------------------------------------'
	git push origin $tag

	echo '-----------------------------------------'
	echo '--[🏡]-[ Return orginal dir and branch]--'
	echo '-----------------------------------------'
	cd -
	git checkout -
}

function staging {
	echo "Have you logged into AWS and added your IP to the StagingSecurityGroup? 🚨"
	cd ~
	if [[ $2 == '--root' ]];then
	    user=root
	else
	    user=ec2-user
	fi    
	instance_url=$1
	extra_command=$2
	if [[ "$extra_command" -eq "--migrate" ]]; then
		extra_command='cd /srv/olympus; sudo bin/python src/manage.py migrate --settings zeus.settings.staging'
	fi	
	if [[ -z "$extra_command" ]]; then
		ssh -i ~/.ssh/ZeusStagingKeyPair.pem $user@$instance_url
	else
		ssh -t -i ~/.ssh/ZeusStagingKeyPair.pem $user@$instance_url $extra_command
	fi
	cd -
}

function new_migs {
	git diff --name-status $(git rev-parse --abbrev-ref HEAD)..develop | grep migrations | awk -F '/' '{print $2 " " $4}'
}

function handle_migs {
	# ---[ If help arg then show usage ]--------------------------
	if [[ $1 == '--help' ]] || [[ $1 == '?' ]] || [[ $1 == '-h'  ]]; then
		cmd=handle_migs
		echo "$cmd - A tool to help migrate your database back to dev"
		echo;
		echo 'Usage:'
		echo "   $cmd -s --show        Only displays the migrations not on dev"
		echo;
		#echo "   $cmd -m --migrated    Includes info if the migrations are on this database"
		#echo;
		echo "   $cmd -h --help        Shows usage (this page)"
		echo;
		return 0 
	fi
	echo '----------------------------------------------------'
	echo '--[🧐]-[ Finding new migrations]--------------------'
	echo '----------------------------------------------------'
	new_migs=$(git diff --name-status $(git rev-parse --abbrev-ref HEAD)..develop | grep migrations| grep -v '__init__' | awk -F '/' '{print $2 "  " $4}' | sed 's/_/  /'| sed 's/\.py//')
	#current_migs=$(docker-compose exec django src/manage.py showmigrations --plan)
	col1_width=$(echo "$new_migs" | awk -F' ' '{ print $1 }' | wc -L )
	#for line in $(echo "$new_migs" ); do
	#	pre_line=$(echo $line | sed 's/  /./' | sed 's/  /_/')
	#	printf $(echo "$current_migs" | grep $pre_line | sed 's/\[X\]/🌞/' | sed 's/\[ \]/🌚/' | sed 's/[_.]/  /g')

	printf "%10s  %04d  %s\n" "$new_migs"
	echo "$new_migs	"
	#done


	# ---[ If help arg then show usage ]--------------------------
	if [[ $1 == '--show' ]] || [[ $1 == '--show-only' ]] || [[ $1 == '-s' ]] || [[ $2 == '--show' ]] || [[ $2 == '--show-only' ]] || [[ $2 == '-s' ]]; then 
		return 0
	fi
	echo '----------------------------------------------------'
	echo '--[🐣]-[ Migrating to previous ]--------------------'
	echo '----------------------------------------------------'
	apps=$(echo "$new_migs" | awk -F' ' '{print $1}' | uniq )
	for app in $(echo "$apps"); do
		earliest=$(echo "$new_migs" | grep "$app"  | awk -F' ' '{ print $2 }' |  sort | head -n 1)
		last=$(echo "$new_migs" | grep "$app"  | awk -F' ' '{ print $2 }' |  sort | tail -n 1)
		if [[ $earliest == 0001 ]]; then
			echo ---[ $app ]-[ v$last 👉 🔥 ]----------
			docker-compose exec django src/manage.py migrate "$app" zero
		else
			prev_int=$(expr $earliest - 1)
			prev_str=$(printf "%04d" $prev)
			docker-compose exec django src/manage.py migrate "$app" "$prev_str"
		fi
		if [ $? -ne 0 ]; then
			echo; 
			echo "There were errors with your migration";
			echo;
			echo '----------------------------------------------------'
			echo '--[⛔️]-[ DO NOT CHANGE ]----------------------------'
			echo '----------------------------------------------------'
			return 1
		fi;
	done
	
	echo '----------------------------------------------------'
	echo '--[✅]-[ Ready for branch change ]------------------'
	echo '----------------------------------------------------'
}

