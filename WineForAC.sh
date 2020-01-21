#!/bin/bash
##ToDo
##Install wine
##Auto dl needed files
##Install additional requirements
##Install AC
##Install Decal
##Install Thwargle
RED='\033[0;31m'
WIPE="\033[1m\033[0m"

##Install Wine Staging
echo "Which version of Ubuntu are you using (Bionic, Cosmic, Disco, Ermine)?"

read varVersion

sudo dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key

if [ "$varVersion" = "Bionic" ]
	then sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' 

elif [ "$varVersion" = "Cosmic" ]
	then sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ cosmic main' 

elif [ "$varVersion" = "Disco" ]
	then sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ disco main' 

elif [ "$varVersion" = "Ermine" ]
	then sudo sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main'
else 
	echo "You have selected an unknown version, and this istaller is not applicable"
fi

sudo apt update
sudo apt install --install-recommends winehq-staging -y
sudo apt install wine32 -y

cd ~/Downloads
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo cp winetricks /usr/bin
