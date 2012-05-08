#!/bin/bash

#########################
# LAUNCH WPA_SUPPLICANT #
#########################


# NORMAL
wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
# DAEMON
#sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B

# WICD
#wicd-curses

