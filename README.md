This mod temporarily replaces Windows explorer with a launcher of your choosing (Steam (Must be in Big Picture Mode), playnite, etc.) and it will play a boot movie before hand.

Download one of the startup.bat scripts. If you want to use a boot video, download the ffplay.exe (https://drive.google.com/file/d/1OIdAMXLamuoLGduNiyXLEOcOVNn95Tf5/view?usp=sharing) and a boot movie from a site like steamdeckrepo (https://steamdeckrepo.com/). By default, the boot movie must be named boot.webm and everything must be in your Videos folder. If you want to use multiple boot movies and have one randomly selected when Windows boots, create a folder inside of your Videos folder called "bootvideos" and download the random_boot_movie.bat script. Put all of your boot movies in the newly created "bootvideos" folder.

To install this mod, open regedit and browse to "Computer\HKEY_Current_User\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\". From here create a new string and name it "Shell". Now, set the shell file to wscript "%UserProfile%\Videos\invisible_startup.vbs" (Antivirus won't like this, you will have to add an exception) or just set this to the location of the startup.bat, playnite_startup.bat or steam_startup.bat file. If you are using startup.bat, you will need to edit the script and add the path to the launcher you plan to use (Gog, Battle.net, etc.) and set the wait time before the desktop loads according. Restart and enjoy. If you want to unistall this mod, change your shell file back to explorer.exe

Steam Tutorial - Windows 10 - https://youtu.be/n5OU6kmUP78

Steam Tutorial - Windows 11 - https://www.youtube.com/watch?v=OrelbRatp8o



Playnite Tutorial/Custom Launcher Tutorial: https://youtu.be/CrVyp3vLVxM



Buymeacoffee: https://buymeacoffee.com/dragonware_decaf
