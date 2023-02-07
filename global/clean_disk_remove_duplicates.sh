#!/bin/bash

#######################################################################
# Remove duplicate files from a path.                                 #
# Analyse file after file and compare md5 of a file to the next file. #
# Then move duplicate files into another directory.                   #
#######################################################################

FILE_PATH=/media/jibux/WD-JBH/RECUP/
DOUBLES_PATH=/media/jibux/WD-JBH/RECUP_DOUBLES/

cd ${FILE_PATH}

old_md5=""

ls -r | while read file; do
	md5=$(md5sum "$file" | awk '{print $1}')
	if [ "${md5}" == "${old_md5}" ]; then
		echo "mv ${file}"
		mv "${file}" ${DOUBLES_PATH}
	fi
	old_md5="${md5}"
done

