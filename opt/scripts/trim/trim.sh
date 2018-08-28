#!/bin/bash


ROOT=/opt/scripts/trim
LAST_TRIM_TIME_FILE=$ROOT/LAST_TRIM_TIME

if [ ! -f "$LAST_TRIM_TIME_FILE" ]; then
	echo "$0 running for the first time"
	LAST_TRIM_TIME=0
else
	LAST_TRIM_TIME=$(cat $LAST_TRIM_TIME_FILE)
fi

TIME=$(date +%s)
TIME_DIFF=$(($TIME - $LAST_TRIM_TIME))
# 3600 * 24 * 7 = 7 days
MAX_TRIM_TIME=$((3600*24*7))

if [ $TIME_DIFF -lt $MAX_TRIM_TIME ]; then
	echo "It is too early to trim ($TIME_DIFF < $MAX_TRIM_TIME)"
	exit 0
fi

PART_TO_TRIM="/ /home"

for part in $PART_TO_TRIM; do
	echo "Trim partition $part"
	fstrim -v $part
done

date +%s > $LAST_TRIM_TIME_FILE

exit 0

