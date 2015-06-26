#! /bin/bash
clear

echo Installation de Sudo
sleep 2
apt-get -y install sudo
clear

echo Installation de Xorg
sleep 2


vgaCard=`lspci -nvv|grep -i "virtualbox graphics"|wc -l`

apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
#apt-get -y install --no-install-recommends xserver-xorg-video-intel
# Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.
if [ $vgaCard==1 ];then 
    wget https://github.com/beemoon/setupDeb/blob/master/setupDebian.sh
    ./VBoxLinuxAdditions.run
fi
exit
clear

echo Installation de Openbox
sleep 2
apt-get -y install --no-install-recommends openbox obconf obmenu
clear

echo Installation du gestinnaire de login
sleep 2
# SLiM est mort !!!
apt-get -y install --no-install-recommends lightdm
clear

echo Installation de deborphan
sleep 2
apt-get -y install --no-install-recommends deborphan
clear

echo Installation de Iceweasel
sleep 2
apt-get -y install --no-install-recommends iceweasel
clear

echo Installation de geany
sleep 2
apt-get -y install --no-install-recommends geany
clear

echo Installation de Thunar
sleep 2
apt-get -y install --no-install-recommends thunar thunar-archive-plugin thunar-volman exfat-utils gvfs gvfs-backends
#apt-get -y install --no-install-recommends thunar-archive-plugin
#apt-get -y install --no-install-recommends thunar-volman
#apt-get -y install --no-install-recommends exfat-utils gvfs
##pour le montage de samba (CIFS)
#apt-get -y install --no-install-recommends gvfs-backends
clear

echo Installation de Xarchiver
sleep 2
apt-get -y install --no-install-recommends xarchiver
clear

echo Installation de Terminator
sleep 2
apt-get -y install --no-install-recommends terminator
clear

echo Installation du firmware iwlwifi
sleep 2
# Debian 8 "Jessie"
#deb http://http.debian.net/debian/ jessie main contrib non-free
#apt-get -y install --no-install-recommends firmware-iwlwifi wpasupplicant wicd
clear

echo Installation de Nitrogen
sleep 2
apt-get -y install --no-install-recommends nitrogen
clear

echo Installation de Tint2
sleep 2
apt-get -y install --no-install-recommends tint2
clear

echo Installation de Conky
sleep 2
apt-get -y install --no-install-recommends conky
clear

echo Installation de Icedove
sleep 2
apt-get -y install --no-install-recommends icedove
clear

echo Installation du son avec Alsa
sleep 2
apt-get -y install --no-install-recommends pavucontrole  
#apt-get -y install --no-install-recommends libasound2 alsa-base alsa-utils alsa-oss 
clear

