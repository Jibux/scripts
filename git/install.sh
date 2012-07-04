#!/bin/bash

# First, install sudo
/bin/su - -c 'aptitude install sudo;visudo'

sudo perl -pi -e 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo echo -e "\ndeb http://backports.debian.org/debian-backports squeeze-backports main contrib non-free" >> /etc/apt/sources.list
sudo aptitude update

# INSTALL ALL REQUIRED PACKAGES
sudo aptitude install git xorg fluxbox slim rxvt-unicode xdg-utils vim-gtk screen alsa-utils moc moc-ffmpeg-plugin network-manager libgconf2-4 libxss1 libcurl3 ssh-askpass keychain flashplugin-nonfree

# PREPARE DIRECTORIES
mkdir -p ~/Documents/gitSave
mkdir ~/Music ~/scripts ~/bin

# SETUP SSH
ssh-keygen -t rsa -C "jeanb.hugon@gmail.com" -f ~/.ssh/id_rsa.github
echo -e "IdentityFile ~/.ssh/id_rsa\nIdentityFile ~/.ssh/id_rsa.github" >> ~/.ssh/config

# SETUP GIT
cd ~/Documents/gitSave
mkdir scripts
mkdir config
cd ~/Documents/gitSave/scripts
git remote add upstream https://github.com/Jibux/scripts.git
git fetch upstream
git remote set-url origin git@github.com:Jibux/scripts.git
cd ~/Documents/gitSave/config
git remote add upstream https://github.com/Jibux/config.git
git fetch upstream
git remote set-url origin git@github.com:Jibux/config.git


# EXTRAS
aptitude -t squeeze-backports install iceweasel icedove libreoffice

