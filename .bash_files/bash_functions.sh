
# Uses the gimmme program to change directory to repositories based on substring
function gimme {
   python /home/stefan/Git/gimme/gimme.py $*
   if [ $? -eq 0  ]; then
       cd `cat ~/.stools_config/gimme/gimme_hist.txt`
   fi
}


# Opens the file explorer
function open {
   if [ -z $1 ]; then
	nautilus .
   else
	nautilus $1
   fi
}

function fix {
	if [ "$1" == '--bash' ]; then
		vim '~/.bashrc'
	elif [ "$1" == '--function' ]; then
		vim '~/.bash_files/.bash_functions.sh'
	elif [ "$1" == '--alias' ]; then
		vim '~/.bash_files/.bash_aliases.sh'
	elif [ "$1" == '--help' ]; then
		echo 'fix: $fix --[bash|function|alias]'
	else
		echo 'fix: Unkown option...'
		echo '     try $fix --help'
	fi

}
