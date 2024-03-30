@echo off

if not "%Minimized%"=="" goto :Minimized
set Minimized=True
start /min cmd /C "%~dpnx0"
goto :EOF
:Minimized

start /B %LocalAppData%\Playnite\Playnite.fullscreenapp.exe --hidesplashscreen &
timeout /t 2
start explorer.exe