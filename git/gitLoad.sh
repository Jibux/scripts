#!/bin/bash

# 0 if $1 is not defined
updateDev=${1:-0}

home=/home/jbh
path=$home/Documents

###########
# CONFIGS #
###########
rsync -auv $path/config/.Xdefaults $home/
rsync -auv $path/config/.xsession $home/
rsync -auv $path/config/.xinitrc $home/
rsync -auv $path/config/.fluxbox/keys $home/.fluxbox/
rsync -auv $path/config/.fluxbox/overlay $home/.fluxbox/
rsync -auv $path/config/.bashrc $home/
rsync -auv $path/config/.bash_profile $home/
rsync -auv $path/config/.local/share/applications/defaults.list $home/.local/share/applications/
rsync -auv $path/config/.local/share/applications/mimeapps.list $home/.local/share/applications/
rsync -auv $path/config/UTILES config/

rsync -auv $path/config/etc/bash.bashrc /etc/
rsync -auv $path/config/etc/DIR_COLORS /etc/
rsync -auv $path/config/etc/vimrc /etc/
rsync -auv $path/config/etc/screenrc /etc/
rsync -auv $path/config/etc/rc.d/*custom /etc/rc.d/
rsync -auv $path/config/etc/rc.conf /etc/
rsync -auv $path/config/etc/udev/rules.d/11-media-by-label-auto-mount.rules /etc/udev/rules.d/

rsync -auv $path/config/usr/lib/urxvt/perl/clipboard /usr/lib/urxvt/perl/
rsync -auv $path/config/usr/share/moc/themes/custom_theme /usr/share/moc/themes/

###########
# SCRIPTS #
###########
rsync -auv $path/scripts/etc/acpi/ /etc/acpi/
rsync -auv $path/scripts/root/ /scripts/
rsync -auv $path/scripts/jbh/ $home/scripts/
rsync -auv $path/scripts/git/gitUpdate.sh $home/Documents/gitSave/update.sh 
rsync -auv $path/scripts/git/gitSync.sh $home/Documents/gitSave/sync.sh 
rsync -auv $path/scripts/git/gitLoad.sh $home/Documents/gitSave/load.sh

