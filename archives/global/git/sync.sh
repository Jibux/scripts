#!/bin/bash

path=/home/jbh/Documents/gitSave

cd $path/config
git commit -m "update conf" ./
gitSync

cd $path/scripts
git commit -m "update scripts" ./
gitSync

