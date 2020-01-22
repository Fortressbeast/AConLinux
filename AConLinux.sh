#!/bin/bash
##ToDo
##Install wine
##Auto dl needed files
##Install additional requirements
##Install AC
##Install Decal
##Install Thwargle
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

#Introductory message
echo -e "\n\n${BLUE}Welcome to the AConLinux Installer.\n"
echo -e "By using this script you agree to hold no other parties responsible for anything that the script might do - and that you are using it at your own risk."
echo -e "\nIf at any point the installer appears to be stuck, try hitting enter. The instructions may have scrolled off screen and it is actually waiting on user input."
echo -e "\n\n${YELLOW}You will need wine staging, and wine32 installed or this script will fail.\n\n${WHITE}"
read  -n 1 -s -r -p "Press Enter to continue or CTRL-C to stop."
echo -e "$WIPE"

#Allow the user to specify a destination directory.  If not specified, use the default.
echo -e ${WHITE}
read -p "Where would you like to install the wine bottle for AC, Decal, and Thwargle? [~/wine]?" ACBOTTLE
	ACBOTTLE=${ACBOTTLE:-~/wine}

if [ ! -d "$ACBOTTLE" ]; then
echo -e "\n\n${YELLOW} $ACBOTTLE does not exist, creating.${WIPE}"
mkdir $ACBOTTLE
else
echo -e "\n\n${GREEN}Directory already exist, moving on.${WIPE}"
fi



#Allow the user to specify where the install files are located.
echo -e ${WHITE}
read -p "If you have already downloaded ac1install.exe, and ac_data.zip where are they? [~/Downloads]?" ACIstallFiles
	ACIstallFiles=${ACIstallFiles:-~/Downloads}

test -e ${ACIstallFiles}/ac1install.exe
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "\n${BLUE}ac1install.exe not found.  Downloading.${WIPE}"
  wget "${ACINSTALLER}" -O "${ACIstallFiles}/ac1install.exe"

else
echo -e "\n\n${GREEN}ac1install.exe already exist, moving on.${WIPE}"
fi


#Checking for ac_data.zip update in ~/Downloads
cd $ACIstallFiles
echo "10e3ff87575e0cf529b245f07710b57d6937c605fab30832d145a76cefd7cd4b  ac_data.zip" | sha256sum --status -c
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}Please download the update file (ac_data.zip) file from: https://www.gdleac.com/get-started/ and place it in your $ACIstallFiles folder.${WIPE}"
  exit 1
else
  echo -e "${GREEN}ac_data.zip found and SHA256 hash appears to be good!${WIPE}"
fi


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

#Checking for an existing Wine/Wine-staging install and that it's executable
[ -x "$(command -v wine)" ]
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}32Bit Wine NOT found. Aborting.${WIPE}"
  exit 1
else
  echo -e "${GREEN}Pre-Existing Wine found.  Good!${WIPE}"
fi


#Checking for an existing Winetricks install
[ -x "$(command -v winetricks)" ]
rc=$?
if [[ $rc != 0 ]] ; then
  echo -e "${RED}Winetricks NOT found.  Downloading from Github.${WIPE}"
  wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O "${ACBOTTLE}/winetricks"
  chmod +x "${ACBOTTLE}/winetricks"
  WINETRICKS="${ACBOTTLE}/winetricks"
else
  echo -e "${GREEN}Existing Winetricks found.  Skipping download.${WIPE}"
  WINETRICKS=$(command -v winetricks)
fi


##Make bottle to install AC, Decal, and Thwargle
mkdir -p ${ACBOTTLE}/AsheronsCall/drive_c/Games/AC
mkdir  ${ACBOTTLE}/AsheronsCall/drive_c/Games/Decal
mkdir  ${ACBOTTLE}/AsheronsCall/drive_c/Games/Plugins
mkdir  ${ACBOTTLE}/AsheronsCall/drive_c/Games/Thwargle
cd "${ACBOTTLE}"


echo -e "\n\n${BLUE}Setting Wine to use a virtual desktop.  This will help installation by not having everything take up the full screen.${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} vd=1024x768


#Install AC
echo -e "\n\n${BLUE}Launching AC Installer.  ${YELLOW}Please select C:\Games\AC as the installation directory(THIS NEEDS TO BE CHANGED FROM THE DEFAULT).${BLUE}  Additionally, Mono and Gecko may prompt for installation - please install them if so.  (It may ask two or more times).${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine "${ACIstallFiles}/ac1install.exe" 


#Update AC Live files with Emulator files.
echo -e "\n\n${BLUE}Overwriting AC Live files with Emulator files.${WIPE}"
cd "${ACBOTTLE}/AsheronsCall/drive_c/Games/AC"
unzip -o ${ACIstallFiles}/ac_data.zip


echo -e "\n\n${BLUE}Setting Wine OS to Windows XP.${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} winxp


