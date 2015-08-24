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
pause
clear

echo Installation de Sudo
sleep 2
echo
apt-get -y install sudo
pause
clear

echo Installation de SSH serveur
sleep 2
echo
apt-get -y install openssh-server
pause
clear

#Detection de la carte graphique
vgaCard=`lspci|grep -i "virtualbox graphics"|wc -l`
echo -e Installation du mode graphique
echo
apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
# Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.

if [ $vgaCard -eq 1 ];then
    vbox=1
    if [ `lsmod | grep vboxguest|wc -l` == 0 ];then
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
pause
clear

echo Installation de Openbox
sleep 2
apt-get -y install --no-install-recommends openbox obconf obmenu
pause
clear

if [ $vbox -ne 1 ];then
    echo Installation du firmware iwlwifi
    sleep 2
    # Debian 8 "Jessie"
    echo "deb http://http.debian.net/debian/ jessie main contrib non-free" >> /etc/apt/sources.list
    apt-get -y update
    apt-get -y install --no-install-recommends firmware-iwlwifi wpasupplicant wicd
    pause
    clear
fi

echo Installation de Terminator
sleep 2
apt-get -y install --no-install-recommends terminator
pause
clear

echo Installation du gestionnaire de login
sleep 2
# SLiM est mort !!!
apt-get -y install --no-install-recommends lightdm
pause
clear

echo Installation de Nitrogen
sleep 2
wget -P /usr/local/images/wallpapers https://raw.githubusercontent.com/beemoon/setupDeb/master/cyborg0.jpg
apt-get -y install --no-install-recommends nitrogen
nitrogen --save --set-auto /usr/local/images/wallpapers/cyborg0.jpg
pause
clear

echo Installation de Iceweasel
sleep 2
apt-get -y install --no-install-recommends iceweasel
pause
clear

echo Installation de geany
sleep 2
apt-get -y install --no-install-recommends geany
pause
clear

echo Installation de Thunar
sleep 2
apt-get -y install --no-install-recommends thunar thunar-archive-plugin thunar-volman exfat-utils gvfs gvfs-backends
pause
clear

echo Installation de Xarchiver
sleep 2
apt-get -y install --no-install-recommends xarchiver
pause
clear

echo Installation de deborphan
sleep 2
apt-get -y install --no-install-recommends deborphan
pause
clear

echo Installation de Tint2
sleep 2
apt-get -y install --no-install-recommends tint2
pause
clear

echo Installation de Conky
sleep 2
apt-get -y install --no-install-recommends conky
pause
clear

echo Installation de Icedove
sleep 2
apt-get -y install --no-install-recommends icedove
pause
clear

echo Installation du son avec Alsa
sleep 2
apt-get -y install --no-install-recommends pavucontrole  
#apt-get -y install --no-install-recommends libasound2 alsa-base alsa-utils alsa-oss
pause
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
	if [ `grep -q $ligne mesPaquets.txt` ]
	then
		echo $ligne>>diff.txt
		echo $ligne
	fi

done < packages.txt
rm -f mesPaquets.txt
sleep 2
clear

if [ -e installed.txt ];then rm -f installed.txt; fi
if [ -e diff.txt ];
then
pause
clear
while read line  
do
    echo -e Installation de $line
    sleep 2

    if [ `apt-get -y install --no-install-recommends $line|grep 'la plus r'|wc -l` == 1 ] ;then
	 echo deja installe
	 echo $line >> installed.txt
    fi
    echo

done < diff.txt
rm -f diff.txt

else
echo Il n\'y a rien a installer
echo
fi

rm -f packages.txt
