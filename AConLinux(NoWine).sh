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

echo -e "$RED"
read  -n 1 -s -r -p "By using this script you agree that I will not be held resposible, and that you are using it at your own risk. Press any key to continue."
echo -e "$WIPE"

clear
echo -e "$RED"
read  -n 1 -s -r -p "If at any point the installer appears to be stuck, try hitting enter. The instructions may have scrolled off screen and it is actually waiting on user input."
echo -e "$WIPE"
clear
echo -e "$RED"
read  -n 1 -s -r -p "This script assumes you have wine staging, and wine32 installed. If you do not, the quit now (ctrl + c) and either install them or use AConLinux(Full) if you are using Ubuntu."
echo -e "$WIPE"



cd ~/Downloads
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo cp winetricks /usr/bin



##Make bottle to install AC, Decal, and Thwargle
mkdir -p ~/wine/AsheronsCall/drive_c/Games/AC
mkdir  ~/wine/AsheronsCall/drive_c/Games/Decal
mkdir  ~/wine/AsheronsCall/drive_c/Games/Plugins
mkdir  ~/wine/AsheronsCall/drive_c/Games/Thwargle
cd ~/wine

echo -e "$RED"
read  -n 1 -s -r -p "Asheron's Call should be installed in C:\Games\AC. Install Mono and Gecko when prompted. Press any key to continue"
echo -e "$WIPE"
gnome-terminal -t "Asheron's Call" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/ac1install.exe"
mv ~/Downloads/ACInstall/acclient.exe ~/wine/AsheronsCall/drive_c/Games/AC/
mv ~/Downloads/ACInstall/client_cell_1.dat ~/wine/AsheronsCall/drive_c/Games/AC/
mv ~/Downloads/ACInstall/client_portal.dat ~/wine/AsheronsCall/drive_c/Games/AC/


echo -e "$RED"
read  -n 1 -s -r -p "Set wine to windows xp."
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall winecfg

echo -e "$RED"
read  -n 1 -s -r -p "Decal should be installed to C:\Games\Decal (custom, all components). Make sure to complete the install do not try to select AC directory at this time. Press any key to continue"
echo -e "$WIPE"

mkdir ~/Downloads/ACInstall/Decal
wget -O ~/Downloads/ACInstall/Decal/Decal.msi "https://www.decaldev.com/releases/2975/Decal.msi"
gnome-terminal -t "Decal" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine msiexec /i ~/Downloads/ACInstall/Decal/Decal.msi"

echo -e "$RED"
read  -n 1 -s -r -p "Select your AC folder (should be C:\Games\AC). Then update Decal Plugins. NOTE: The 'OK' after update may be behind the main window. Exit decal agent after update has completed. Press any key to launch decal"
echo -e "$WIPE"

gnome-terminal -t "Decal select AC folder and update" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine /home/dan/wine/AsheronsCall/drive_c/Games/Decal/DenAgent.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Perss any key after you have completed the Decal Setup. Noet: Make sure you have exited out of decal before preceding"
echo -e "$WIPE"


gnome-terminal -t "DotNet 2.0" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall winetricks dotnet20"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after DotNet 2.0 finishes installing"
echo -e "$WIPE"

gnome-terminal -t "DotNet 4.0" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall winetricks dotnet40"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after DotNet 4.0 finishes installing"
echo -e "$WIPE"

wget -O ~/Downloads/ACInstall/msxml4.msi https://download.microsoft.com/download/A/2/D/A2D8587D-0027-4217-9DAD-38AFDB0A177E/msxml.msi &&
gnome-terminal -t "MSXML" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine msiexec /i ~/Downloads/ACInstall/msxml4.msi"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after MS MXL finishes installing"
echo -e "$WIPE"

wget -O ~/Downloads/ACInstall/VCRun2005sp1.exe "https://download.microsoft.com/download/e/1/c/e1c773de-73ba-494a-a5ba-f24906ecf088/vcredist_x86.exe" &&
gnome-terminal -t "VCRuns2005sp1 for Virindi" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/VCRun2005sp1.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after MS VCRun 2005 finishes installing"
echo -e "$WIPE"
clear
echo -e "$RED"
read  -n 1 -s -r -p "There is an error during the DotNet 1.1 install, you can ignore this and continue with the install."
echo -e "$WIPE"

wget -O ~/Downloads/ACInstall/dotnet-1.1.exe "https://download.microsoft.com/download/a/a/c/aac39226-8825-44ce-90e3-bf8203e74006/dotnetfx.exe" &&
gnome-terminal -t "DotNet 1.1" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/dotnet-1.1.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after MS installer for DotNet 1.1 finishes"
echo -e "$WIPE"

wget -O ~/Downloads/ACInstall/dotnet2.0sp2.exe "https://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe" &&
gnome-terminal -t "DotNet 2.0sp2" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/dotnet2.0sp2.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after MS installer for DotNet 2.0 finishes"
clear
read  -n 1 -s -r -p "DX9c is about to downloud, you need to extract the files to ~/Downloads/ACInstall/DX9c"
echo -e "$WIPE"

wget -O ~/Downloads/ACInstall/directx_apr2006_redist.exe "https://download.microsoft.com/download/3/9/7/3972f80c-5711-4e14-9483-959d48a2d03b/directx_apr2006_redist.exe"
mkdir ~/Downloads/ACInstall/DX9c
gnome-terminal -t "Extract to ~/Downloads/ACInstall/DX9c" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/directx_apr2006_redist.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after DX9c finishes extracting."
echo -e "$WIPE"
gnome-terminal -t "DX9c install" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/DX9c/DXSETUP.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after DX9c finishes installing."
clear
read  -n 1 -s -r -p "Virindi Plugins should be installed in C:\Games\Plugins. Install gui will blank. Look for 'Install complete. You may close this program' in the terminal"
echo -e "$WIPE"
wget -O ~/Downloads/ACInstall/VirindiInstaller1008.zip "http://virindi.net/plugins/updates/VirindiInstaller1008.zip"
mkdir ~/Downloads/ACInstall/Virindi
cd ~/Downloads/ACInstall/Virindi
unzip ~/Downloads/ACInstall/VirindiInstaller1008.zip
gnome-terminal -t "Virindi bundle" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/Virindi/VirindiInstaller.exe"


echo -e "$RED"
read  -n 1 -s -r -p "Wine Config will open when you continue, set wine to windows 7. Press any key to continue"
echo -e "$WIPE"

WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall winecfg

wget -O ~/Downloads/ACInstall/DotNet-4.5.2.exe https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe
gnome-terminal -t "DotNet 4.5.2" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/DotNet-4.5.2.exe"

echo -e "$RED"
read  -n 1 -s -r -p "Press any key after DotNet 4.5.2 finishes installing"
echo -e "$WIPE"
clear
echo -e "$RED"
read  -n 1 -s -r -p "Thwargle installer is about to open please install it to C:\Games\Thwargle. Press any key to continue."
echo -e "$WIPE"


wget -O ~/Downloads/ACInstall/ThwargLauncherInstaller.exe "http://thwargle.com/thwarglauncher/updates/ThwargLauncherInstaller.exe"
gnome-terminal -t "Thwargle Launcher" -- bash -c "WINEARCH=win32 WINEPREFIX=~/wine/AsheronsCall wine ~/Downloads/ACInstall/ThwargLauncherInstaller.exe"
