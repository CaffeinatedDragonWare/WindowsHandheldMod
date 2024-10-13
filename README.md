# Windows Handheld Mod

This mod temporarily replaces Windows Explorer with a launcher of your choosing, such as Steam Big Picture Mode or Playnite and plays a boot movie before launching.

## Tutorials

- [Steam Tutorial - Windows 10](https://youtu.be/n5OU6kmUP78)
- [Steam Tutorial - Windows 11](https://www.youtube.com/watch?v=OrelbRatp8o)
- [Playnite/Custom Launcher Tutorial](https://youtu.be/CrVyp3vLVxM)

## Installation

1. Download the appropriate startup script:
	- `startup.bat` for custom launchers
	- `playnite_startup.bat` for Playnite
	- `steam_startup.bat` for Steam

2. For boot video support:
	1. Install ffmpeg essentials
		- through `winget`, if you have it: `winget install "FFmpeg (Essentials Build)"`
		- manually by downloading https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip and extracting `ffmpeg-7.1-essentials_build\bin` to your `Videos` folder (`%UserProfile%\Videos`)
	3. Download a boot movie (`.webm` format) from a site like [steamdeckrepo](https://steamdeckrepo.com/)
	4. Place the boot movie (renamed to `boot.webm`) in your `Videos` folder (`%UserProfile%\Videos`)

2. For multiple boot movies:
	1. Create a folder named `bootvideos` inside your `Videos` folder
	2. Place all boot movies in the `bootvideos` folder
	3. Download the `random_boot_movie.bat` script

3. Install the mod:
	1. Press `Windows` + `R`
	2. Type `regedit` and hit enter
	3. Select `Yes` in the prompt that shows up
	4. Press `ctrl` + `L`
	5. Paste the following: `Computer\HKEY_Current_User\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\`
	6. Go to `Edit` > `New` > `String Value`
	7. Type `Shell`
	8. Double click the new string value
	9. change the value data to
		- `wscript "%UserProfile%\Videos\invisible_startup.vbs"` (Antivirus won't like this, you will have to add an exception)
		- Or, set it to the full path of your chosen startup script (click on the script in File Explorer and press `ctrl`+`shift`+`C` to copy the path)

4. If using `startup.bat`, edit the script to set the path to your desired launcher and adjust the wait time

5. Restart your computer

## Uninstallation

1. Follow steps 3.1 - 3.8 of the [Installation](#installation)
2. Change the value data to `explorer.exe`

## Support

If you find this mod helpful, consider [buying me a coffee](https://buymeacoffee.com/dragonware_decaf)

## Disclaimer

Use this mod at your own risk. Always back up your system before making registry changes.
