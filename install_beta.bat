@echo off
setlocal enabledelayedexpansion

echo This script will install my Windows Start Up Mod for you.
echo Not all antivirus programs are ok with scripts making changes to Windows.
echo If you see any antivirus pop ups, please click allow.
echo If the script gets blocked by your antivirus, you will need to create an exception to continue.

:: Check if the script is running as Administrator
:: If not, restart as Administrator

:: Check if the script is running with admin privileges
:openElevated
  net session >nul 2>&1
  if %errorLevel% == 0 (
    :: Running with elevated privileges
    echo Running with elevated privileges.
    echo .
    pause
    echo .
  ) else (
    :: Not running with elevated privileges, restart as Administrator
    echo Restarting as Administrator...
    echo .
    powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c \"%~f0 %*\"' -Verb runAs"
    exit
  )

:: Unblock Scripts

:: Initialize variables
for /f "tokens=*" %%A in ('powershell -Command "(Get-Service WinDefend).Status"') do set "status=%%A"
set "valid_input=false"
set "script="
REM Set the directory to the current directory
set "directory=%~dp0"

echo Unblocking all script files
echo .
REM Iterate over each .bat file in the directory
for %%F in ("%directory%\*.bat") do (
    REM Use PowerShell to unblock the file
    powershell -Command "Unblock-File -Path '%%F'"
)

:LauncherSelection
:: Prompt user for input
set /p userInput=Which launcher would you like to use? [steam, playnite or custom]:
echo .

:BootMovie
:: Prompt user for input
if /i "!userInput!"=="steam" (
  set /p Bootmoviepref=Do you want to use my custom boot movie solution? If no, you can still use the default boot movie functionality built into Steam. [y or n]:

) else (
  set /p Bootmoviepref=Do you want to have a custom boot movie on startup?  [y or n]:
)
echo .

:: Handle different input options
if /i "!userInput!"=="custom" (
    GOTO :Custom
)
if /i "!userInput!"=="playnite" (
    GOTO :Playnite
)
if /i "!userInput!"=="steam" (
    GOTO :Steam
) else (
    echo No valid option selected. Please try again.
    echo .
    GOTO :LauncherSelection
)

:Steam
  IF EXIST "C:\Program Files (x86)\Steam\Steam.exe" (
    copy "%directory%\steam_startup.bat" "%UserProfile%\Videos"
    echo steam_startup.bat moved to Videos folder.
    echo .
    set "valid_input=true"
    set "script=steam_startup.bat"

    if /i "!Bootmoviepref!" == "y" (
      pause
      echo .
      echo To avoid seeing two boot movies on start up, we will need to delete the default Steam boot movies. Please type y and hit enter.
      echo .
      del "C:\Program Files (x86)\Steam\steamui\movies"

      :: Adds -noverifyfiles to default Steam shortcuts
      echo .
      echo Your Steam Shortcuts will be updated to include the launch option -noverifyfiles. This will prevent Steam from re-downloading these files.
      echo.

      :: Sets shortcut Variables
      set "shortcutPath=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"
      set "exePath=C:\Program Files (x86)\Steam\Steam.exe"
      set "arguments=-noverifyfiles"

      :: Calls PowerShell to Update the Application Shortcut
      powershell -Command "$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut('!shortcutPath!'); $shortcut.TargetPath = '!exePath!'; $shortcut.Arguments = '!arguments!'; $shortcut.Save()"

      :: Checks if the Desktop Shortcut exists
      IF EXIST "C:\Users\Public\Desktop\Steam.lnk" (
        set "shortcutPath=C:\Users\Public\Desktop\Steam.lnk"
      )

      :: Calls PowerShell to Update the Desktop Shortcut
      powershell -Command "$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut('!shortcutPath!'); $shortcut.TargetPath = '!exePath!'; $shortcut.Arguments = '!arguments!'; $shortcut.Save()"
    )

  ) ELSE (
    echo Steam is either not installed or it is not installed in the default location.
    echo Please install it in the default location or select a different option.
    echo .
    GOTO :LauncherSelection
  )

  GOTO :validation_check

