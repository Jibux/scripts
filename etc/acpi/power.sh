#!/bin/sh

# Handle brightness in terms of battery status
nbArg=$#
arg=${!nbArg}
if [ "$arg" == "00000000" ]
then
	br=`cat /etc/acpi/brightness/battery`
elif [ "$arg" == "00000001" ]
then
	br=`cat /etc/acpi/brightness/ac`
fi

echo $br > /sys/class/backlight/acpi_video0/brightness

test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/policy-funcs

if [ -z "$*" ] && ( [ `CheckPolicy` = 0 ] || CheckUPowerPolicy ); then
    exit;
fi

pm-powersave $*

