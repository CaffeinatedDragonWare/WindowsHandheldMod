This mod temporarily replaces Windows explorer with a launcher of your choosing (Steam, playnite, etc.) and it will play a boot movie before hand.

Download one of the startup.bat scripts, download the ffplay.exe (https://ffmpeg.org/download.html#build-windows) and a boot movie from a site like steamdeckrepo. By default, the boot movie must me named boot.webm and everything must be in your Videos folder (You change that in the startup script though). If you want to use multiple boot movies and have one random selected when Windows boots, create a folder inside of your Videos folder called "bootvideos" and download the random.bat script. Put all of your boot movies in the newly created "bootvideos" folder.

To install this mod, open regedit and browse to "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\". From here set the shell file to the locations of the startup script you downloaded (playnite_startup.bat, steam_startup.bat or startup.bat. If you are using startup.bat, you will need to add the path to the launcher you plan to use (Gog, Battle.net, etc.) and set the wait time before the desktop loads according. Restart and enjoy. If you want to unistall this mod, change your shell file back to explorer.exe

Video coming soon.
