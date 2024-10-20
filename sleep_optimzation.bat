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
  ) else (
    :: Not running with elevated privileges, restart as Administrator
    echo Restarting as Administrator...
    echo .
    powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c \"%~f0 %*\"' -Verb runAs"
    exit
  )

echo By running this script, your Windows handheld will adopt a sleep mode similar to that of the Steam Deck.
echo .
echo For optimal performance, ensure auto sign-in is enabled, and your Windows password is removed.
echo .
echo Proceed at your own risk.
echo .
echo To continue, press Enter.
echo To exit, simply close this window.
pause
powershell -Command "PowerCfg /SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0"
powershell -Command "PowerCfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0"
powershell -Command "PowerCfg -h off"
echo Windows sleep mode has been successfully optimized.
echo You may close this window now.
pause