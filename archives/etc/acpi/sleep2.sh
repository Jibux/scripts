#!/bin/sh

tmpFile="/tmp/LOCK_SLEEP"

if [ -e $tmpFile ]
then
	exit
else
	touch $tmpFile
fi

isXstarted=`ps -ef | grep X | wc -l`

#  Check if X is started 
if [ "$isXstarted" -gt 1 ]
then
	logger "Lock screen"
	export XAUTHORITY=/home/jbh/.Xauthority
	export DISPLAY=:0.0
	xscreensaver-command -lock
fi

/usr/sbin/pm-suspend

sleep 5

rm $tmpFile

