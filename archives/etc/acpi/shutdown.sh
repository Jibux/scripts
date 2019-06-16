#!/bin/bash

/etc/acpi/globalHandle.sh $0
[[ $? -eq 0 ]] && exit 0


# Handle when the power button is pressed

tmpFile=/tmp/shutdown.script

[ -f $tmpFile ] && exit

touch $tmpFile

# These environment variables are needed so that the script can post to the current display (using the zenity command)
export XAUTHORITY=/home/jbh/.Xauthority
export DISPLAY=:0.0

#action=$(sudo -u jbh zenity --width=250 --height=250 --title "Dormir ou reboot ?" --list --text "Que voulez-vous faire ?" --radiolist --column "Choix" --column "Action" TRUE "1 - Arrêter" FALSE "2 - Redémarrer" FALSE "3 - Cuire un oeuf" FALSE "4 - Faire du café")

action=$(sudo -u jbh yad --center --width 300 --entry --title "System Logout" \
	--image=gnome-shutdown \
	--button="Switch User:2" \
	--button="gtk-ok:0" --button="gtk-close:1" \
	--text "Choose action:" \
	--entry-text \
	"Power Off" "Reboot" "Suspend" "Logout")
ret=$?

# Wait 1 sec to catch again this event
sleep 1 && rm $tmpFile &

[[ $ret -eq 1 ]] && exit 0

if [[ $ret -eq 2 ]]; then
	# What to to ?
	exit 0
fi


#if [ "$action" == "1 - Arrêter" ]
#then
#	/sbin/poweroff
#elif [ "$action" == "2 - Redémarrer" ]
#then
#	/sbin/reboot
#elif [ "$action" == "3 - Cuire un oeuf" ]
#then
#	sudo -u jbh zenity --title "Dormir ou reboot ?" --info --text "Nous n'avons malheureusement plus d'oeufs !"
#elif [ "$action" == "4 - Faire du café" ]
#then
#	sudo -u jbh zenity --title "Dormir ou reboot ?" --info --text "Et 1 café, 1 !"
#fi

case $action in
	Power*) cmd="/sbin/halt" ;;
	Reboot*) cmd="/sbin/reboot" ;;
	Suspend*) cmd="/usr/sbin/pm-suspend" ;;
	Logout*) 
	case $(wmctrl -m | grep Name) in
		*Fluxbox) cmd="killall fluxbox" ;;
		*Metacity) cmd="gnome-save-session --kill" ;; 
		*) exit 1 ;;
	esac ;;
	*) exit 1 ;;        
esac

eval exec $cmd

