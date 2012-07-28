#!/bin/bash

devDirectory="/home/jbh/Documents/Development"
saveDirectory="/mnt/data/JBH/Informatique/Unix/Developement"

rsync -auv $devDirectory/TOSAVE $saveDirectory/
cd $devDirectory
for folder in `cat TOSAVE`
do
	tar -cvjf $saveDirectory/$folder.tar.bz2 $folder
done

