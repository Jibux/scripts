#!/bin/bash

# Print actual level of brightness
echo -n "Actual level of brightness: "
cat /sys/class/backlight/acpi_video0/actual_brightness