:Playnite
    IF EXIST "%LocalAppData%\Playnite\Playnite.fullscreenapp.exe" (
      copy "!directory!\playnite_startup.bat" "%UserProfile%\Videos"
      echo playnite_startup.bat moved to Videos folder.
      echo .
      set "valid_input=true"
      set "script=playnite_startup.bat"

    ) ELSE (
      echo Playnite is either not installed or it is not installed in the default location.
      echo Please install it in the default location or select a different option.
      echo .
      GOTO :LauncherSelection
    )

    GOTO :validation_check

:Custom
    echo .
    set "valid_input=true"
    set "script=startup.bat"

    :: Prompt user for launcher path
    :LPath
    set /p custompath=Please paste the path to the launcher you wish to use. Here is an example: "C:\Program Files (x86)\Steam\Steam.exe":

    set inputString=!custompath!
    set inputString=!inputString:"=!
    set custompath=!inputString!

    IF NOT EXIST "!custompath!" (
        echo "!custompath! is not a valid path. Please enter a valid path."
        echo .
        GOTO :Custom
    )

    :LaunchArg
    set /p args=If you have a launch command, please enter it now. Otherwise, leave this blank and hit enter. (Example: -bigpicture):
    echo %custompath% %args%

    :: Accounts for no arguments
    if /i "%args%" == "" (
      echo No args
      set "newline=start /B '' '%custompath%'"
    ) else (
      echo Args
      set "newline=start /B '%custompath%' %args%"
    )

    powershell -command "curl -o %directory%\startup.bat https://raw.githubusercontent.com/CaffeinatedDragonWare/WindowsHandheldMod/refs/heads/main/startup.bat"

    REM Define the input file and a temporary output file
    set "inputFile=%directory%\startup.bat"
    set "tempFile=%directory%\temp.txt"

    :replace_path
    REM Ensure the temp file is empty and perform the replacement
    > "%tempFile%" (
        for /f "delims=" %%i in ('type "%inputFile%"') do (
            set "line=%%i"
            REM Enable delayed variable expansion
            setlocal enabledelayedexpansion

            REM Replace the placeholder line with the new path
            set "line=!line:start /B "" "YOUR LAUNCHER PATH" &=%newline%!"

            REM Output the modified line to the temp file
            echo !line!
            endlocal
        )
    )

    REM Overwrite the original file with the modified content
    move /y "%tempFile%" "%inputFile%"

    powershell.exe -Command "$fileContent = Get-Content '%directory%\startup.bat'; $fileContent = $fileContent -replace \"'\", '\"'; Set-Content '%directory%\startup.bat' -Value $fileContent"

    echo Startup.bat updated
    echo .
    copy "!directory!\startup.bat" "%UserProfile%\Videos"
    echo startup.bat moved to Videos folder.
    echo.
    pause
    GOTO :validation_check

