#!/bin/bash


export DISPLAY=:0

/usr/bin/xinput --set-prop 11 "libinput Accel Speed" 1 &> /tmp/output_tata
/usr/bin/xinput list-props 11 &>> /tmp/output_tata


