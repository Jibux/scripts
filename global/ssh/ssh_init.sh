#!/bin/bash


key="$(ssh-add -l | grep id_rsa)"

if [ "$key" == "" ]; then
	ssh-add ~/.ssh/id_rsa
fi

