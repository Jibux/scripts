#!/bin/bash

#####################################
# AUTO GENERATE XDG CONF FOR A FILE #
#####################################


filename=$1
application=$2

function usage {
	echo "Usage: $0 filename application"
}

[ $# -lt 2 ] && usage && exit
[ ! -f "$filename" ] && echo "$filename doesn't exist" && exit

echo "Filename: $filename"
echo "Application: $application"

location=`which $application`
[ -z "$location" ] && echo "Cannot find location for $application" && exit

mimetype=`mimetype "$filename" | awk '{print $NF}'`
echo "mimetype: $mimetype"
mimetype2=`xdg-mime query filetype "$filename" | cut -d ';' -f1`
echo "mimetype2: $mimetype2"

defApp=`xdg-mime query default $mimetype`
echo "Default application: $defApp"
defApp2=`xdg-mime query default $mimetype2`
echo "Default application2: $defApp2"

xdg-mime default $application.desktop $mimetype

