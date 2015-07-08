#! /bin/bash
clear

echo Mise a jour des sources.list
sleep 2
apt-get -y update && apt-get -y upgrade
clear

echo Installation de Sudo
sleep 2
apt-get -y install sudo
clear

echo Installation de Xorg
sleep 2

#Detection de la carte grapphique
vgaCard=`lspci -nvv|grep -i "virtualbox graphics"|wc -l`

apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
# Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.
if [ $vgaCard==1 ];then
    vbox=1
    if [ `lsmod | grep vboxguest|wc -l`==0 ];then
    wget https://raw.githubusercontent.com/beemoon/setupDeb/master/VBoxLinuxAdditions.run
    chmod u+x VBoxLinuxAdditions.run
    ./VBoxLinuxAdditions.run
    fi
fi
#apt-get -y install --no-install-recommends xserver-xorg-video-intel
clear

echo Installation de Openbox
sleep 2
apt-get -y install --no-install-recommends openbox obconf obmenu
clear

echo Installation de XTerm
sleep 2
apt-get -y install --no-install-recommends xterm
clear

echo Installation du gestionnaire de login
sleep 2
# SLiM est mort !!!
apt-get -y install --no-install-recommends lightdm
clear

echo Installation de Nitrogen
sleep 2
apt-get -y install --no-install-recommends nitrogen
clear

wget -P /usr/local/images/wallpapers https://raw.githubusercontent.com/beemoon/setupDeb/master/cyborg0.jpg
nitrogen --save --set-auto /usr/local/images/wallpapers/cyborg0.jpg

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
clear

echo Installation de Xarchiver
sleep 2
apt-get -y install --no-install-recommends xarchiver
clear

echo Installation de Terminator
sleep 2
apt-get -y install --no-install-recommends terminator
clear

if [ ! $vbox==1 ];then
    echo Installation du firmware iwlwifi
    sleep 2
    # Debian 8 "Jessie"
    echo "deb http://http.debian.net/debian/ jessie main contrib non-free" >> /etc/apt/sources.list
    apt-get -y update
    apt-get -y install --no-install-recommends firmware-iwlwifi wpasupplicant wicd
    clear
fi

echo Installation de deborphan
sleep 2
apt-get -y install --no-install-recommends deborphan
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

while read line  
do
    echo -e Installation de $line
    sleep 2
    apt-get -y install --no-install-recommends $line
    clear

done < packages.txt
