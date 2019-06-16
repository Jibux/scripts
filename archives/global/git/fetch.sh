#!/bin/bash

path=/home/jbh/Documents/gitSave

cd $path/config
git	fetch upstream
git merge upstream/master

cd $path/scripts
git	fetch upstream
git merge upstream/master


