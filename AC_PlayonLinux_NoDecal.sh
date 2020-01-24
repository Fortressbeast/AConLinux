#!/bin/bash

if [ "$PLAYONLINUX" = "" ]
then
	exit 0
fi
source "$PLAYONLINUX/lib/sources"
POL_SetupWindow_Init
POL_SetupWindow_message "Welcome to the Asheron's Call Play on Linux installer" "PoL installer for AC"
POL_SetupWindow_Close


PREFIX="AsheronsCall"
WINEVERSION="4.20-staging"
TITLE="Asheron's Call"
EDITOR="Turbine."
GAME_URL="check out: https://www.reddit.com/r/AsheronsCall/"
AUTHOR="Fortressbeast"

##Initialization
POL_SetupWindow_Init
POL_SetupWindow_SetID
POL_Debug_Init

##Presentation
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$GAME_URL" "$AUTHOR" "$PREFIX"
##PreCheck
POL_SetupWindow_question "Do you have the Asheron's Call install (ac1install.exe) and patch (ac_data.zip) files in $USER/Downloads " "Precheck"

	if [ "$APP_ANSWER" = "TRUE" ]
	then 
	
	## Create prefix and temporary download folder
		POL_Wine_SelectPrefix "$PREFIX"
		POL_Wine_PrefixCreate "$WINEVERSION"
		POL_System_TmpCreate "ACTempDir"
		Set_OS "win7"
		
		## Run the installer
		mkdir -p /home/$USER/.PlayOnLinux/wineprefix/AsheronsCall/drive_c/Games/{AC,Decal,Plugins,Thwargle}
		POL_SetupWindow_message "Please install Asheron's Call in C:\Games\AC"
		POL_Wine_WaitBefore "$TITLE"
		POL_Wine "/home/$USER/Downloads/ac1install.exe"
		cd /home/$USER/.PlayOnLinux/wineprefix/AsheronsCall/drive_c/Games/AC
		unzip -o /home/$USER/Downloads/ac_data.zip
		
		POL_System_TmpDelete
		POL_Shortcut "acclient.exe" "Asheron's Call NoDecal"
		POL_SetupWindow_message "The setup is done, however you will have to modify the instance to run properly(slide this window out of the way if you need to): \n\n1. Highlight the AC shortcut and click Configure \n\n2. Put your connection info in 'Arguments' ie(ACE): -h SERVERNAME/IP  -p PORT -a USER -v PWD -rodat off \n\n3. Under display 'Video memory size' select an appropriate amount of memory for your card \n\n4.Close the configuration window \n\n5. Click next on this window when done"
POL_SetupWindow_Close
		






	else	
	   ##POL_SetupWindow_free_presentation
	   POL_SetupWindow_message "Please download ac1install.exe from http://content.turbine.com/sites/clientdl/ac1/ac1install.exe \n\nThen download ac_data.zip from https://www.gdleac.com/get-started/ \n\nPlace both in $USER\Downlads (if that is not where you saved them) \n\nOnce done please re-run this script" "Install files missing"
           POL_SetupWindow_Close
	fi

exit 0
