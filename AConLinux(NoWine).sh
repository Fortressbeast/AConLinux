#!/usr/bin/env bash
##TODO
##Test custom install dirs
##Auto dl ac_data.zip
##CREDITS
##Original Script by fortressbeast
##Updated by Aerbax (Stip Dickens from Thistledown, Stip on Reefcull)
#
GREEN='\e[0;32m'
BLUE='\e[0;34m'
WHITE='\e[1;37m'
RED='\033[0;31m'
YELLOW='\e[1;33m'
WIPE="\033[1m\033[0m"
#Standardization:
##Blue  - Script Info
##Green - Status messages from external tools
##Red   - Problems
##White - User intervention required (usually "Press enter...") 
##Yellow - Inline important information
#
#Script "sections" are separated by two line feeds/breaks to aid readability


#Global variables
ACINSTALLER="http://content.turbine.com/sites/clientdl/ac1/ac1install.exe"
#Allow the user to specify a destination directory.  If not specified, use the default.
if [ "$#" -ne 2 ]; then
  ACBOTTLE=~/wine
else
  ACBOTTLE="$1"
fi


#Introductory message
clear
echo -e "\n\n${WHITE}Welcome to the AConLinux Installer.${BLUE}"
echo -e "By using this script you agree to hold no other parties responsible for anything that the script might do - and that you are using it at your own risk."
echo -e "\n${YELLOW}NOTES:${BLUE}"
echo -e "* If at any point the installer appears to be stuck, try hitting enter. The instructions may have scrolled off screen and it is actually waiting on user input."
echo -e "* Mono and Gecko may prompt for installation - please install them if so."
echo -e "* Pay special attention to instructions for installation into custom directories.  The script often expects things to be located in specific locations"
echo -e "* Wine output containing 'Error' and 'FixMe' are fine."
echo -e "\n\n${WHITE}"
read  -n 1 -s -r -p "Press any key to continue or CTRL-C to stop."
echo -e "$WIPE"


#Checking for required tools.  wget, unzip, etc.  This is probably better put into a list and iterated over.
[ -x "$(command -v wget)" ]
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}wget NOT found. Aborting.${WIPE}"
  exit 1
fi
[ -x "$(command -v unzip)" ]
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}unzip NOT found. Aborting.${WIPE}"
  exit 1
fi


#Checking for ac_data.zip update in ~/Downloads
cd ~/Downloads
echo "10e3ff87575e0cf529b245f07710b57d6937c605fab30832d145a76cefd7cd4b  ac_data.zip" | sha256sum --status -c
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}Please download the ac_data.zip file from: https://mega.nz/#!pCJGQLpD!iluyl8Mmcj8h0cV-cYgDPRaApokhQj-BsH6Sz0F5UxM or https://www.gdleac.com/get-started/#tab_installing (under Download Update on the Installing tab) and place it in your ${HOME}/Downloads folder.${WIPE}"
  exit 1
else
  echo -e "${GREEN}ac_data.zip found and SHA256 hash appears to be good!${WIPE}"
fi


#Checking for an existing Wine/Wine-staging install and that it's executable
[ -x "$(command -v wine)" ]
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}32Bit Wine NOT found. Aborting.${WIPE}"
  exit 1
else
  echo -e "${GREEN}Pre-Existing Wine found.  Good!${WIPE}"
fi


#Get an up to date winetricks and place it in the bottle so that it doesn't interfere with a system version.
#During this scripts creation, the working winetricks is:
#Using winetricks 20190310-next - sha256sum: 3dfa60162c59ba8c3f2ea49a54b0fcb056f12ee1a8f012a8b62c66646bef73f3 with wine-4.6 and WINEARCH=win32
echo -e "${GREEN}Downloading latest winetricks.  The system winetricks is often not new enough.  Saving to ${ACBOTTLE}/winetricks.${WIPE}"
rm -f "${ACBOTTLE}/winetricks"
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O "${ACBOTTLE}/winetricks"
chmod +x "${ACBOTTLE}/winetricks"
WINETRICKS="${ACBOTTLE}/winetricks"


##Make bottle to install AC, Decal, and Thwargle
mkdir  -p ${ACBOTTLE}/AsheronsCall/drive_c/Games/Decal
mkdir  -p ${ACBOTTLE}/AsheronsCall/drive_c/Games/Plugins
#CD to the bottle so that we don't accidentally put anything where we shouldn't
cd "${ACBOTTLE}"


#Fonts
echo -e "\n\n${BLUE}Installing some fonts to make things look better.  This will take 1-2 minutes and will pause at the next step.${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} -q corefonts tahoma lucida webdings


