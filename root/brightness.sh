#!/bin/bash

# Print actual level of brightness
echo -n "Current level of brightness: "
cat /sys/class/backlight/acpi_video0/actual_brightness

