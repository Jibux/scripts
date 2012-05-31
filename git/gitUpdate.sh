#!/bin/bash

###########
# CONFIGS #
###########
rsync -auv /home/jbh/.Xdefaults config/
rsync -auv /home/jbh/.xsession config/
rsync -auv /home/jbh/.xinitrc config/
rsync -auv /home/jbh/.bashrc config/
rsync -auv /home/jbh/.bash_profile config/
rsync -auv /home/jbh/.local/share/applications/defaults.list config/.local/share/applications/
rsync -auv /home/jbh/.local/share/applications/mimeapps.list config/.local/share/applications/
rsync -auv /home/jbh/UTILES config/

rsync -auv /etc/bash.bashrc config/etc/
rsync -auv /etc/DIR_COLORS config/etc/
rsync -auv /etc/vimrc config/etc/
rsync -auv /etc/screenrc config/etc/
rsync -auv /etc/rc.d/*custom config/etc/rc.d/
rsync -auv /etc/rc.conf config/etc/
rsync -auv /etc/udev/rules.d/11-media-by-label-auto-mount.rules config/etc/udev/rules.d/

rsync -auv /usr/lib/urxvt/perl/clipboard config/usr/lib/urxvt/perl/
rsync -auv /usr/share/moc/themes/custom_theme config/usr/share/moc/themes/

###########
# SCRIPTS #
###########
rsync -auv --delete /etc/acpi/ scripts/etc/acpi/
rsync -auv --delete /scripts/ scripts/root/
rsync -auv --delete /home/jbh/scripts/ scripts/jbh/
rsync -auv /home/jbh/Documents/gitSave/update.sh scripts/git/gitUpdate.sh
rsync -auv /home/jbh/Documents/gitSave/sync.sh scripts/git/gitSync.sh

###############
# DEVELOPMENT #
###############
rsync -auv /home/jbh/Documents/Development/TOSAVE Development/
cd /home/jbh/Documents/Development/
for folder in `cat TOSAVE`
do
	tar -cvjf /home/jbh/Documents/gitSave/Development/$folder.tar.bz2 $folder
	gpg2 -r Fennec --encrypt /home/jbh/Documents/gitSave/Development/$folder.tar.bz2
	rm /home/jbh/Documents/gitSave/Development/$folder.tar.bz2
done

