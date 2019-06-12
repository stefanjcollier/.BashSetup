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
#  Old QTX command
# ---------------------------------------------------------------------------------------------------
# Dependencies:
#  - quetex  #
#
my_qtx_file=~/.my_quetexes.txt
function qtxpp {
	if [[ "$1" =~ "mine" ]]; then 
		cat $my_qtx_file | tr '[:upper:]' '[:lower:]'
		echo;
	elif [[ "$1" =~ "edit" ]]; then 
		$EDITOR $my_qtx_file
	else
		quetex $@
	fi
}
alias oqtx=qtxpp
alias lqtx=qtxpp


# ---------------------------------------------------------------------------------------------------
#  ASB/DSB/ESMA Stuff
# A collecion of functions to make manual testing and whatnot easier
# ---------------------------------------------------------------------------------------------------
alias goto-asb='cd /home/user/scollier/symbology/prd-progs-sym-feed-anna/asb'
alias goto-dsb='cd /home/user/scollier/symbology/prd-progs-sym-feed-anna/dsb'
alias goto-esma='cd /home/user/scollier/symbology/prd-progs-sym-feed-anna/esma'

function what-mode {
	echo "In ${ANNA_MODE} mode"
}
alias anna-mode=what-mode
function activate-asb {
	export ANNA_MODE=ASB
	what-mode
}
function activate-dsb {
	export ANNA_MODE=DSB
	what-mode
}
function activate-esma {
	export ANNA_MODE=ESMA
	what-mode
}

function process() (
	usage() {
		echo "    please use 'activate-asb' or 'activate-dsb' or 'activate-esma' to select a mode"
	}

	if [ -z "$ANNA_MODE" ]; then
		echo "Mode Not Set"
		usage
		return 1
	fi
	local process_script=''
	case $ANNA_MODE in
		ASB)
			process_script=/home/user/scollier/symbology/prd-progs-sym-feed-anna/asb/asb_daily_process/create_asbdaily_bcp_files.py
			;;
		DSB)
			process_script=/home/user/scollier/symbology/prd-progs-sym-feed-anna/dsb/dsb_daily_process/create_dsbdaily_bcp_files.py
			;;
		ESMA)
			process_script=/home/user/scollier/symbology/prd-progs-sym-feed-anna/esma/esma_daily_process/create_esmadaily_bcp_files.py
			;;
		*)
			echo "Unrecognised mode: '${ANNA_MODE}'"
			usage
			return 2
		;;
	esac
	pygd sym_mgr --quiet
	PYTHONPATH="/home/user/scollier/symbology/prd-progs-sym-feed-anna/lib:${PYTHONPATH}"
	python3 $process_script $@
)

function download() (
	usage() {
		echo "    please use 'activate-asb' or 'activate-dsb' or 'activate-esma' to select a mode"
	}

	if [ -z "$ANNA_MODE" ]; then
		echo "Mode Not Set"
		usage
		return 1
	fi
	case $ANNA_MODE in
		ASB)
			echo "Download not made for ASB"
			;;
		DSB)
			echo "Download not made for DSB"
			;;
		ESMA)
			sh /home/user/scollier/symbology/prd-progs-sym-feed-anna/esma/esma_daily_download/download_daily_esma_files.sh $@
			;;
		*)
			echo "Unrecognised mode: '${ANNA_MODE}'"
			usage
			return 2
		;;
	esac
	

)

function archive-anna { 
	if [ -z $1 ]; then
		local env=dev
	else
		local env=$1
	fi
	case $env in
		dev)
			cd /home/fonix/data2/sym/archive/anna
			;;
		stg)
			cd /home/fonix/data2/sym/stg/sym_feed_anna
			;;
		prod)
			cd /home/archive/sym/anna
			;;
		*)
			echo "Unrecognised environment ${env}, support envs are: dev/stg/prod"
			exit 1
		;;
	esac
}

# ---------------------------------------------------------------------------------------------------
#  DSB Stuff
# ---------------------------------------------------------------------------------------------------
function dtouch {
	cd $1
	date=$2
	touch Credit-${date}.records
	touch Commodities-${date}.records
	touch Equity-${date}.records
	touch Foreign_Exchange-${date}.records
	touch Rates-${date}.records
}



