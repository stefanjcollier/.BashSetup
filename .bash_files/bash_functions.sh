
function fix {
	if   [[ $1 =~ 'bash' ]]; then
		vim ~/.bashrc
	elif [[ $1 =~ 'priv' ]]; then 
		if [[ $2 =~ 'func' ]]; then
			vim ~/.bash_files/private/private_functions.sh
		elif [[ $2 =~ 'alias' ]]; then
			vim ~/.bash_files/private/private_aliases.sh
		else
			echo 'fix private Usage:'
			echo '            $fix private [function|alias]'
		fi
	elif [[ $1 =~ 'func' ]]; then
		vim ~/.bash_files/bash_functions.sh
	elif [[ $1 =~ 'alias' ]]; then
		vim ~/.bash_files/bash_aliases.sh
	elif [[ $1 =~ 'vim' ]]; then
		vim ~/.vimrc
	elif [[ $1 =~ 'pre' ]]; then
		vim ~/scripts/make_prebuild/make_prebuild.sh
	elif [ "$1" == '--help' ]; then
		echo 'fix Usage:'
		echo '    $fix --[bash|function|alias]'
	else
		echo "fix: Unkown option \"${1}\""
		echo '     try $fix --help'
	fi
	. ~/.bashrc
}


function grab {
	start_pattern=$1
	end_pattern=$2
	file=$3
	awk "/$start_pattern/,/$end_pattern/" $file
}
export -f grab

export HOW_IT_WORKS_SEARCH_DIR=~/.bash_files
function howitworks {
	# Description:
	# 	Find the implementation of functions or aliases and colour print it to the console
	# Usages:
	#	$ howitworks [function name]
	#
	if [ -z $1 ]; then 
		echo -e "Missing Arg 1: $ howitworks \e[31m[function name]\e[39m"
		return 1
	fi
	found=
	command_name=$1
	for file in $(find $HOW_IT_WORKS_SEARCH_DIR -type f); do

		# Find any matching functions
		function_def=$(grab "^function $command_name[ ]*{" "^}"  $file )
		if [ ! -z "$function_def" ]; then
			echo "$function_def" | ccat | sed 's/\t/    /g'
			found=Yes
		fi
		
		# Find any matching alias
		alias_def=$(grep "^alias $command_name=" $file)
		if [ ! -z "$alias_def" ]; then 
			echo "$alias_def"
			found=Yes
		fi 
		
	done
	if [ -z $found ]; then 
		echo -e "howitworks: \e[32m\"$command_name\"\e[39m not defined anywhere in $HOW_IT_WORKS_SEARCH_DIR"
		return 10 
	fi
}


function todo {
	todoFile=~/.todo.md

	if [ -z $1 ]; then 
		vim $todoFile
	else
		header_and_footer=`cat $todoFile | grep '^#' | grep $1 -A1`
		if [[ -z "$header_and_footer" ]]; then
			echo '$1 Did not match any section'
			return 1
		fi

		sep_header_and_footer=`echo $header_and_footer | sed 's/##*/#/g'| sed 's/^#//g'`
		
		header=`echo $sep_header_and_footer | awk -F'#' '{print $1}' | sed 's/[ ]*$//' | sed 's/^[ ]*//g'`
		footer=`echo $sep_header_and_footer | awk -F'#' '{print $2}' | sed 's/[ ]*$//' | sed 's/^[ ]*//g'`

		cat $todoFile | grep "${header}" -A100 | grep "${footer}" -B100 | head -n -1
	fi
}


alias find_prints='echo Finding print statements!; for file in $(find . -name *.py); do  result=$(cat $file | grep print); if [[ ! -z $result ]]; then echo;echo; echo "==============================================================";echo "================[ ${file} ]============"; cat $file | grep print -n;fi; done'
alias find_print=find_prints


#source ~/.stools_config/gimme/gimme_function.sh
alias find_logs_deprecated='echo Finding console.log statements!; for file in $(find . -type d \( -path ./node_modules -o -path ./.tmp -o -path ./dist -o -path ./bin \) -prune -o -name *.js -print); do  result=$(cat $file | grep console.log); if [[ ! -z $result ]]; then echo;echo; echo "==============================================================";echo "================[ ${file} ]============"; cat $file | grep console.log -n -B 2 -A 2;fi; done'

alias find_logs="echo; echo Finding console.logs!; echo; ag -Q console.log -B 2 -A 2 || echo None Found "
alias find_log=find_logs
alias find_console=find_logs

function log {
	logfile="$(date +%Y-%m-%d).log"
	$@ 2> $logfile
}

function do_stuff {
	for file in $($1); do echo "========[ ${file} ]========"; $2 ; done
}

function compile_notes {
 	readme=~/.notes/readme.md;
	echo "# Notes Homepage" > $readme
	for file in $(ls -1 | grep .md | grep -v readme.md); do
		title=$(cat $file | head -n1 | sed 's/^[# ]*//');
		echo " - [$title](./$file)" >> $readme; 
	done 
}

function _notes_text {
	text=$(echo $@ |  sed 's/ /_/g' | tr '[:upper:]' '[:lower:]')
	echo $text
}

function create_notes {
	text=$(_notes_text $@)
	today=$(date +%Y-%m-%d)
	filename=~/.notes/${today}_${text}.md
	touch $filename
	echo "# $@" > $filename
}

function find_notes {
	text=$(echo $@ |  sed 's/ /_/g' | tr '[:upper:]' '[:lower:]')
	find ~/.notes/ -name "*$text*"
}

function notes {
	echo
}


