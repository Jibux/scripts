#!/bin/sh

test -f /usr/share/acpi-support/state-funcs || exit 0

. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
. /etc/default/acpi-support

[ -x /etc/acpi/local/lid.sh.pre ] && /etc/acpi/local/lid.sh.pre

if [ `CheckPolicy` = 0 ]; then exit; fi

grep -q closed /proc/acpi/button/lid/*/state
if [ $? = 0 ]
then
    if [ x$LID_SLEEP = xtrue ]; then
        [ -x /etc/acpi/sleep.sh ] && /etc/acpi/sleep.sh
        exit
    fi
    for x in /tmp/.X11-unix/*; do
	displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
	getXuser;
	if [ x"$XAUTHORITY" != x"" ]; then
	    export DISPLAY=":$displaynum"	    
	    . /usr/share/acpi-support/screenblank
	else
	    [ -x /usr/sbin/vbetool ] && /usr/sbin/vbetool dpms off
	fi
    done
else
    for x in /tmp/.X11-unix/*; do
	displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
	getXuser;
	if [ x"$XAUTHORITY" != x"" ]; then
	    export DISPLAY=":$displaynum"
	    grep -q off-line /proc/acpi/ac_adapter/*/state
	    if [ $? = 1 ]
		then
		if pidof xscreensaver > /dev/null; then 
		    su $user -s /bin/sh -c "xscreensaver-command -unthrottle"
		fi
	    fi
	    if [ x$RADEON_LIGHT = xtrue ]; then
		[ -x /usr/sbin/radeontool ] && radeontool light on
	    fi
	    if [ `pidof xscreensaver` ]; then
		su $user -s /bin/sh -c "xscreensaver-command -deactivate"
	    fi
	    case "$DISPLAY_DPMS" in
		xset)
	    su $user -s /bin/sh -c "xset dpms force on"
			;;
		xrandr)
			su $user -s /bin/sh -c "xrandr --output LVDS --auto"
			;;
		vbetool)
			/usr/sbin/vbetool dpms on
			;;
	    esac
	else
	    [ -x /usr/sbin/vbetool ] && /usr/sbin/vbetool dpms on
	fi
    done
fi
[ -x /etc/acpi/local/lid.sh.post ] && /etc/acpi/local/lid.sh.post