# ---------------------------------------------------------------------------------------------------
#  ESMA Stuff
# ---------------------------------------------------------------------------------------------------
function get_esma_files_date {
	local date=$1 # Expected format: YYYY-MM-DD
	local short_date=$(echo $1 | sed 's/-//g')
	local catalog_file=esma_catalog_${date}.json

	# Download the page that shows what is available between 00:00 and midnight of the given date
	echo "====================================================="
	echo "                    CATALOG"
	echo "====================================================="
	echo "Downloading catalog for date $date"
	wget -nv "https://registers.esma.europa.eu/solr/esma_registers_firds_files/select?q=*&fq=publication_date:[${date}T00:00:00Z+TO+${date}T23:59:59Z]&wt=json&indent=true&start=0&rows=100" -O $catalog_file 
	cat $catalog_file
	echo

	# Find all download links for the DELTA files (not the 
	echo "====================================================="
	echo "           DOWNLOADING ALL FILES"
	echo "====================================================="
	echo "Downloading all files for given date"
	for delta_file_url in $(grep -o 'http://.*zip' $catalog_file | grep 'FULINS'); do
		printf '  - '
		wget -nv $delta_file_url
		echo 
	done

	echo "====================================================="
	echo "           EXTRACT & FORMAT DATA"
	echo "====================================================="
	echo "Unzipping files and formatting results"
	total_instruments=0

	for zip_file in $(ls -1 | grep ${short_date} ); do
		echo "-----------------------------------------------------"
		echo "           $zip_file"
		echo "-----------------------------------------------------"
		local xml_file=$(echo $zip_file | sed 's/.zip$/.xml/')
		local formatted_xml_file=$(echo $zip_file | sed 's/.zip$/.formatted.xml/')
		
		if [ -e $formatted_xml_file ]; then 
			# We already have downloaded this file
			echo "SKIPPING EXTRACTION -  already downloaded"
			echo 
			echo
			continue
		fi

		unzip $zip_file
		echo

		xmllint --format $xml_file > $formatted_xml_file
		echo
	
		if [ "$2" == "--clean" ] || [ "$2" == "--cleanup" ] || [ "$3" == "--clean" ] || [ "$3" == "--cleanup" ] ;then
			echo "Cleaning all processing files, deleting:"
			echo "  - $zip_file"
			rm $zip_file

			echo "  - $xml_file"
			rm $xml_file 

			if [ -e $catalog_file ]; then 
				# The file will not exit round the second time and then error
				echo "  - $catalog_file"
				rm $catalog_file
			fi	
			echo
		fi
		
		echo "--[ Results ]--"
		new_instruments=$(grep -c '<FullNm>' $formatted_xml_file)
		echo "Datafile: $formatted_xml_file"
		echo "Instruments: $new_instruments"
		echo
		total_instruments=$(( $total_instruments + $new_instruments ))

	done
	echo "====================================================="
	echo "                       DONE!" 
	echo "====================================================="
	echo "Total instruments to process: $total_instruments"
}
export -f get_esma_files_date


function get_esma_files_date_range {
	local start_date=$1
	local end_date=$2
	
	local day=$start_date
	while [[ $day != $end_date ]]; do
		get_esma_files $day --cleanup

	    local day=$(date -I -d "$day + 1 day")
	done
}



# ---------------------------------------------------------------------------------------------------
#  Draw Wombat
# ---------------------------------------------------------------------------------------------------
blue=$(tput setaf 4)
normal=$(tput sgr0)
export normal
export blue

W_WIDTH=90
export W_WIDTH

function W_repeat {
	# Repeat the input arg $W_WIDTH times
	local char=$1
	if [ -z $2 ]; then
		local width=$W_WIDTH
	else
		local width=$2
	fi
	printf -v res %${width}s; printf '%s'  "${res// /${char}}"
}
export -f W_repeat

function draw_inner {
	local header=$1
	local body=${@:2}  # Cheeky array operator: skip the first two elements
	header_width=${#header}  # Cheeky String Operator usage (y)
	
	local inner_line=$(W_repeat '─' $(($W_WIDTH - $header_width - 6)) )
	printf "┃ %-${header_width}s ┌${inner_line}┐  ┃\n" ""
	printf "┃ %-$(($W_WIDTH - 3))s │  ┃\n" "$(printf "%-${header_width}s │ %s" "$header" "$body")"
	printf "┃ %-${header_width}s └${inner_line}┘  ┃\n"
}
export -f draw_inner

function draw_top {
	local activity=$1
	local meta=${@:2}	

	# Top Line
	local outer_line=$(W_repeat '━')
	echo -e "┏${outer_line}┓"

	# Header
	local blue_activity="${blue}${activity}${normal}"
	printf  "┃ %-$(($W_WIDTH + 9))s ┃\n" "$blue_activity - $meta"
}
export -f draw_top

function draw_bottom {
	local outer_line=$(W_repeat '━')
	echo -e "┗${outer_line}┛"
}
export -f draw_bottom



function draw_activity {
	local activity=$1
	local meta=$2
	local file=$3
	draw_top "$activity" "$meta"
	draw_inner "File" "$file"
	draw_bottom
}  
export -f draw_activity



