@echo off

if not "%Minimized%"=="" goto :Minimized
set Minimized=True
start /min cmd /C "%~dpnx0"
goto :EOF
:Minimized

start /B "" "%UserProfile%\Videos\ffplay.exe"  -left 0 -top 0 -x 1280 -y 800 -alwaysontop -fullscreen -noborder -autoexit -loglevel quiet -loop 1 "%UserProfile%\Videos\Boot.webm" 2>NUL &
start /B %LocalAppData%\Playnite\Playnite.fullscreenapp.exe --hidesplashscreen &
timeout /t 2
start explorer.exe
call random_boot_movie.bat