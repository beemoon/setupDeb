#! /bin/bash
clear

#Detection de la carte grapphique
vgaCard=`lspci -nvv|grep -i "virtualbox graphics"|wc -l`

apt-get -y install --no-install-recommends xinit xserver-xorg x11-xserver-utils xserver-xorg-core xfonts-base xserver-xorg-input-all xserver-xorg-video-fbdev
# Pour une VM Virtualbox il faut installer les addins afin d'avoir les drivers video.
if [ $vgaCard==1 ];then
    vbox=1
    if [ `lsmod | grep vboxguest|wc -l`== 0 ];then
    wget https://raw.githubusercontent.com/beemoon/setupDeb/master/VBoxLinuxAdditions.run
    chmod u+x VBoxLinuxAdditions.run
    ./VBoxLinuxAdditions.run
    fi
fi
#apt-get -y install --no-install-recommends xserver-xorg-video-intel
clear


wget https://raw.githubusercontent.com/beemoon/setupDeb/dev/packages.txt
while read line  
do
    echo -e Installation de $line
    sleep 2

    if [ `apt-get -y install --no-install-recommends $line|grep "est dŽjˆ la plus rŽcente"|wc -l` eq 1 ] ;then
        echo $line >> installed.txt
    fi
    clear

done < packages.txt