:validation_check
:: Check if valid_input is true
if "!valid_input!"=="true" (

    echo .
    echo Initializing setup...\
    echo .

    if /i "!Bootmoviepref!" == "y" (
      echo Creating BootVideos Folder...
      echo .

      :: Create BootVideos directory if it does not exist.
      if not exist "%UserProfile%\Videos\BootVideos" (
        mkdir "%UserProfile%\Videos\BootVideos"
      ) else (
        echo You already have a BootVideos folder in your Videos folder.
        echo .
      )

      echo Copying random_boot_movie.bat file
      echo .
      :: Copy the random_boot_movie.bat file
      copy "!directory!\random_boot_movie.bat" "%UserProfile%\Videos\" >nul

      :: Checks if ffplay.exe exists in the Videos folder
      REM If ffplay does not exist.
      REM The script downloads ffplay using PowerShell and extracts it.

      echo Downloading ffplay
      echo .

      if exist "%UserProfile%\Videos\ffplay.exe" (
        echo ffplay.exe already exists in your Videos folder.
      ) else (
        echo If you see a pop up from your antivirus, select Allow.
        echo .
        powershell -Command "Invoke-WebRequest -Uri 'https://drive.usercontent.google.com/download?id=1OIdAMXLamuoLGduNiyXLEOcOVNn95Tf5&export=download&authuser=0&confirm=t&uuid=7e36e0f2-70b3-4fc6-bc19-5490905ba2d9' -OutFile '%UserProfile%\videos\ffplay.zip'; Expand-Archive -Path "%UserProfile%\videos\ffplay.zip" -DestinationPath "%userprofile%\videos" -force"
        :: Deletes ffplay.zip
        del "%UserProfile%\Videos\ffplay.zip"
      )

      echo .
      REM Downloads the default boot movie to the BootVideos folder using PowerShell if it doesn't already exist in the BootVideos folder.

      echo Downloading default boot movie from steamdeckrepo
      echo .

      if not exist "%UserProfile%\Videos\BootVideos\boot.webm" (
        echo Downloading default boot movie to BootVideos folder
        echo .
        powershell -Command "Invoke-WebRequest -Uri 'https://steamdeckrepo.com/post/download/ENb0E' -OutFile '%UserProfile%\Videos\BootVideos\boot.webm'"
      ) else (
        echo You already have a boot movie downloaded.
        echo .
      )

      echo Copying boot.webm file to Videos folder.
      echo .

      if not exist "%UserProfile%\Videos\boot.webm" (
        copy "%UserProfile%\Videos\BootVideos\boot.webm" "%UserProfile%\Videos\" >nul
        echo Created a copy of the boot movie in the Videos folder.
      ) else (
        echo Boot.webm already exists in your Videos folder.
        echo .
      )
    )

    REM Autohides taskbar
    powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=1;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}"
    echo Turned on auto hide taskbar.
    echo .
    start explorer.exe
    echo Restarted Windows Explorer

    :: Removes VBS exclusion if the VBS file exists
    if /i "%status%"=="Running" (
      echo Windows Defender is running
      powershell -Command "if ((Get-MpPreference).ExclusionProcess -contains '%UserProfile%\Videos\invisible_startup.vbs') { Remove-MpPreference -ExclusionProcess '%UserProfile%\Videos\invisible_startup.vbs' }"
      echo VBS script exception removed.
      echo .
    ) else (
      echo Windows Defender is not running.
      echo If you manually set an anitivirus exception for the VBS script, feel free to remove it.
      echo .
    )

    :: VBS Script
    :VBS
    echo Would you like to use the default script or try the new VBS script?
    echo Using the VBS script will completely hide the minimized command prompt window on start up.
    echo This will allow for a more seamless experience.
    echo.
    echo Warning:
    echo You may need to add an exception to your antivirus.
    echo If you are using the built in antivirus, Windows Defender, you don't need to touch a thing.
    echo This script will take care of that for you.
    echo If you are not using Windows Defender as your antivirus:
    echo Please google how to add an exception to your antivirus for this path:
    echo "%UserProfile%\Videos\invisible_startup.vbs".
    echo Otherwise, your antivirus will delete the .vbs script and cause issues with boot up.
    set /p userResponse=If unsure, type default. [default or vbs]:
    echo .

    if /i "!userResponse!"=="default" (
     :: Set the Shell entry in the registry
     reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "%UserProfile%\Videos\!script!" /f
     echo Your shell has been changed.
     echo .

    ) else if /i "!userResponse!"=="vbs" (

       copy "!directory!\invisible_startup.vbs" "%UserProfile%\Videos\" >nul
       echo Copied invisible_startup.vbs to your videos folder
       echo .

       if /i "!status!"=="Running" (
         echo Windows Defender is running.
         :: Adds an exclusion for the .vbs script
         powershell -Command "Add-MpPreference -ExclusionProcess '"%Userprofile%\Videos\invisible_startup.vbs"'"
         echo Exception set.
       ) else (
         echo Windows Defender is not running.
         echo No exception set.
         echo Please Google how to add an exception to your Antivirus for the VBS script.
       )

    set "script=invisible_startup.vbs"
    :: Set the Shell entry in the registry
    echo .
    reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "wscript %UserProfile%\Videos\!script!" /f
    echo .
    echo Your shell has been changed.
    echo .

    ) else (
       GOTO :VBS
    )

)

echo This mod has been successfully installed.
echo .
echo If you run into any issues, please run the uninstall script to undo these changes.
echo .
echo Note: Some antivirus programs might remove this mod.
echo If this happens to you, try creating exceptions in your antivirus for the scripts in your Videos folder.
echo .
pause

:: End the script
endlocal
