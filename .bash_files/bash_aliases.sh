# ~/.bash_files/.bash_aliases: Sourced in ~/.bashrc
# This file should contain only aliases

alias trash='gvfs-trash' 
alias rem='trash' 

alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'
alias windows='cd /mnt/c/Users/Stefa'
alias win=windows

alias get="curl -sSi -X GET -H 'Accept: application/json'"
alias post="curl -sSi -X POST -H 'Content-type: application/json' -d"

alias clc='clear'
alias pingme='ping www.google.com'
alias pinggoogle=pingme
alias googleping=pingme

alias ip=ipython
alias node=nodejs

# SSH commands
alias degas='ssh productizer@degas.ecs.soton.ac.uk'
alias seurat='ssh productizer@seurat.ecs.soton.ac.uk'
alias saturn='ssh user@svm-tp10g13-gdp.ecs.soton.ac.uk'
alias class='ssh user@svm-tp10g13-gdp.ecs.soton.ac.uk'
alias classifier=class
alias myrtle='ssh productizer@myrtle.ecs.soton.ac.uk'
alias olivia=myrtle


#----[ Stefans Git Commands ]---- 
alias gitsave='bash ~/git/BashScripts/gitsave.sh' 
alias gitstat='bash ~/git/BashScripts/bash/GitStatusRefresh.sh' 

alias gs='clear; git status'
alias gl='clear; git log --pretty=oneline'
alias gp='echo git pushing; git push;'
alias gpu='git push; '
alias gpl='git pull'
alias gc='git commit'
alias gac='git add .;git commit'
alias ghelp='alias | grep git'

#----[ Stefan Defined Scripts ]----
alias google='echo Not Imported Yet'

# Find the date of a site
# https://www.google.co.uk/search?q=inurl:<url>&as_qdr=y15
