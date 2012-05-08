#!/bin/bash

eval `keychain --eval id_rsa.git`
git push -u origin master

