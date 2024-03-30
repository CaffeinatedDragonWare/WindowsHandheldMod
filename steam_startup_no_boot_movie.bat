@echo off

if not "%Minimized%"=="" goto :Minimized
set Minimized=True
start /min cmd /C "%~dpnx0"
goto :EOF
:Minimized

start /B "" "C:\Program Files (x86)\Steam\Steam.exe" -noverifyfiles &
timeout /t 2
start explorer.exe