#Virtual Desktop
echo -e "\n\n${BLUE}Setting Wine to use a small virtual desktop.  This will help installation by not having everything take up the full screen.${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} vd=1024x768


#Install AC
echo -e "\n\n${BLUE}Launching AC Installer."
echo -e "${YELLOW}NOTES:${BLUE}"
#echo -e "* Please select C:\Games\AC as the installation directory(THIS NEEDS TO BE CHANGED FROM THE DEFAULT)"
echo -e "* Please install AC into the default location, C:\Turbine\Asheron's Call .  This script (and Thwargle) expects files to be there for updating later."
echo -e "* The Window will usually stay up for 10-20 seconds after installation is complete.  This is fine and it will close on its own."
#echo -e "\n${WHITE}"
#read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
#Check if we have already downloaded the file
test -e ${ACBOTTLE}/ac1install.exe
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "\n${BLUE}ac1install.exe not found.  Downloading.${WIPE}"
  wget "${ACINSTALLER}" -O "${ACBOTTLE}/ac1install.exe"
fi
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine "${ACBOTTLE}/ac1install.exe"


#Update AC Live files with Emulator files.
echo -e "\n\n${BLUE}Overwriting AC Live files with Emulator files.${WIPE}"
cd "${ACBOTTLE}/AsheronsCall/drive_c/Turbine/Asheron's Call"
unzip -o ~/Downloads/ac_data.zip


#Set OS to XP
echo -e "\n\n${BLUE}Setting Wine OS to Windows XP.${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} winxp


#Install Decal
echo -e "${BLUE}Downloading and Installing Decal"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* Decal will be automatically installed to C:\Games\Decal"
echo -e "* After the install, you will be prompted to select where the AC files are located, which are at (My Computer) C:\Turbine\Asheron's Call"
echo -e "* It will then say that your files are out of date. Click OK"
echo -e "* Double click the Decal icon in the tray to open Decal, accept the error, and then click the Update button to update the Decal files. 'Decal FileService' will still have a Red X - that's Okay."
echo -e "* Finally, click 'Close' and then right click the Decal icon in the tray and select 'Exit' to proceed to the next step."
echo -e "\n${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/Decal.msi" "https://www.decaldev.com/releases/2975/Decal.msi"
#WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine msiexec /log decallog.txt /i "${ACBOTTLE}/Decal.msi" INSTALLDIR="C:\Games\Decal" /q
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine msiexec /i "${ACBOTTLE}/Decal.msi" INSTALLDIR="C:\Games\Decal" /q
echo -e "\n${WHITE}"
read  -n 1 -s -r -p "Pausing until you complete the Decal steps.  Press any key to continue"
echo -e "$WIPE"


#.NET 2.0
echo -e "\n${BLUE}Installing .NET 2.0 via winetricks.${WIPE}\n"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} --force dotnet20


#.NET 4.0
echo -e "\n${BLUE}Installing .NET 4.0 via winetricks${WIPE}\n"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* Click the 'Restart Now' button when the installation is complete.  It's a simulated *Windows* restart and doesn't impact your Linux session."
echo -e "\n${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} --force dotnet40


#MSXML4
echo -e "\n${BLUE}Installing Official MSXML4${WIPE}\n"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* You do not have to fill in the User name and Organization fields\n\n${WIPE}"
wget -O "${ACBOTTLE}/msxml4.msi" "https://download.microsoft.com/download/A/2/D/A2D8587D-0027-4217-9DAD-38AFDB0A177E/msxml.msi"
#echo -e "\n${WHITE}"
#read  -n 1 -s -r -p "Press any key to continue"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine msiexec /i ${ACBOTTLE}/msxml4.msi 


#Visual C++ 2005
echo -e "\n${BLUE}Installing Official VCRUN2005 SP1${WIPE}\n"
wget -O "${ACBOTTLE}/VCRun2005sp1.exe" "https://download.microsoft.com/download/e/1/c/e1c773de-73ba-494a-a5ba-f24906ecf088/vcredist_x86.exe"
#echo -e "\n${WHITE}"
#read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/VCRun2005sp1.exe


#.NET 1.1
echo -e "\n${BLUE}Installing Official .NET 1.1"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* There will an error or two during the DotNet 1.1 install, you can ignore this and continue with the install."
echo -e "\n${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/dotnet-1.1.exe" "https://download.microsoft.com/download/a/a/c/aac39226-8825-44ce-90e3-bf8203e74006/dotnetfx.exe" 
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/dotnet-1.1.exe 


