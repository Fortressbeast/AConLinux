#! /bin/bash
##This will install wine32 so Play on Linux will work properly
BLUE='\e[0;34m'



sudo dpkg --add-architecture i386 && wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo apt-key add winehq.key
sudo apt update
sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 xterm wine32 -y
rm winehq.key

echo -e "\n\n${BLUE}Please download and install the latest version of Play on Lunix from https://www.playonlinux.com/en/download.html (<--Ctrl click should open in browser window).\n"



