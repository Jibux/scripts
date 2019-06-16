#!/bin/bash


ROOT="/mnt/data/JBH/Darktable/"
PWD="$(pwd -P)"

FOLDER="${PWD##*$ROOT}"
DESTINATION="/mnt/data/Famille/Photos-Images/$FOLDER"

rsync -av ./darktable_exported/*jpg "$DESTINATION/"

