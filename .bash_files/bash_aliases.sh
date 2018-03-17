# ~/.bash_files/.bash_aliases: Sourced in ~/.bashrc
# This file should contain only aliases
alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias windows='cd /mnt/c/Users/Stefa'
alias win=windows

alias get="curl -sSi -X GET -H 'Accept: application/json'"
alias getbody="curl -sS -X GET -H 'Accept: application/json'"
alias post="curl -sSi -X POST -H 'Content-type: application/json' -d"

alias clc='clear'
alias ccc='clear'
alias cc='clear'
alias pingme='ping www.google.com'
alias pinggoogle=pingme
alias googleping=pingme

alias ip=ipython
alias bp=bpython
alias python=python3
alias pip=pip3

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
function gprune {
   git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}');
       do git branch -D $branch;
   done
}

#----[ Stefan Defined Scripts ]----
alias google='echo Not Imported Yet'

# Find the date of a site
# https://www.google.co.uk/search?q=inurl:<url>&as_qdr=y15
