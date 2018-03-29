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
#function line_lens {
#	echo $@ | awk '{ print length, $0}' | sort -nr 
#}



alias pingme='ping www.google.com'
alias pinggoogle=pingme
alias googleping=pingme

alias ip=ipython
alias bp=bpython

#----[ Stefans Git Commands ]---- 
alias g='clear; git '
alias gs='clear; git status'
alias gl='clear; git log --pretty=oneline --abbrev-commit --all' 
alias glg='clear; git log --pretty=oneline --abbrev-commit --all --graph --decorate' 
alias gp='echo git pushing; git push'
alias gpu=gp
alias gps='git push'
alias gpl='git pull'
alias gc='git commit'
alias gac='git add .;git commit'
alias ghelp='alias | grep git'
alias giff='git diff'
alias gb='git branch'

#----[ Stefan Defined Scripts ]----
alias google='echo Not Imported Yet'

# Find the date of a site
# https://www.google.co.uk/search?q=inurl:<url>&as_qdr=y15
