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
_end=2

# Proof of concept
for number in $(seq ${_start} ${_end})
do
    # removing binary
    if [[ $number == 1 ]]; then
        steps="removing_binary"
        rm $HOME/.local/bin/mgr
        rm /usr/bin/mgr
    fi

    # removing home folder
    if [[ $number == 2 ]]; then
        steps="removing_folder"
        # Add verification if ~/.mgr should be removed
        rm -rf $HOME/.mgr
    fi

	ProgressBar ${number} ${_end} ${steps}
done

{
    COMMAND=$(which mgr)
}
CMD_RETURN_CODE=$?

if [ $CMD_RETURN_CODE == 0 ]; then
    echo "program is still installed here: "
    which mgr
else
    echo "Program removed"
fi

