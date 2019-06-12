# ---------------------------------------------------------------------------------------------------
#  Fix
# ---------------------------------------------------------------------------------------------------
function fix {
	# Description:
	#	Stefan's method for editing functions and aliases 
	# Usages:
	#	$ fix [bash/func/alias/vim]
	#	$ fix <priv> [func/alias]
	#
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
		if [[ ! -z $2 ]]; then 
			__fix__func $2	
		else
			vim ~/.bash_files/bash_functions.sh
		fi
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

# ----[ Initialise the command ]-----
FUNCTION_FOLDER=~/.bash_files/functions
if [ ! -d $FUNCTION_FOLDER ]; then 
	mkdir -p $FUNCTION_FOLDER
fi

IMPORT_FUNC_FILE=~/.bash_files/bash_functions.sh



# ----[ Helper functions ]-----
function function_exists {
	type $1 1> /dev/null 2> /dev/null
}

function file_exists {
	if [ -f $1 ]; then 
		return 0
	else
		return 1
	fi
}
function __fix__func__is_new_func {
	function_exists $1 && ! file_exists $2 
}

function __fix__func {
	func_name=$1
	func_file=$FUNCTION_FOLDER/${func_name}.sh

	# ---[ Pre Checks ]---
	# Ensure the name is not taken when making a new function
	is_new_file=
	if ! file_exists $func_file; then
		is_new_file=True

		if function_exists $func_name; then
			echo -e "The name '${func_name}' is already taken"
			return 1
		fi
	fi
	
	#---[ Edit/Make function ]---
	# edit function file
	vim $func_file
	
	# ---[ Post Checks ]---
	if [ ! -s $func_file  ]; then
		echo "Nothing was written for $func_name"
		return 2 
	fi

	# TODO: post check: check for any exit commands

	# add alias if it's new 
	#---[ Add alias ]---
	if [ ! -z $is_new_file ]; then 
		echo "Adding '${func_name}' to alias file"
		echo "" >> IMPORT_FUNC_FILE
		echo "alias='${func_file}'" >> IMPORT_FUNC_FILE
	fi
	#TODO: Determine the best way to import the functions
 		
}



# ---------------------------------------------------------------------------------------------------
#  Grab
# ---------------------------------------------------------------------------------------------------
function grab {
	# Description:
	# 	Select over multlines (i.e. multiline grep)
	# Usages:
	#	$ grab [start pattern] [end pattern] [file]
	#	$ cat [file] | grab [start pattern] [end pattern]
	#
	start_pattern=$1
	end_pattern=$2
	file=$3
	awk "/$start_pattern/,/$end_pattern/" $file
}
export -f grab

# ---------------------------------------------------------------------------------------------------
#  How It Works
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#	- grab
export HOW_IT_WORKS_SEARCH_DIR=~/.bash_files
function howitworks {
  	# Description:
	# 	Find the implementation of functions or aliases and colour print it to the console
	# Usages:
	#	$ howitworks [command name]
	#
	if [ -z $1 ]; then 
		echo -e "Missing Arg 1: $ howitworks \e[31m[function name]\e[39m"
		return 1
	fi
	found=	# initially empty
	command_name=$1
	for file in $(find $HOW_IT_WORKS_SEARCH_DIR -type f); do

		# Find any matching functions that are defined via 'function'
		function_def=$(grab "^\s*function $command_name[ ]*{" "^}"  $file )
		if [ ! -z "$function_def" ]; then
			echo "$function_def" | ccat -l bash | sed 's/\t/    /g'
			found=Yes
		fi
		
		# Find any matching alias
		alias_def=$(grep "^alias $command_name=" $file)
		if [ ! -z "$alias_def" ]; then 
			echo "$alias_def"
			found=Yes
		fi

		# attempt `which`
		which_def=$(which $command_name 2> /dev/null)
		if [ ! -z "$which_def" ]; then
			echo -e "\e[32m${command_name}\e[39m found to be \e[33m${which_def}\e[39m"
			found=Yes
			break
		fi
		
	done
	if [ -z $found ]; then 
		echo -e "howitworks: \e[31m\"$command_name\"\e[39m not defined anywhere in $HOW_IT_WORKS_SEARCH_DIR"
		return 10 
	fi
}
export howitworks

alias howitwork=howitworks
alias hiw=howitworks
alias how=howitworks


# ---------------------------------------------------------------------------------------------------
#  Todo
# ---------------------------------------------------------------------------------------------------
function todo {
	todoFile=~/.todo.md

	if [ -z $1 ]; then 
		vim $todoFile
	else
		# Find that section
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

# ---------------------------------------------------------------------------------------------------
#  Misc 
# ---------------------------------------------------------------------------------------------------

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
