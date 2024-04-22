@echo off

if not "%Minimized%"=="" goto :Minimized
set Minimized=True
start /min cmd /C "%~dpnx0"
goto :EOF
:Minimized

start /B "" "C:\Program Files (x86)\Steam\Steam.exe" -noverifyfiles &

if exist "%UserProfile%\Videos\ffplay.exe" (
    if exist "%UserProfile%\Videos\Boot.webm" (

        start /B "" "%UserProfile%\Videos\ffplay.exe" -left 0 -top 0 -x -alwaysontop -fs -noborder -autoexit -loglevel quiet -loop 1 "%UserProfile%\Videos\Boot.webm" 2>NUL
    ) else (
        echo "Boot.webm not found."
    )
) else (
    echo "ffplay.exe not found."
)

timeout /t 2
start explorer.exe

:check_ffplay
tasklist /FI "IMAGENAME eq ffplay.exe" 2>NUL | find /I /N "ffplay.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 5 /nobreak >nul
    goto check_ffplay
) else (
    call random_boot_movie.bat
)
