#!/bin/sh

/etc/acpi/globalHandle.sh $0
[[ $? -eq 0 ]] && exit 0


/etc/acpi/sleep2.sh

