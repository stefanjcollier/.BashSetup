# ~/.bash_files/.bash_aliases: Sourced in ~/.bashrc
# This file should contain only aliases
alias cd-='cd -'
alias     cd.='cd ..'
alias    cd..='cd ../..'
alias   cd...='cd ../../..'
alias  cd....='cd ../../../..'
alias cd.....='cd ../../../../..'

alias l1='ls -1'
alias l1t='ls -1tr'
alias li='ls -i1sAB'
alias lg='l1 | grep'

alias VIM=vim

alias windows='cd /mnt/c/Users/Stefa'
alias win=windows

alias get="curl -sSi -X GET -H 'Accept: application/json'"
alias post="curl -sSi -X POST -H 'Content-type: application/json' -d"

# Get the absolute path of a file
alias path='readlink -e'

alias clc='clear'
alias ccc='clear'
alias cc='clear'

#----[ Colour Print Cat ]----
alias ccat=pygmentize
alias cccat=ccat
alias _cat=/bin/cat
alias ocat=_cat
alias bcat=_cat

#----[ String Funcs ]----
function lower { 
	echo "$@" | tr [A-Z] [a-z] 
}
alias lc=lower
function upper { 
	echo "$@" | tr [a-z] [A-Z] 
}
alias uc=upper


#function line_lens {
#	echo $@ | awk '{ print length, $0}' | sort -nr 
#}

alias pingme='ping www.google.com'
alias pinggoogle=pingme
alias googleping=pingme

alias ip=ipython
alias bp=bpython

#----[ Stefans Git Commands ]---- 
alias g='clear; git'
alias gs='clear; git status'
alias gl='clear; git log --pretty=oneline --abbrev-commit --all' 
alias g10='clear; git log --pretty=oneline --abbrev-commit --all -n10' 
alias glg='clear; git log --pretty=oneline --abbrev-commit --all --graph' 
alias gp='echo git pushing; git push;'
alias gpu='git push'
alias gps='git push'
alias gpl='git pull'
alias gc='git commit'
alias gac='git add .; git commit'
alias gb='git branch'
alias ghelp='alias | grep git'
alias gdiff='git diff'
function gprune {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}');
          do git branch -D $branch;
    done
}

