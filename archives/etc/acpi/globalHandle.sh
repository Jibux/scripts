#!/bin/bash

##############################################
# Don't handle events if some wm are running #
##############################################
# We can have wm: Fluxbox, Mutter (Gnome), Xfwm4

# Get the name of the caller script
caller=${1##*/}

# These environment variables are needed so that the script can post to the current display (using the zenity command for example)
export XAUTHORITY=/home/jbh/.Xauthority
export DISPLAY=:0.0

wm=`wmctrl -m | grep Name | awk '{print $2}'`

scriptLine=`grep $caller /etc/acpi/wmToHandle`

if [ -n "$wm" ]
then
	# Search for the wm
	if [[ "$scriptLine" =~ $caller:.*$wm.* ]]
	then
		# We found the wm, so we handle the event
		exit 1
	fi
else
	# No wm are running so we handle the event
	exit 1
fi

exit 0

