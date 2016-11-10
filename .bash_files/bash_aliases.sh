# ~/.bash_files/.bash_aliases: Sourced in ~/.bashrc
# This file should contain only aliases

alias trash='gvfs-trash' 
alias rem='trash' 

alias cd.='cd ..'
alias cd..='cd ../..'
alias cd...='cd ../../..'

alias clc='clear'
alias pingme='ping www.google.com'
alias pinggoogle=pingme
alias googleping=pingme

# SSH commands
alias degas='ssh productizer@degas.ecs.soton.ac.uk'
alias seurat='ssh productizer@seurat.ecs.soton.ac.uk'
alias saturn='ssh user@svm-sc22g13-gdp-saturn.ecs.soton.ac.uk'
alias myrtle='ssh productizer@myrtle.ecs.soton.ac.uk'


#----[ Stefans Git Commands ]---- 
alias gitsave='bash ~/git/BashScripts/gitsave.sh' 
alias gitstat='bash ~/git/BashScripts/bash/GitStatusRefresh.sh' 

alias gs='clear; git status'
alias gl='clear; git log --pretty=online'
alias gp='echo git pushing; git push'
alias gpu='git push'
alias gpl='git pull'
alias gc='git add .; git commit'
alias ghelp='alias | grep git'

#----[ Stefan Defined Scripts ]----
alias google='echo Not Imported Yet'
