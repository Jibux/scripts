#!/bin/bash

# Recover backuped brightness

batteryStatus=`acpi -a | grep 'Adapter 0' | cut -d ' ' -f3`

if [ "$batteryStatus" == "on-line" ]
then
	nextBr=`cat /etc/acpi/brightness/ac`
elif [ "$batteryStatus" == "off-line" ]
then
	nextBr=`cat /etc/acpi/brightness/battery`
fi

echo $nextBr > /sys/class/backlight/acpi_video0/brightness