echo -e "$BLUE"
echo -e "Decal should be installed to ${YELLOW}C:\Games\Decal (Select Custom Installation, enable all features, and change the path to C:\Games\Decal).  Also, press Finish on the installer when prompted. Do not set your AC folder at this time, click cancel.${BLUE}  You will define this later.${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/Decal.msi" "https://www.decaldev.com/releases/2975/Decal.msi"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine msiexec /i "${ACBOTTLE}/Decal.msi" 


echo -e "\n\n${YELLOW}ATTENTION!  If the virtual desktop is still running, right click the Decal icon, and select exit.  Nothing will progress until you do this${WIPE}"
echo -e "\n${BLUE}Installing .NET 2.0 via winetricks.  ${YELLOW}Windows may say that .NET 2.0 is already installed.${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} --force dotnet20 
#echo "BREAKPOINT" && exit 0


echo -e "\n${BLUE}Installing .NET 4.0 via winetricks${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} dotnet40 

echo -e "\n${BLUE}Installing Official MSXML4${WIPE}"
wget -O "${ACBOTTLE}/msxml4.msi" "https://download.microsoft.com/download/A/2/D/A2D8587D-0027-4217-9DAD-38AFDB0A177E/msxml.msi"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine msiexec /i ${ACBOTTLE}/msxml4.msi 


echo -e "\n${BLUE}Installing Official VCRUN2005 SP1${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
##wget -O "${ACBOTTLE}/VCRun2005sp1.exe" "https://download.microsoft.com/download/e/1/c/e1c773de-73ba-494a-a5ba-f24906ecf088/vcredist_x86.exe"
wget -O "${ACBOTTLE}/VCRun2005sp1.exe" "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/VCRun2005sp1.exe 


echo -e "\n${BLUE}Installing Official .NET 1.1${WIPE}"
echo -e "${YELLOW}There is an error during the DotNet 1.1 install, you can ignore this and continue with the install.${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/dotnet-1.1.exe" "https://download.microsoft.com/download/a/a/c/aac39226-8825-44ce-90e3-bf8203e74006/dotnetfx.exe" 
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/dotnet-1.1.exe 


echo -e "\n${BLUE}Installing Official .NET 2.0 SP2. Windows may say that .NET 2.0 is already installed.${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/dotnet2.0sp2.exe" "https://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_x86.exe"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/dotnet2.0sp2.exe 


echo -e "\n\n${BLUE}DX9c is about to download.  ${YELLOW}You *need* to extract the files to ${ACBOTTLE}/DX9c${WHITE}"
read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/directx_apr2006_redist.exe" "https://download.microsoft.com/download/3/9/7/3972f80c-5711-4e14-9483-959d48a2d03b/directx_apr2006_redist.exe"
mkdir ${ACBOTTLE}/DX9c
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/directx_apr2006_redist.exe 


echo -e "\n${BLUE}Installing DirectX 9c.${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/DX9c/DXSETUP.exe 


echo -e "${BLUE}Virindi Plugins should be installed in ${YELLOW}C:\Games\Plugins.${BLUE} Install gui will blank. Look for 'Install complete. You may close this program' in this terminal. When you see it close the Virindi installer application.${WHITE}"
read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/VirindiInstaller1008.zip" "http://virindi.net/plugins/updates/VirindiInstaller1008.zip"
mkdir ${ACBOTTLE}/VirindiInstaller
cd ${ACBOTTLE}/VirindiInstaller
unzip ${ACBOTTLE}/VirindiInstaller1008.zip
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/VirindiInstaller/VirindiInstaller.exe 


echo -e "\n${BLUE}Setting Wine OS to Windows 7${WIPE}"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wineboot -r
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} win7


echo -e "\n${BLUE}Installing Official .NET 4.5.2${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
wget -O "${ACBOTTLE}/DotNet-4.5.2.exe" "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/DotNet-4.5.2.exe 


echo -e "\n\n${BLUE}Installing ThwargleLauncher.  ${YELLOW}Please install it to C:\Games\Thwargle${WHITE}"
read -n 1 -s -r -p "Press any key to continue."
echo -e "$WIPE"
wget -O "${ACBOTTLE}/ThwargLauncherInstaller.exe" "http://thwargle.com/thwarglauncher/updates/ThwargLauncherInstaller.exe"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" wine ${ACBOTTLE}/ThwargLauncherInstaller.exe 


echo -e "\n\n${BLUE}Disabling the virtual desktop.  If you want to re-enable, run ${WHITE} WINEARCH=win32 WINEPREFIX=\"${ACBOTTLE}/AsheronsCall\" ${WINETRICKS} vd=1920x1080   (or whatever you want the VD to be set to) .${WHITE}"
read  -n 1 -s -r -p "Press any key to continue"
echo -e "$WIPE"
WINEARCH=win32 WINEPREFIX="${ACBOTTLE}/AsheronsCall" ${WINETRICKS} vd=off


echo -e "\n\n${BLUE}You may launch Decal and AC manually via ${WHITE} WINEARCH=win32 WINEPREFIX=\"${ACBOTTLE}/AsheronsCall\" wine ${ACBOTTLE}/drive_c/Games/Decal/DenAgent.exe ${WIPE}"
