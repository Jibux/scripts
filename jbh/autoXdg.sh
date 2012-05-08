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

location=`whereis $application |cut -d ':' -f2`
[ -z "$location" ] && echo "Cannot find location for $application" && exit

mimetype=`mimetype $filename | cut -d ' ' -f2`
echo "mimetype: $mimetype"

defApp=`xdg-mime query default $mimetype`
echo "Default application: $defApp"

xdg-mime default $application.desktop $mimetype

