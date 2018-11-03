#!/bin/bash
#
# When adding (or removing) any functions remember to update
# the 'install_thirdparty' function below to reflect any changes you make

# Automatically import apps functions
function import_apps_functions() {
	DIR="functions/apps"
	# iterate through the files in the 'functions/apps' folder
	for FUNCTION in $(dirname "$0")/$DIR/*; do
		if [[ -d $FUNCTION ]]; then
			continue
		elif [[ -f $FUNCTION ]]; then
			# source the function file
			. $FUNCTION
		fi
	done
}

# Install Third-Party Applications
function install_thirdparty() {
	NAME="Third-Party Software"
	echo_message title "Starting installation of ${NAME,,}..."
	import_apps_functions
	# Draw window
	THIRDPARTY=$(eval $(resize) && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhat ${NAME,,} would you like to install?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'install_wakatime' 'Wakatime' \
		'install_mariadb' 'MariaDB + MySQL Workbench' \
		'install_nvm' 'Node Version Manager' \
		'install_mongodb' 'MongoDB + MongoDB Compass' \
		3>&1 1>&2 2>&3)

	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$THIRDPARTY' function..."
		$THIRDPARTY
	else
		# Cancelled
		echo_message info "Installation of ${NAME,,} cancelled."
		main
	fi
}
