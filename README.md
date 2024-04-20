This mod temporarily replaces Windows explorer with a launcher of your choosing (Steam, playnite, etc.) and it will play a boot movie before hand.
Note: For Handheld companion users, make sure handheld companion is not set to start with windows since the playnite script starts it for you.

Download one of the startup.bat scripts. If you want to use a boot video, download the ffplay.exe ([https://ffmpeg.org/download.html#build-windows](https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-2024-02-15-git-a2cfd6062c-full_build.7z)) and a boot movie from a site like steamdeckrepo (https://steamdeckrepo.com/). By default, the boot movie must be named boot.webm and everything must be in your Videos folder. If you want to use multiple boot movies and have one randomly selected when Windows boots, create a folder inside of your Videos folder called "bootvideos" and download the random_boot_movie.bat script. Put all of your boot movies in the newly created "bootvideos" folder.

To install this mod, open regedit and browse to "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\". From here set the shell file to the locations of the startup script you downloaded (playnite_startup.bat, steam_startup.bat or startup.bat. If you are using startup.bat, you will need to add the path to the launcher you plan to use (Gog, Battle.net, etc.) and set the wait time before the desktop loads according. Restart and enjoy. If you want to unistall this mod, change your shell file back to explorer.exe

Video coming soon.
