#!/bin/bash

# First, install sudo
echo "Installing sudo..."
/bin/su - -c 'aptitude -y install sudo;visudo'

echo "Configuring sources.list"
sudo perl -pi -e 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo sh -c "echo '\ndeb http://backports.debian.org/debian-backports squeeze-backports main contrib non-free\n\n# Debian Multimedia (unofficial): Debian 6.0 (Squeeze)\ndeb http://www.debian-multimedia.org squeeze main non-free' >> /etc/apt/sources.list"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c "echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list"

echo "Install debian-multimedia-keyring..."
sudo apt-get --force-yes --yes install debian-multimedia-keyring

echo "Updating..."
sudo aptitude update
# INSTALL ALL REQUIRED PACKAGES
echo "Installing packages..."
sudo aptitude -y install git screen ssh-askpass
sudo aptitude -y install xorg fluxbox slim rxvt-unicode xdg-utils vim-gtk alsa-utils moc moc-ffmpeg-plugin network-manager libgconf2-4 libxss1 libcurl3 keychain flashplugin-nonfree google-chrome-stable myspell-fr-gut >> ~/install.log && sudo aptitude -y -t squeeze-backports install iceweasel-l10n-fr icedove-l10n-fr >> ~/install.log &

# PREPARE DIRECTORIES
echo "Preparing directories..."
mkdir -p ~/Documents/gitSave
mkdir ~/Music ~/scripts ~/bin

# SETUP SSH
echo "Setup ssh..."
ssh-keygen -t rsa -C "jeanb.hugon@gmail.com" -f ~/.ssh/id_rsa.github
echo -e "IdentityFile ~/.ssh/id_rsa\nIdentityFile ~/.ssh/id_rsa.github" >> ~/.ssh/config

# SETUP GIT
echo "Setup git..."
git config --global user.name "Jibux"
git config --global user.email jeanb.hugon@gmail.com

cd ~/Documents/gitSave
mkdir scripts
mkdir config
cd ~/Documents/gitSave/scripts
git init
git clone https://github.com/Jibux/scripts.git
git remote add upstream https://github.com/Jibux/scripts.git
git fetch upstream
git merge upstream/master
git remote add origin git@github.com:Jibux/scripts.git
cd ~/Documents/gitSave/config
git init
git clone https://github.com/Jibux/scripts.git
git remote add upstream https://github.com/Jibux/config.git
git fetch upstream
git merge upstream/master
git remote add origin git@github.com:Jibux/config.git

echo "Loading configuration..."
~/Documents/gitSave/scripts/git/load.sh

