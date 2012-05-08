#!/bin/bash

action=$1

current=$(amixer get Master | grep Left: | cut -d ' ' -f6)
off=$(amixer get Master | grep off | wc -l)

if [ $off -gt 0 ]
then
	isMute=1
else
	isMute=0
fi

case "$action" in
	button/volumeup)
		if [ $isMute -eq 1 ]
		then
			sudo -u jbh amixer set Master toggle
		fi
	    amixer set Master 1%+ ;;
	button/volumedown)
		if [ $current -eq 0 -a $isMute -eq 0 ]
		then
			sudo -u jbh amixer set Master toggle
		fi
    	amixer set Master 1%- ;;
	*)
		logger "Volume control: action '$action' not handled" ;;
esac


