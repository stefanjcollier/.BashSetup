
debug () {
    if [ ! -z $DEBUG ] && [ $DEBUG -ne 0 ]; then
        echo 'DEBUG>>' $@ | sed 's|\n|\nDEBUG>>|g'  >&2
    fi
}
# --------------------------------
#   ---  [ SSH-ing ]  ---  
# --------------------------------
alias fxd1='ssh fx-devel1'
alias fxd2='ssh fx-devel2'
alias fxa=fxd1
alias fxb=fxd2
alias fxdev='ssh fx-devel'
alias fxdevc=fxdev
alias fxc=fxdev

export VMSA='fdsa::'
export VMSB='fdsb::'
export VMSC='fdsc::'

alias scratch='cd /home/dev/scratch/developers/scollier'
alias goto-equity='cd /home/user/scollier/symbology/prd-progs-sym-equity'
alias goto-notify='cd /home/user/scollier/symbology/prd-progs-sym-equity/notify'

function leg () {
	debug "\$1 = $1"
	if [ -z "$1" ]; then
		echo "No argument provided"

	elif [ -e ~/symbology/legacy-prd-prgs/sym_$1 ]; then  
		cd ~/symbology/legacy-prd-prgs/sym_$1

	else
		sym_home="/home/user/scollier/symbology/"
		local matching_dirs=$(find $sym_home -maxdepth 1 -type d -name "*$1*")
		debug "No of matching dirs: $no_of_matching_dirs"
		debug "Matching dirs: $matching_dirs"

		if [ -z "$matching_dirs" ]; then
			echo "No dirs matching '$1'... Try something else?"
			return 0
		fi
		local no_of_matching_dirs=$(echo ${matching_dirs} | sed 's/ /\n/g' | wc -l)
		if (( $no_of_matching_dirs == 1 )); then 
			cd $matching_dirs
		else
			echo "Many dirs match the pattern '*$1*', please be more specific as we cannot choose between:"
			echo ${matching_dirs} | sed "s|${sym_home}||g" | sed 's/ /\n/g' | sed 's/^/    -> /g' | grep "$1"
		fi
	fi	
}
alias legacy=leg
alias sym=leg

alias python=python3
alias py=python
alias pip=pip3
export PATH="${HOME}/.local/bin:${PATH}"

function fuzzy_cd {
	cd *$@*
}
alias fuzzycd=fuzzy_cd
alias fuzzcd=fuzzy_cd
alias fcd=fuzzy_cd

function fuzzy_vim {
	vim *$@*
}
alias fuzzyvim=fuzzy_vim
alias fuzzvim=fuzzy_vim
alias fvim=fuzzy_vim
alias fvi=fuzzy_vim

# --------------------------------
#   ---  [ General CLI  ]  ---  
# --------------------------------
alias dbops='sudo -u sym_mgr /home/fonix/prd_progs/tools/db_ops/db_ops.sh' 
alias sym_mgr=dbops
alias sym_dev='sudo -u sym_dev /home/fonix/prd_progs/tools/db_ops/db_ops.sh'

alias fdb=fdb_utils_main
alias review='perl /home/data/index/script/common/submit_review_board.pl'
alias fdsdate='date "+%Y%m%d"'

# --------------------------------
#   ---  [ Wombat Stuff ]  ---  
# --------------------------------
alias edit_wombat='perl /home/fonix/prd_progs/tools/wombat/utils/workflow_edit/workflow_edit.pl'
alias download_workflow='edit_wombat --command=download --fetch_type=workflow --user_env=development --driver=./driver'
alias wombat2xml='python ~/scripts/wombatxmltocsv.py'
prd_progs=/home/fonix/prd_progs
sym_tools=/home/fonix/prd_progs/sym/tools

# --------------------------------
#   ---  [ Prebuild Stuff ]  ---  
# --------------------------------
alias make_prebuild='~/scripts/make_prebuild/old_bash/make_prebuild.sh'  # Incomplete
alias mpre=make_prebuild
alias mu_it='/home/fonix/prd_progs/tools/mu_utils/mu_it.pl'
alias src='source X86_64/environment.sh'

alias rkr='echo -e "\e[7m\e[34m$ rakefds -release\e[0m"; rakefds -release'
alias rkd='echo -e "\e[7m\e[34m$ rakefds -debug\e[0m"; rakefds -debug'
alias rkb='echo -e "\e[7m\e[34m$ rakefds -build\e[0m"; rakefds -build'

alias gd="source /home/fonix/prd_progs/tools/define_rakefds_logicals.sh release"
alias gdd="source /home/fonix/prd_progs/tools/define_rakefds_logicals.sh debug"

# --------------------------------
#   ---  [ Quetex Stuff ]  ---  
# --------------------------------
alias qtx='sh ~scollier/scripts/quetex_stats/qtx.sh'
alias devqtx='sh ~scollier/scripts/dev_quetex_stats/qtx.sh'
alias dev_qtx=devqtx

alias qq='sh /home/user/dnamufetha/symbology/scripts/page_res/quetex_stats.sh'
alias danqqs=qq
alias dan_qqs=qq

alias qqs='sh /home/user/scollier/scripts/quetex_stats/quetex_stats.sh'
alias devqqs='sh /home/user/scollier/scripts/dev_quetex_stats/quetex_stats.sh'
alias dev_qqs=devqqs

alias dbl_event_logger='pel /home/fonix/prd_progs/tools/dbl/dbl_event_logger.pl'

# --------------------------------
#   ---  [ Database Stuff ]  ---  
# --------------------------------
alias show_diffs='/home/user/scollier/scripts/show_diffs/show_diffs.sh'
alias find_diffs=show_diffs
alias mssql_table_name='perl /home/user/scollier/symbology/legacy-prd-prgs/sym_tools/sql_server_migration/mssql_table_name.pl'
alias table_name=mssql_table_name
function run_mysql {
	sql_script=$1
	if [ -z $sql_script ]; then 
		echo "Missing Arg 1: $ run_mysql SQL_SCRIPT"
		return 2
	fi
	sms_mysql -l sym -d symdev -o sql_result.txt < $sql_script
}


# -------------------------------
#  --- [ Personal @ FactSet] ---  
# -------------------------------
alias messenger=/home/user/scollier/node_modules/fb-messenger-cli/cli.js

# -------------------------------
# --- [ JSON Schema Methods ] ---
# -------------------------------
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


