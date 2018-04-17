alias rkr='echo -e "\e[7m\e[34m$ rakefds -release\e[0m"; rakefds -release'
alias rkd='echo -e "\e[7m\e[34m$ rakefds -debug\e[0m"; rakefds -debug'
alias rkb='echo -e "\e[7m\e[34m$ rakefds -build\e[0m"; rakefds -build'

alias dbops='sudo -u sym_mgr /home/fonix/prd_progs/tools/db_ops/db_ops.sh' 
alias fxd1='ssh fx-devel1'
alias fxd2='ssh fx-devel2'
alias fxa=fxd1
alias fxb=fxd2

alias src='source X86_64/environment.sh'

alias python=python3
alias pip=pip3

export PATH="${HOME}/.local/bin:${PATH}"

alias dbl_event_logger='perl /home/fonix/prd_progs/tools/dbl/dbl_event_logger.pl'

alias fdb=fdb_utils_main
alias perldoc='/home/fds/build/FDSperl5.12-FONIXmodules-5.12-20170905/bin/perldoc'
alias perldocs=perldoc
alias review='perl /home/data/index/script/common/submit_review_board.pl'
alias mu_it='/home/fonix/prd_progs/tools/mu_utils/mu_it.pl'

prd_progs=/home/fonix/prd_progs/


# Scripts I made
alias make_prebuild='~/scripts/make_prebuild/old_bash/make_prebuild.sh'  # Incomplete
alias mpre=make_prebuild

alias show_diffs='/home/user/scollier/scripts/show_diffs/show_diffs.sh'
alias find_diffs=show_diffs

# -------------------------------
#  --- [ Personal @ FactSet] ---  
# -------------------------------
alias messenger=/home/user/scollier/node_modules/fb-messenger-cli/cli.js

# -----------------------
# --- [ DSB Methods ] ---
# -----------------------
function jqlens {
	if [ -z $1 ]; then 
		echo "Missing first arg: jqlens [jpath] "
		echo "    e.g jqlens .Attributes.UnderlyingIssuerType"
		return 1
	fi
	cat /home/user/scollier/downloads/LOADS_OF_DSB_RECORDS/*.records | sed -r 's/^\.\?//' | jq ".$1" | grep -v null | sed 's/"//g' | awk '{ print length, $0 }' | sort -nr | head -n1	
}
alias jq_count=jqlens
alias jqcount=jqlens
alias jqcountlen=jqlens
alias jqlen=jqlens

function jqlensfile {
	if [ -z $1 ]; then 
		echo -e "Missing first arg: jqlens \e[31m[attrs file]\e[39m [instrument string]"
		echo    "    e.g jqlensfile jqattributes.txt Comm"
		echo
		echo    "Where each line in the file is like so:"
		echo    ".properties.Attributes.properties.ReturnorPayoutTrigger"
		return 1
	elif [ -z $2 ]; then 
		echo -e "Missing second arg: jqlens [attrs file] \e[31m[instrument string]\e[39m"
		echo    "    e.g jqlensfile jqattributes.txt Comm"
		echo
		echo    "The instrument string is the start of the schema files you want"
		return 2
	fi

	for line in $(cat $1); do
		clean_line=$(echo $line | sed  's/^properties//' | sed 's/\.properties//g' | sed 's/^\.//')
		echo $clean_line
		jqlens $clean_line
	done
}


function jqenums {
	if [ -z $1 ]; then 
		echo "Missing first arg: jqlens \e[31m[attrs file]\e[39m [instrument string]"
		echo "    e.g jqenums jqattributes.txt Conn"
		echo
		echo "Where each line in the file is like so:"
		echo ".properties.Attributes.properties.ReturnorPayoutTrigger"
		return 1
	elif [ -z $2 ]; then 
		echo -e "Missing second arg: jqlens [attrs file] \e[31m[instrument string]\e[39m"
		echo    "    e.g jqenums jqattributes.txt Conn"
		echo
		echo    "The instrument string is the start of the schema files you want"
		return 2
	fi
	for line in $(cat $1) ; do
		echo $line; 
		for file in /home/user/scollier/downloads/LOADS_OF_DSB_RECORDS/schemas/$2*; do
			if [ "$(cat $file | jq "$line.enum")" == "null" ] ; then
				echo "null"
			else
				echo "is_enum"; 
			fi
		done | sort | uniq -c ;
	done
}


function jqtypes {
	if [ -z $1 ]; then 
		echo "Missing first arg: jqlens \e[31m[attrs file]\e[39m [instrument string]"
		echo "    e.g jqtypes jqattributes.txt Conn"
		echo
		echo "Where each line in the file is like so:"
		echo ".properties.Attributes.properties.ReturnorPayoutTrigger"
		return 1
	fi
	for line in $(cat $1) ; do
		echo -en "$(echo $line | sed 's/.*[.]//g')\t"
		cat /home/user/scollier/downloads/LOADS_OF_DSB_RECORDS/schemas/$2* | jq "${line}.type" 2> /dev/null | grep -v null  | sort | uniq | sed 's/"//g' | sed 's/\n/|/g'
	
	done
}


