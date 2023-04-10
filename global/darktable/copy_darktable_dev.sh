#!/bin/bash


ROOT="/mnt/data/JBH/Darktable/"
PWD="$(pwd -P)"

FOLDER="${PWD##*$ROOT}"
DESTINATION="/data/Photos-Images/Famille/$FOLDER"

rsync -av ./darktable_exported/*jpg "$DESTINATION/"

