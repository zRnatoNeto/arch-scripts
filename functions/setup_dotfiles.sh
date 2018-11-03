#!/bin/bash

# Set preferred bash aliased by copying the 'bash_aliases.sh' file to ~/.bash_aliases
function write_bash_aliases() {
	# Check list
	INPUT=$(dirname "$0")'/data/config/bash_aliases.sh'
	# Draw window
	if (eval $(resize) && whiptail \
		--title "Preferred Bash Aliases" \
		--yesno "Current list of preferred bash aliases: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nProceed?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Setting bash aliases..."
		# simply copy the list file to the aliases file
		cp $INPUT ~/.bash_aliases
		echo_message success "Bash aliases set successfully."
		whiptail --title "Finished" --msgbox "Bash aliases set successfully." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

# Configure environment variables by copying the 'bash_profile.sh' file to ~/.bash_profile
function write_bash_profile() {
	# Check list
	INPUT=$(dirname "$0")'/data/config/bash_profile.sh'
	# Draw window
	if (eval $(resize) && whiptail \
		--title "Configure Environment Variables" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.bash_profile..."
		# simply copy the list file to the aliases file
		cp $INPUT ~/.bash_profile
		echo_message success "Environment variables successfully configured."
		whiptail --title "Finished" --msgbox "Environment variables successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

# Configure bash profile by copying the 'bashrc.sh' file to ~/.bashrc
function write_bashrc() {
	# Check list
	INPUT=$(dirname "$0")'/data/config/bashrc.sh'
	# Draw window
	if (eval $(resize) && whiptail \
		--title "Configure Bash" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.bashrc..."
		# simply copy the list file to the aliases file
		cp $INPUT ~/.bashrc
		echo_message success "Bash successfully configured."
		whiptail --title "Finished" --msgbox "Bash successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

# Configure text editors by copying the '.editorconfig' file to ~/.editorconfig
function write_editorconfig() {
	# Check list
	INPUT=$(dirname "$0")'/data/config/.editorconfig'
	# Draw window
	if (eval $(resize) && whiptail \
		--title "Configure Text editors" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.editorconfig..."
		# simply copy the list file to the aliases file
		cp $INPUT ~/.editorconfig
		echo_message success "Text editors successfully configured."
		whiptail --title "Finished" --msgbox "Text editors successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

# Configure pacman by copying the 'pacman.conf' file to /etc/pacman.conf
function write_pacman_conf() {
	# Check list
	INPUT=$(dirname "$0")'/data/config/pacman.conf'
	# Draw window
	if (eval $(resize) && whiptail \
		--title "Configure Pacman" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting /etc/pacman.conf..."
		# simply copy the list file to the aliases file
		superuser_do "cp $INPUT /etc/pacman.conf"
		echo_message success "Pacman successfully configured."
		whiptail --title "Finished" --msgbox "Pacman successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

# Install custom dotfiles
function setup_dotfiles() {
	NAME="System Configuration"
	echo_message title "Starting ${NAME,,}..."
	# Draw window
	CONFIGURE=$(eval $(resize) && whiptail \
		--notags \
		--title "$NAME" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'write_bash_profile' 'Configure environment variables' \
		'write_bash_aliases' 'Set custom Bash aliases' \
		'write_bashrc' 'Set custom Bash preferences' \
		'write_editorconfig' 'Set custom editor config' \
    'write_pacman_conf' 'Set custom pacman config' \
		3>&1 1>&2 2>&3)
	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$CONFIGURE' function"
		$CONFIGURE
	else
		# Cancelled
		echo_message info "$NAME cancelled."
		main
	fi
}
