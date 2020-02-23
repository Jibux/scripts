#!/bin/bash

set -o errexit

fail()
{
	echo "$1"
	exit 1
}

usage()
{
	echo "$0 path_to_pictures"
}

ROOT_RAW="/mnt/data/JBH/Darktable"
ROOT_JPG="/mnt/data/Famille/Photos-Images"

RAW_EXT="RW2"
JPG_EXT="JPG"

[ "$#" != "1" ] && usage && exit 1


DIR_PATH=$1

[ ! -d "$DIR_PATH" ] && fail "'$DIR_PATH' is not a directory or does not exist"

DIR_NAME=$(basename "$DIR_PATH")
PATH_RAW="$ROOT_RAW/$DIR_NAME"
PATH_JPG="$ROOT_JPG/$DIR_NAME"

echo "mkdir '$PATH_RAW'"
[ ! -d "$PATH_RAW" ] && mkdir -p "$PATH_RAW"
echo "mkdir '$PATH_JPG'"
[ ! -d "$PATH_JPG" ] && mkdir -p "$PATH_JPG"

echo "mv *RW2"
find "$DIR_PATH" -maxdepth 1 -type f -name "*$RAW_EXT" -exec mv '{}' "$PATH_RAW" \;
echo "mv *JPG"
find "$DIR_PATH" -maxdepth 1 -type f -name "*$JPG_EXT" -exec mv '{}' "$PATH_JPG" \;

if [ -z "$(ls -A "$DIR_PATH")" ]; then
	echo "rmdir '$DIR_PATH'"
	rmdir "$DIR_PATH"
fi

