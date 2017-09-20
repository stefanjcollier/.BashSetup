#Allows the use of gimme
#source ~/.stools_config/gimme/gimme_function.sh

# Opens the file explorer
function open {
   if [ -z $1 ]; then
	nautilus .
   else
	nautilus $1
   fi
}

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
	elif [ "$1" == '--help' ]; then
		echo 'fix Usage:'
		echo '    $fix --[bash|function|alias]'
	else
		echo "fix: Unkown option \"${1}\""
		echo '     try $fix --help'
	fi
	. ~/.bashrc
}

function todo {
	vim ~/todo.md
}


alias find_prints='echo Finding print statements!; for file in $(find . -name *.py); do  result=$(cat $file | grep print); if [[ ! -z $result ]]; then echo;echo; echo "==============================================================";echo "================[ ${file} ]============"; cat $file | grep print -n;fi; done'
alias find_print=find_prints


#source ~/.stools_config/gimme/gimme_function.sh
alias find_logs_deprecated='echo Finding console.log statements!; for file in $(find . -type d \( -path ./node_modules -o -path ./.tmp -o -path ./dist -o -path ./bin \) -prune -o -name *.js -print); do  result=$(cat $file | grep console.log); if [[ ! -z $result ]]; then echo;echo; echo "==============================================================";echo "================[ ${file} ]============"; cat $file | grep console.log -n -B 2 -A 2;fi; done'

alias find_logs="echo; echo Finding console.logs!; echo; ag -Q console.log -B 2 -A 2 || echo None Found "
alias find_log=find_logs
alias find_console=find_logs

