# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
color_prompt=yes

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto	'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##################################################################################

# get current status of git repo
function parse_git_dirty {
status=`git status 2>&1 | tee`
dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
bits=''
if [ "${renamed}" == "0" ]; then
bits=">${bits}"
fi
if [ "${ahead}" == "0" ]; then
bits="*${bits}"
fi
if [ "${newfile}" == "0" ]; then
bits="+${bits}"
fi
if [ "${untracked}" == "0" ]; then
bits="?${bits}"
fi
if [ "${deleted}" == "0" ]; then
bits="x${bits}"
fi
if [ "${dirty}" == "0" ]; then
bits="!${bits}"
fi
if [ ! "${bits}" == "" ]; then
echo " ${bits}"
else
echo ""
fi
}

function ps1_git_branch {
	echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}

# The user@machine. e.g. "Jimmy@JimLaptop"
user="\[\e[34;1m\]\u@\h\[\e[30;1m\]"

# The number of jobs running. e.g. "job:2"
job_count="\[\e[34;1m\]jobs:\j\[\e[30;1m\]"

# The current PWD. e.g. "/home/me/documents"
dis_path="\[\e[32;1m\]\$(pwd| sed 's:/home/stefan:~:g' | sed 's:/mnt/c/Users/Stefa:¬:g')\[\e[30;1m\]"

# The current command number with colour highlighting based on the last commands exit status. e.g. "! 200" in green if $?=0
cmd_code="\[\e[\`if [ \$? = 0 ]; then echo 34; else echo 31; fi\`;1m\]! \!\[\e[30;1m\]"

# The current branch name
branch="\$(BRANCH=\$(ps1_git_branch); if [ \$BRANCH ]; then echo \"\[\e[30;1m\]-(\[\e[36;1m\]\$BRANCH\[\e[30;1m\])\"; fi)"

PS1_line_1="\n\[\e[30;1m\](${user})-(${job_count})-(${dis_path})"
PS1="${PS1_line_1}
-(${cmd_code})${branch}-> \[\e[0m\]"



Other_PS1="\n\[\e[30;1m\]\
(\[\e[34;1m\]\u@\h\[\e[30;1m\])-\
(\[\e[34;1m\]\j\[\e[30;1m\])-\
(\[\e[34;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\] \
\
\n-(\[\e[32;1m\]\w\[\e[30;1m\])-\
(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files\[\e[30;1m\])-\`parse_git_branch\`-> \[\e[0m\]"
 

alias_file=~/.bash_files/bash_aliases.sh
if [ -f $alias_file ]; then
    . $alias_file
else
    echo ".bashrc[error]: Aliases file cannot be found at '${alias_file}'"
fi

function_file=~/.bash_files/bash_functions.sh
if [ -f $function_file ]; then
    . $function_file
else 
    echo ".bashrc[error]: Function file cannot be found at '${function_file}'"
fi

p_function_file=~/.bash_files/private/private_functions.sh
if [ -f $p_function_file ]; then
    . $p_function_file
else 
    echo ".bashrc[error]: Private Function file cannot be found at '${p_function_file}'"
fi

p_alias_file=~/.bash_files/private/private_aliases.sh
if [ -f $p_alias_file ]; then
    . $p_alias_file
else 
    echo ".bashrc[error]: Private Alias file cannot be found at '${p_alias_file}'"
fi

PATH="/usr/sbin:${PATH}"
