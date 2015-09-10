#! /bin/bash
clear

function pause(){
echo
read -s -n1 -p "Appuyez sur une touche pour continuer..."
echo
echo
}

function install(){
    package=$*
    echo -e Installation de $package
    echo
    sleep 2
    apt-get -y install --no-install-recommends $package
    if [ "$?" == "100" ]; then
	echo $package>>errorPkg.txt
    fi
    echo
    sleep 2
    clear
}

# Mise a jour des depots    
########################
echo Mise a jour des sources.list
sleep 2
echo
echo "deb http://http.debian.net/debian/ jessie main contrib non-free" >> /etc/apt/sources.list
apt-get -y update && apt-get -y upgrade
sleep 2
clear

# Initialise le fichier de log
##############################
if [ -e errorPkg.txt ];then
    rm -f errorPkg.txt
fi

if [ `dpkg --get-selections | grep xserver | wc -l` -eq 0 ]; then
    # Installation de la carte graphique
    ####################################
    vgaCard=`lspci|grep -i "virtualbox graphics"|wc -l`
    
    echo -e Installation du mode graphique
    echo
    sleep 2
    apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
    apt-get -y install gcc make linux-headers-`uname -r`
            
    # Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.
    if [ $vgaCard -eq 1 ];then
        vbox=1
        if [ `lsmod | grep vboxguest|wc -l` -eq 0 ];then
            if [ -e VBoxLinuxAdditions.run ];then
                    rm -f VBoxLinuxAdditions*
            fi 
            echo
            wget https://raw.githubusercontent.com/beemoon/setupDeb/master/VBoxLinuxAdditions.run
            chmod u+x VBoxLinuxAdditions.run
            ./VBoxLinuxAdditions.run
        fi
    else
            apt-get -y install --no-install-recommends xserver-xorg-video-intel
    fi
    echo
    sleep 2
fi

# Installation du wifi
######################
if [ $vbox -ne 1 ];then
    echo Installation du firmware iwlwifi
    echo
    sleep 2
    # Debian 8 "Jessie"
    apt-get -y install --no-install-recommends firmware-iwlwifi wpasupplicant
    echo
    sleep 2
fi

# Liste des paquets deja installés
##################################
dpkg --get-selections >mesPaquets.txt

# Installation des paquets de ma distribution « myDeb »
#######################################################
echo -e Liste des applications minimalesa installer
sleep 2
if [ -e myDeb.txt ];then
	rm -f myDeb.*
fi 
wget https://raw.githubusercontent.com/beemoon/setupDeb/dev/myDeb.txt

# Difference avec les paquets demandes et ce qui est deja installe
if [ -e diff.txt ]; then rm -f diff.*; fi
while read ligne
do  
    if [ `grep $ligne mesPaquets.txt|wc -l` -eq 0 ];
    then
            echo $ligne>>diff.txt
            echo $ligne
    fi

done < myDeb.txt
rm -f myDeb.txt
echo
sleep 2

if [ -e diff.txt ];
then
    while read line  
    do
        install $line
    done < diff.txt
    rm -f diff.txt
fi

# Liste des paquets deja installés
##################################
dpkg --get-selections >mesPaquets.txt

# Applications a installer
#####################################
echo -e Liste des applications a installer
sleep 2
if [ -e myApps.txt ];then
	rm -f myApps.* 
fi 
wget https://raw.githubusercontent.com/beemoon/setupDeb/dev/myApps.txt

# Difference avec les paquets demandes et ce qui est deja installe
if [ -e diff.txt ]; then rm -f diff.*; fi
while read ligne
do  
    if [ `grep $ligne mesPaquets.txt|wc -l` -eq 0 ];
    then
            echo $ligne>>diff.txt
            echo $ligne
    fi

done < myApps.txt
rm -f myApps.txt
echo
sleep 2

if [ -e diff.txt ];
then
    while read line  
    do
        install $line
    done < diff.txt
    rm -f diff.txt

else
    echo Il n\'y a rien a installer
    echo
fi

# Liste des paquets deja installés
##################################
dpkg --get-selections >mesPaquets.txt

# Paquets supplementaires a installer
#####################################
echo -e Liste des paquets supplementaires a installer
sleep 2
if [ -e packages.txt ];then
	rm -f packages.* 
fi 
wget https://raw.githubusercontent.com/beemoon/setupDeb/dev/packages.txt

# Difference avec les paquets demandes et ce qui est deja installe
if [ -e diff.txt ]; then rm -f diff.*; fi
while read ligne
do  
    if [ `grep $ligne mesPaquets.txt|wc -l` -eq 0 ];
    then
            echo $ligne>>diff.txt
            echo $ligne
    fi

done < packages.txt
rm -f paquets.txt
echo
sleep 2

rm -f diff.txt
if [ -e diff.txt ];
then
    while read line  
    do
        install $line
    done < diff.txt
    rm -f diff.txt

else
    echo Il n\'y a rien a installer
    echo
fi
rm -f mesPaquets.txt

while [ `deborphan --guess-all|wc -l` -ne 0 ]
do
  deborphan --guess-all | xargs apt-get -y remove --purge
done

dpkg -P $(dpkg -l | awk '$1~/^rc$/{print $2}')
apt-get clean


# Parametrage
##############


# wallpaper
if [ ! -e /usr/local/images/wallpapers/cyborg0.jpg ]
then
    wget -P /usr/local/images/wallpapers https://raw.githubusercontent.com/beemoon/setupDeb/master/cyborg0.jpg
fi

if [ `grep nitrogen /etc/xdg/openbox/autostart|wc -l` -eq 0 ]
then
    echo "nitrogen --save --set-auto /usr/local/images/wallpapers/cyborg0.jpg &" >> /etc/xdg/openbox/autostart
    echo "sleep 2" >> /etc/xdg/openbox/autostart
fi

# transparence
#if [ `grep xcompmgr /etc/xdg/openbox/autostart|wc -l` -eq 0 ]
#then
#    echo "xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &" >> /etc/xdg/openbox/autostart  
#fi

# tint2
wget -P /etc/xdg/tint2 -N https://raw.githubusercontent.com/beemoon/setupDeb/dev/tint2rc
chmod 644 /etc/xdg/tint2/tint2rc
if [ `grep tint2 /etc/xdg/openbox/autostart|wc -l` -eq 0 ]
then
    echo "tint2 &" >> /etc/xdg/openbox/autostart  
fi
if [ -e ~/.config/tint2/tint2rc ]
then
    rm -f ~/.config/tint2/tint2rc
fi

# conky
wget -P /etc/conky -N https://raw.githubusercontent.com/beemoon/setupDeb/dev/conky.conf
chmod 644 /etc/conky/conky.conf
if [ `grep conky /etc/xdg/openbox/autostart|wc -l` -eq 0 ]
then
    echo "conky &" >> /etc/xdg/openbox/autostart  
fi

# openbox menu
#wget -P /etc/conky -N https://raw.githubusercontent.com/beemoon/setupDeb/master/conky.conf
#chmod 644 /etc/conky/conky.conf


history -c
reboot
