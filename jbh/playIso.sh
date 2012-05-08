#!/bin/sh

if test $# -lt 1
then
        echo "usage: $0 [source]"
        exit 0
fi


sudo mount -o loop -t iso9660 $1 /mnt/iso/
vlc /mnt/iso

