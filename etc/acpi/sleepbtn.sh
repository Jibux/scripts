#!/bin/sh

# This script is part of the KEY TRANSLATION part of acpi-support. Compare with
# sleep.sh, which is part of the SUSPEND part of acpi-support. This script is
# intended to translate a key event which is not seen as a suspend key press by
# the rest of the system.


test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/policy-funcs

if [ `CheckPolicy` = 0 ]; then
  # If gnome-power-manager or klaptopdaemon are running, generate the X "sleep"
  # key. The daemons will handle that keypress according to their settings.

  # (Since this script is called only when a key is pressed that is *not* seen
  # as a suspend key by the rest of the system, we still need to do this
  # translation here.)
  
  . /usr/share/acpi-support/key-constants
  acpi_fakekey $KEY_SLEEP 
else
  # No power management daemons are running. Divert to our own implementation.

  # Note that sleep.sh assumes that the pressed key is also seen by the rest
  # of the system. However, it will choose the right path (our own
  # implementation) if CheckPolicy != 0, which is exactly what we want. And this
  # way we have a single user-configurable point for how we do suspend. (Not
  # that that's nice, but until we have pluggable suspend methods this is the
  # way to go.)
  
  /etc/acpi/sleep.sh
fi

