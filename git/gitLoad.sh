#!/bin/bash

# 0 if $1 is not defined
updateDev=${1:-0}

home=/home/jbh

###########
# CONFIGS #
###########
rsync -auv config/.Xdefaults $home/
rsync -auv config/.xsession $home/
rsync -auv config/.xinitrc $home/
rsync -auv config/.fluxbox/keys $home/.fluxbox/
rsync -auv config/.fluxbox/overlay $home/.fluxbox/
rsync -auv config/.bashrc $home/
rsync -auv config/.bash_profile $home/
rsync -auv config/.local/share/applications/defaults.list $home/.local/share/applications/
rsync -auv config/.local/share/applications/mimeapps.list $home/.local/share/applications/
rsync -auv config/UTILES config/

rsync -auv config/etc/bash.bashrc /etc/
rsync -auv config/etc/DIR_COLORS /etc/
rsync -auv config/etc/vimrc /etc/
rsync -auv config/etc/screenrc /etc/
rsync -auv config/etc/rc.d/*custom /etc/rc.d/
rsync -auv config/etc/rc.conf /etc/
rsync -auv config/etc/udev/rules.d/11-media-by-label-auto-mount.rules /etc/udev/rules.d/

rsync -auv config/usr/lib/urxvt/perl/clipboard /usr/lib/urxvt/perl/
rsync -auv config/usr/share/moc/themes/custom_theme /usr/share/moc/themes/

###########
# SCRIPTS #
###########
rsync -auv scripts/etc/acpi/ /etc/acpi/
rsync -auv scripts/root/ scripts/
rsync -auv scripts/jbh/ $home/scripts/
rsync -auv scripts/git/gitUpdate.sh $home/Documents/gitSave/update.sh 
rsync -auv scripts/git/gitSync.sh $home/Documents/gitSave/sync.sh 
rsync -auv scripts/git/gitLoad.sh $home/Documents/gitSave/load.sh

