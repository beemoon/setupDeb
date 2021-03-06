#! /bin/bash
clear

function pause(){
echo
read -s -n1 -p "Appuyez sur une touche pour continuer..."
echo
echo
}

echo Mise a jour des sources.list
sleep 2
echo
apt-get -y update && apt-get -y upgrade
sleep 2
clear

echo Installation de Sudo
sleep 2
echo
apt-get -y install sudo
sleep 2
clear

echo Installation de SSH serveur
sleep 2
echo
apt-get -y install openssh-server
sleep 2
clear

#Detection de la carte graphique
vgaCard=`lspci|grep -i "virtualbox graphics"|wc -l`
echo -e Installation du mode graphique
echo
apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
# Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.

if [ $vgaCard -eq 1 ];then
    vbox=1
    if [ `lsmod | grep vboxguest|wc -l` -eq 0 ];then
    	if [ -e VBoxLinuxAdditions.run ];then
     		rm -f VBoxLinuxAdditions*
    	fi 
	apt-get -y install make
    	echo
	wget https://raw.githubusercontent.com/beemoon/setupDeb/master/VBoxLinuxAdditions.run
    	chmod u+x VBoxLinuxAdditions.run
    	./VBoxLinuxAdditions.run
    fi
fi
#apt-get -y install --no-install-recommends xserver-xorg-video-intel
sleep 2
clear

echo Installation de Openbox
sleep 2
apt-get -y install --no-install-recommends openbox obconf obmenu
sleep 2
clear

if [ $vbox -ne 1 ];then
    echo Installation du firmware iwlwifi
    sleep 2
    # Debian 8 "Jessie"
    echo "deb http://http.debian.net/debian/ jessie main contrib non-free" >> /etc/apt/sources.list
    apt-get -y update
    apt-get -y install --no-install-recommends firmware-iwlwifi wpasupplicant wicd
    sleep 2
    clear
fi

echo Installation de Terminator
sleep 2
apt-get -y install --no-install-recommends terminator
sleep 2
clear

echo Installation du gestionnaire de login
sleep 2
# SLiM est mort !!!
apt-get -y install --no-install-recommends lightdm
sleep 2
clear

echo Installation de Nitrogen
sleep 2
wget -P /usr/local/images/wallpapers https://raw.githubusercontent.com/beemoon/setupDeb/master/cyborg0.jpg
apt-get -y install --no-install-recommends nitrogen
nitrogen --save --set-auto /usr/local/images/wallpapers/cyborg0.jpg
sleep 2
clear

echo Installation de Iceweasel
sleep 2
apt-get -y install --no-install-recommends iceweasel
sleep 2
clear

echo Installation de geany
sleep 2
apt-get -y install --no-install-recommends geany
sleep 2
clear

echo Installation de Thunar
sleep 2
apt-get -y install --no-install-recommends thunar thunar-archive-plugin thunar-volman exfat-utils gvfs gvfs-backends
sleep 2
clear

echo Installation de Xarchiver
sleep 2
apt-get -y install --no-install-recommends xarchiver
sleep 2
clear

echo Installation de deborphan
sleep 2
apt-get -y install --no-install-recommends deborphan
sleep 2
clear

echo Installation de Tint2
sleep 2
apt-get -y install --no-install-recommends tint2
sleep 2
clear

echo Installation de Conky
sleep 2
apt-get -y install --no-install-recommends conky
sleep 2
clear

echo Installation de Icedove
sleep 2
apt-get -y install --no-install-recommends icedove
sleep 2
clear

echo Installation du son avec Alsa
sleep 2
apt-get -y install --no-install-recommends libasound2 alsa-base alsa-utils alsa-oss pavucontrol
sleep 2
clear


##################################
# Paquets actuellement installes #
dpkg --get-selections >mesPaquets.txt
sleep 2
clear

echo -e Liste des paquets a installer
sleep 2
if [ -e packages.txt ];then
	rm -f packages.* 
fi 
wget https://raw.githubusercontent.com/beemoon/setupDeb/dev/packages.txt

# Difference avec les paquets demandes
if [ -e diff.txt ]; then rm -f diff.*; fi
while read ligne
do  
	if [ `grep $ligne mesPaquets.txt|wc -l` -eq 0 ];
	then
		echo $ligne>>diff.txt
		echo $ligne
	fi

done < packages.txt
rm -f mesPaquets.txt
sleep 2
clear

if [ -e diff.txt ];
then

while read line  
do
    echo -e Installation de $line
    echo
    sleep 2

    apt-get -y install --no-install-recommends $line
    echo

done < diff.txt
rm -f diff.txt

else
echo Il n\'y a rien a installer
echo
fi

rm -f packages.txt
history -c
