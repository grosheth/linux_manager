#!/bin/bash

function ProgressBar {
# Process data
	let _progress=(${1}*100/${2}*100)/100
	let _done=(${_progress}*4)/10
	let _left=40-$_done
# Build progressbar string lengths
	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\r ${3} : [${_done// /#}${_left// /-}] ${_progress}%%\n"

}

# Variables
_start=1

# This is the amount of tasks that needs to be done in the installation
_end=8

# String to append to .bashrc or zshrc

# Proof of concept
for number in $(seq ${_start} ${_end})
do
    # Changes permissions on mgr
    if [[ $number == 1 ]]; then
        steps="Setting_permissions"
        chmod 711 mgr
    fi

    # Changes permissions on uninstall script
    if [[ $number == 2 ]]; then
        steps="Setting_permissions"
        chmod 711 uninstall.sh
    fi

    # Create the .mgr folder
    if [[ $number == 3 ]]; then
        steps="Create_folder"
        mkdir $HOME/.mgr
        mkdir $HOME/.mgr/bin
    fi

    # Create the backup folder
    if [[ $number == 4 ]]; then
        steps="Create_backup_folder"
        mkdir $HOME/.mgr/backup
        mkdir $HOME/.mgr/logs
    fi

    # Create the files for backups
    if [[ $number == 5 ]]; then
        steps="create_backup_file"
        touch $HOME/.mgr/backup_list
        touch $HOME/.mgr/backup_location
        touch $HOME/.mgr/logs/log.out
        echo ${HOME}/.mgr/backup > ${HOME}/.mgr/backup_location
    fi

    # Create the file for services
    if [[ $number == 6 ]]; then
        steps="create_backup_file"
        touch $HOME/.mgr/services
    fi

    # Create the dependencies file
    if [[ $number == 7 ]]; then
        steps="Create_folder"
        touch $HOME/.mgr/dependencies
    fi

    # Copies mgr binary for local user
    if [[ $number == 8 ]]; then
        steps="Copying_files"
        
        cp -f mgr $HOME/.mgr/bin
    fi

	ProgressBar ${number} ${_end} ${steps}
done

TAG=$(git describe --tags | sed 's/[^0-9.]//g')
echo ${TAG} > $HOME/.mgr/VERSION

{
    COMMAND=$(which mgr)
}
CMD_RETURN_CODE=$?

if [ $CMD_RETURN_CODE == 0 ]; then
    echo "program is installed here: "
    which mgr
else
    app_str='alias mgr="$HOME/.mgr/bin/mgr"'
    
    # Check Shell
    if [[ $SHELL == *"bash"* ]]; then
        shell='bash'
    fi

    if [[ $SHELL == *"zsh"* ]]; then
        shell='zsh'
    fi

    echo "${app_str}" >> ~/.${shell}rc
    
    source ~/.${shell}rc
    
    echo "Done"
fi

exit 0