#.NET 2.0 SP2
echo -e "\n${BLUE}Installing Official .NET 2.0 SP2.${WIPE}"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* There will an error in the console saying 'Failed to load the runtime'.  This is fine.\n${WIPE}"
wget -O "${ACBOTTLE}/dotnet2.0sp2.exe" "https://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/dotnet2.0sp2.exe


#DirectX 9.0c files
echo -e "\n\n${BLUE}Downloading and extracting DirectX 9.0c"
#echo -e "\n\n${WHITE}"
#read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/directx_apr2006_redist.exe" "https://download.microsoft.com/download/3/9/7/3972f80c-5711-4e14-9483-959d48a2d03b/directx_apr2006_redist.exe"
mkdir ${ACBOTTLE}/DX9c
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/directx_apr2006_redist.exe /Q /T:"Z:\\${ACBOTTLE}\\DX9c"


#DirectX 9.0c install
echo -e "\n${BLUE}Installing DirectX 9.0c.${WIPE}\n"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/DX9c/DXSETUP.exe


#Virindi
echo -e "${BLUE}Installing Virindi Plugins"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* Virindi Plugins can be installed in the default location, or any other location under C:"
echo -e "* After it finishes installing, the Virindi window will be blank and you'll see a message on the console stating 'Install complete. You may close this program'.  At this point you can close the blank Virindi Plugin Installer window *in the Windows virtual desktop* to continue."
echo -e "\n${WHITE}"
read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/VirindiInstaller1008.zip" "http://virindi.net/plugins/updates/VirindiInstaller1008.zip"
mkdir ${ACBOTTLE}/VirindiInstaller
cd ${ACBOTTLE}/VirindiInstaller
unzip ${ACBOTTLE}/VirindiInstaller1008.zip
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/VirindiInstaller/VirindiInstaller.exe 


#OS to Windows 7
echo -e "\n${BLUE}Setting Wine OS to Windows 7${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} win7


#.NET 4.5.2
echo -e "\n${BLUE}Installing Official .NET 4.5.2${WIPE}"
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* Click the 'Restart Now' button when the installation is complete.  It's a simulated *Windows* restart and doesn't impact your Linux session."
echo -e "\n${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/DotNet-4.5.2.exe" "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/DotNet-4.5.2.exe


#Thwargle
echo -e "\n\n${BLUE}Installing ThwargleLauncher.  "
echo -e "${YELLOW}NOTES:${BLUE}"
echo -e "* You can install this anywhere under C:\, but the default location under Program Files is probably best."
echo -e "* Do not select 'Launch ThwargleLauncher...' at the end of installation."
echo -e "\n${WHITE}"
read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/ThwargLauncherInstaller.exe" "http://thwargle.com/thwarglauncher/updates/ThwargLauncherInstaller.exe"
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/ThwargLauncherInstaller.exe


echo -e "\n\n\n${BLUE}The script is now finished.  Everything should now be installed.\n${YELLOW}NOTES:${BLUE}"
echo -e "\n* You will need to launch Decal, click Update, and then go into Options to enable Dual Log, No Movies, No Logos, and possibly Start on Bootup."
echo -e "  ** While in Decal, you likely want to load ThwargleFilter.  To do so, in Decal, click Add, Browse, then navigate to C:\Program Files\Thwargle Games\ThwargLauncher\  and then select ThwargFilter.dll .  You should now see it in Decal under Network Filters."
echo -e "\n* The Virtual Desktop used during installation is set to 1024x768, which is pretty small for modern displays.  If you want to embiggen, run ${WHITE} WINEARCH=win32 WINEPREFIX=\"${ACBOTTLE}/AsheronsCall\" ${WINETRICKS} vd=1920x1080   ${BLUE}(or whatever you want the VD to be set to) .  It is sometimes better to set the resolution to something slightly larger to compensate for title and task bars.  Perhaps 1980x1140 if you're emulating a 1920x1080 screen."
echo -e "\n* If you wish to disable the Virtual Desktop completely, run ${WHITE} WINEARCH=win32 WINEPREFIX=\"${ACBOTTLE}/AsheronsCall\" ${WINETRICKS} vd=off ${BLUE}"
echo -e "\n* ${BLUE}You may launch Decal (and a standard desktop) manually via ${WHITE} WINEARCH=win32 WINEPREFIX=\"${ACBOTTLE}/AsheronsCall\" wine ${ACBOTTLE}/AsheronsCall/drive_c/Games/Decal/DenAgent.exe ${BLUE}"
