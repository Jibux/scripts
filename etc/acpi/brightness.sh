#!/bin/bash

br=`cat /sys/class/backlight/acpi_video0/brightness`

if [ "$2" == "BRTUP" ]
then
	nextBr=`echo $br + 1 | bc`
elif [ "$2" == "BRTDN" ]
then
	nextBr=`echo $br - 1 | bc`
else
	logger "Unhandled brightness"
	exit
fi	

if [ "$nextBr" -gt 24 ]
then
	nextBr=24
elif [ "$nextBr" -lt 0 ]
then
	nextBr=0
fi

batteryStatus=`acpi -a | grep 'Adapter 0' | cut -d ' ' -f3`

if [ "$batteryStatus" == "on-line" ]
then
	echo $nextBr > /etc/acpi/brightness/ac
elif [ "$batteryStatus" == "off-line" ]
then
	echo $nextBr > /etc/acpi/brightness/battery
fi

logger "Set brightness $2. Current: $br. Next: $nextBr. Battery status: $batteryStatus"
echo $nextBr > /sys/class/backlight/acpi_video0/brightness

