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
	elif [[ $1 =~ 'function' ]]; then
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


source ~/.stools_config/gimme/gimme_function.sh
