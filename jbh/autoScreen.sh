#!/bin/bash

number=`screen -list | grep auto | wc -l`
detached=`screen -list | grep auto | grep Detached | wc -l`

if [ $number == 0 ]
then
	screen -S auto
#elif [ $number == 1 -a $detached == 1 ]
elif [ $number == 1 ]
then
	screen -x auto
elif [ $number -gt 1 ]
then
	screen -list
	echo "Cannot choose the right screen"
fi

