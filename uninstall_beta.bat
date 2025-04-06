@echo off
setlocal enabledelayedexpansion

:: Check if the script is running as Administrator
:: If not, restart as Administrator

:: Check if the script is running with admin privileges
:openElevated
  net session >nul 2>&1
  if %errorLevel% == 0 (
    :: Running with elevated privileges
    echo Running with elevated privileges.
    echo .
    :: Place any commands you want to execute here
    pause
  ) else (
    :: Not running with elevated privileges, restart as Administrator
    echo Restarting as Administrator...
    echo .
    powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c \"%~f0 %*\"' -Verb runAs"
    exit
  )

REM Deletes files in Videos folder but leaves the BootVideos folder
set "files=%UserProfile%\Videos\playnite_startup.bat %UserProfile%\Videos\steam_startup.bat %UserProfile%\Videos\startup.bat %UserProfile%\Videos\random_boot_movie.bat %UserProfile%\Videos\ffplay.exe %UserProfile%\Videos\previous_boot_video.log %UserProfile%\Videos\boot.webm %UserProfile%\Videos\invisible_startup.vbs"

for %%f in (!files!) do (
    if exist "%%f" (
        echo Deleting %%f
        echo .
        del "%%f"
    )
)

REM Set the Shell entry in the Winlogon registry key to default (explorer.exe)
echo .
echo Reverting Windows shell back to Windows Explorer.
echo .
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d explorer.exe /f
echo .

REM Delete the Shell entry from the Winlogon registry key
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f
echo .
echo The Explorer.exe is now the Windows Shell.
echo .

REM Return taskbar to normal
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=0;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}"
start explorer.exe
echo Turned off auto hide taskbar.
echo .

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

:: Removes -noverifyfiles from all default Steam shortcuts
echo Your Steam Shortcuts will be updated to no longer include the launch option -noverifyfiles.
echo .

:: Updates Start Menu Shortcut (if it exists)
set "shortcutPath=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"

IF EXIST "%shortcutPath%" (
    powershell -Command "$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut('%shortcutPath%'); if ($shortcut.Arguments.Trim() -ne '') { $shortcut.Arguments = ''; $shortcut.Save(); Write-Host 'Start Menu shortcut updated.'; } else { Write-Host 'Start Menu shortcut had no arguments.'; }"
    echo .
) ELSE (
    echo Start Menu shortcut does not exist at "%shortcutPath%".
    echo .
)

:: Updates Desktop Shortcut (if it exists)
set "desktopShortcutPath=C:\Users\Public\Desktop\Steam.lnk"

IF EXIST "%desktopShortcutPath%" (
    powershell -Command "$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut('%desktopShortcutPath%'); if ($shortcut.Arguments.Trim() -ne '') { $shortcut.Arguments = ''; $shortcut.Save(); Write-Host 'Desktop shortcut updated.'; } else { Write-Host 'Desktop shortcut had no arguments.'; }"
    echo .
) ELSE (
    echo Desktop shortcut does not exist at "%desktopShortcutPath%".
    echo .
)

pause

:: End the script
endlocal
