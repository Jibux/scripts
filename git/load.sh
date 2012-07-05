#!/bin/bash

#############################################################
#                                                           #
# Require xorg fluxbox slim rxvt-unicode xdg vim screen moc #
#                                                           #
#############################################################

# 0 if $1 is not defined
updateDev=${1:-0}

home=/home/jbh
path=$home/Documents/gitSave


debTest=`which apt-get`
if [ -z "$debTest" ]
then
	debian=0
	vimPath=/etc/vimrc
	echo "It is not a debian"
else
	debian=1
	vimPath=/etc/vim/vimrc
	echo "It is a debian"
fi

#########################
# BACKUP ORIGINAL FILES #
#########################
for file in $home/.bashrc $home/.fluxbox/keys $home/.fluxbox/startup $home/.moc/config /etc/bash.bashrc $vimPath /etc/screenrc
do
	[[ -f "$file" && ! -f "$file.old" ]] && sudo rsync -a "$file" "$file.old"
done

###########
# CONFIGS #
###########
rsync -auv $path/config/.Xdefaults $home/
rsync -auv $path/config/.xsession $home/
rsync -auv $path/config/.xinitrc $home/
rsync -auv $path/config/.fluxbox/keys $home/.fluxbox/
rsync -auv $path/config/.fluxbox/startup $home/.fluxbox/
#rsync -auv $path/config/.fluxbox/overlay $home/.fluxbox/
rsync -auv $path/config/.moc/config $home/.moc/
rsync -auv $path/config/.bashrc $home/
[[ -f " /root/.bashrc" && ! -f "/root/.bashrc.old" ]] && sudo cp /root/.bashrc /root/.bashrc.old
sudo rsync -uv $path/config/.bashrc /root/
#rsync -auv $path/config/.bash_profile $home/
mkdir -p $home/.local/share/applications
rsync -auv $path/config/.local/share/applications/defaults.list $home/.local/share/applications/
rsync -auv $path/config/.local/share/applications/mimeapps.list $home/.local/share/applications/
rsync -auv $path/config/UTILES $home/

sudo rsync -uv $path/config/etc/bash.bashrc /etc/
sudo rsync -uv $path/config/etc/DIR_COLORS /etc/
sudo rsync -uv $path/config/etc/vimrc $vimPath
sudo rsync -uv $path/config/etc/screenrc /etc/
sudo rsync -uv $path/config/etc/slim.conf /etc/
#sudo rsync -uv $path/config/etc/rc.d/*custom /etc/rc.d/
#sudo rsync -uv $path/config/etc/rc.conf /etc/
sudo rsync -uv $path/config/etc/udev/rules.d/11-media-by-label-auto-mount.rules /etc/udev/rules.d/

sudo rsync -uv $path/config/usr/lib/urxvt/perl/clipboard /usr/lib/urxvt/perl/
sudo rsync -uv $path/config/usr/share/moc/themes/custom_theme /usr/share/moc/themes/

###########
# SCRIPTS #
###########
#rsync -auv $path/scripts/etc/acpi/ /etc/acpi/
#rsync -auv $path/scripts/root/ /scripts/
rsync -auv $path/scripts/jbh/gitSync.sh $home/scripts/
rsync -auv $path/scripts/git/update.sh $home/Documents/gitSave/ 
rsync -auv $path/scripts/git/sync.sh $home/Documents/gitSave/ 
rsync -auv $path/scripts/git/load.sh $home/Documents/gitSave/

#######################
# SYM LINK TO SCRIPTS #
#######################
cd $home/bin/
ln -sf ../scripts/gitSync.sh gitSync

