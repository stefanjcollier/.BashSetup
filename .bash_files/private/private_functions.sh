# ---------------------------------------------------------------------------------------------------
#  Perforce Edit
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#	- p4  # perforce
#
function pedit {
	# Name:
	#	pedit
	#
	# Description:
	# 	p4 edit overlay that handles the manipulation of files, making your life easier.
	# 
	# Usage:
	#	pedit <filename>	# Opens the file for editing
	#	pedit --clean		# Removes all the 'hidden' files used to check
	#				  if the file should be added
	#
	if [[ -z "$1" ]]; then 
		# Print usage
		echo "pedit:Usage:"
		echo "      pedit <filename>        # Opens the file for editing"
		echo "      pedit --clean           # Removes all the 'hidden' files used to check"
		echo "                                if the file should be added"
	elif [[ "$1" == "--clean" ]]; then 
		# Tidy up the mess up
		echo pedit: Not Implemented
		exit 1
	fi
	
	# Do appropriate command to add it to $ pf opened
	if [[ -e $1 ]]; then
		p4 edit $1
	else
		p4 add $1
	fi
	
	# Ensure an editor will be used
	if [[ -z $P4EDITOR ]]; then
		P4EDITOR=vim
	fi
	# Open the file in the chosen editor
	$P4EDITOR $1
	
	# Check if there was a change, if not then remove it from $ pf opened 
	if [[ -z $(p4 diff -Od | grep $1) ]]; then
		echo "No Changes... $ p4 revert ${1}"
		p4 revert $1
	else
		# Simply print here because we did it above
		echo "$ p4 edit ${1}"
	fi
}

# ---------------------------------------------------------------------------------------------------
#  Process Killer
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#  - env variable: PS_SERVICE
#
export PS_SERVICE='stefan.fcgi'
function pskill {
	# Name:
	#	Kill Service	
	#
	# Description:
	#	(To be used on the unixdev09) Kills the service that matches the name in \$PS_SERVICE
	# 
	# Usage:
	#	$ pskill 				# Kills the previously killed service
	#	$ pskill [pattern]		# Kills the service matching the pattern
	#	$ pskill --help 		# Displays help (including PS_SERVICE value)
	#
	if [[ "$1" == "--help" ]]; then
		echo "Usage: \$ perkill "
		echo "Kills the process that matches the contents of \$PS_SERVICE"
		echo "Which currently is: '${PS_SERVICE}'"
		return 0
	fi
	
	if [[ -n "$1" ]]; then
		PS_SERVICE=$1
	fi
	
	service_pid=`ps -ef | grep ${PS_SERVICE} | grep -v grep | awk -F ' ' '{print $2}'`
	service_name=`ps -ef | grep ${PS_SERVICE} | grep -v grep | awk -F ' ' '{print $NF}'`
	if [[ -z $service_pid ]]; then
		echo "Service '${PS_SERVICE}' is not running" >&2
		return 1
	
	# If there is more than one option that matches you search criteria
	elif (( $(echo $service_pid | wc -w) > 1 )); then 
		echo -e "\e[31mMore than one service matches that criteria '${PS_SERVICE}':\e[0m "
		# Show all the options with option numbers 
		ps -ef | grep ${PS_SERVICE} | grep -v grep | awk 'BEGIN{line=0; print "     user\tPID\tCommand"}{print " [" line++ "] " $1 "\t" $2 "\t" $NF "\t\t(" $(NF-1) ")"}'

		# Get user line choice
		echo "Choose a ${PS_SERVICE} to kill... (e.g. 1)"; 
		trap "echo '...Leaving pskill'; return 2" INT  # Allow for a nice leave 
		read -p "-> " line_no
		
		while [[ ! $line_no =~ ^[0-9]+$ ]]; do
			read -p "-> " line_no
		done
	
		service_pid=$(ps -ef | grep ${PS_SERVICE} | grep -v grep | awk '{print " [" line++ "] " $1 "\t" $2 "\t" $NF}' | grep "\[${line_no}\]"  | awk -F ' ' '{print $3}')
		if [[ "$service_pid" -eq "" ]]; then
			echo "The option '$line_no' is not a valid option."
			echo "  quiting..."
			return 1
		else
			service_name=`ps -ef | grep ${service_pid} | grep -v grep | awk -F ' ' '{print $NF}'`
			(kill $service_pid && echo -e "\e[7m\e[34m\$ kill ${service_pid}\e[0m\e[34m # i.e. \$ kill ${service_name}\e[0m ") || echo -e "\e[31mCould not kill ${service_name}\e[0m"
			return 0
		fi
	# Could not find a matching process
	else
		(kill $service_pid && echo -e "\e[7m\e[34m\$ kill ${service_pid}\e[0m\e[34m # i.e. \$ kill ${service_name}\e[0m ") || echo -e "\e[31mCould not kill ${service_name}\e[0m"
		return 0
fi
}


# ---------------------------------------------------------------------------------------------------
#  Perforce Opened File Finder
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#  - pf  # perforce
#
function find_opened {
	# Name:
	#  find_opened
	# 
	# Description:
	#	Finds the path for all the files that are in $p4 opened
	#
	# Usage:
	#	$ find_opened 			# prints paths to all files in p4 opened
	#	$ find_opened [args]	# same command as before but passes args into p4 opened
	#
	pf opened $@ | sed 's:/.*/::g' | awk -F '#' '{print $1}' | xargs -n1 find . -name
}
alias find_open=find_opened
alias opened=find_opened

# ---------------------------------------------------------------------------------------------------
#  Perforce Opened File Finder
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#  - quetex  #
#
my_qtx_file=~/.my_quetexes.txt
function qtx {
	if [[ "$1" =~ "mine" ]]; then 
		cat $my_qtx_file | tr '[:upper:]' '[:lower:]'
		echo;
	elif [[ "$1" =~ "edit" ]]; then 
		$EDITOR $my_qtx_file
	else
		quetex $@
	fi
}

# ---------------------------------------------------------------------------------------------------
#  Draw Wombat
# ---------------------------------------------------------------------------------------------------
blue=$(tput setaf 4)
normal=$(tput sgr0)


A_WIDTH=64

function draw_inner {
	header=$1
	body=$2
	header_width=$3
	if [ -z $3 ]; then 
		header_width=${#header}
	fi

	inner_line=$(printf -v res %$(($A_WIDTH - $header_width))s; printf '%s'  "${res// /─}")
	printf "┃ %-${header_width}s ┌${inner_line}┐  ┃\n" ""
	printf "┃ %-$(($A_WIDTH + 3))s │  ┃\n" "$(printf "%-${header_width}s │ %s" "$header" "$body")"
	printf "┃ %-${header_width}s └${inner_line}┘  ┃\n"
}

function draw_activity {
	activity=$1
	meta=$2
	file=$3
	
	blue_activity="${blue}${activity}${normal}"

	echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
	printf  '┃ %-79s ┃\n' "$blue_activity - $meta"
	draw_inner "File" "$file"
	echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
#	printf '| %-6s + %-50s + |' 'File' '/path/to/file.pl'   #<-- this is a demo


}  
