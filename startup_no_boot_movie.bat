@echo off

if not "%Minimized%"=="" goto :Minimized
set Minimized=True
start /min cmd /C "%~dpnx0"
goto :EOF
:Minimized

REM Replace YOUR LAUNCHER PATH with the path to the launcher of your choice
start /B "" "YOUR LAUNCHER PATH" &
REM How long do you need the Windows Desktop to wait before your launcher is loaded?
timeout /t 2
start explorer.exe