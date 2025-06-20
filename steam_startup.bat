@echo off

if not exist "%UserProfile%\Videos\invisible_startup.vbs" (
    if not "%Minimized%"=="" (
        goto :Minimized
    )
    set Minimized=True
    start /min cmd /C "%~dpnx0"
    goto :EOF
)

:Minimized

if exist "%UserProfile%\Videos\ffplay.exe" (
    if exist "%UserProfile%\Videos\Boot.webm" (

        start /B "" "%UserProfile%\Videos\ffplay.exe" -left 0 -top 0 -alwaysontop -fs -noborder -autoexit -loglevel quiet -loop 1 "%UserProfile%\Videos\Boot.webm" 2>NUL
    ) else (
        echo "Boot.webm not found."
    )
) else (
    echo "ffplay.exe not found."
)

timeout /t 2 /nobreak >nul
start /B "" "C:\Program Files (x86)\Steam\Steam.exe" -noverifyfiles -gamepadui &

:check_ffplay
tasklist /FI "IMAGENAME eq ffplay.exe" 2>NUL | find /I /N "ffplay.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 5 /nobreak >nul
    goto check_ffplay
) else (
    call "%UserProfile%\Videos\random_boot_movie.bat"
)

:check_steam_big_picture
tasklist /FI "IMAGENAME eq Steam.exe" /FI "WINDOWTITLE eq "Steam Big Picture Mode"" 2>NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 5 /nobreak >nul
    goto check_steam_big_picture
) else (
    timeout /t 5 /nobreak >nul
    start explorer.exe
)
