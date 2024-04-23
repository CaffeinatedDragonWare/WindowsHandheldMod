@echo off
setlocal enabledelayedexpansion

set "sourceFolder=%UserProfile%\Videos\BootVideos"
set "destinationFolder=%UserProfile%\Videos"
set "inputFile=%UserProfile%\Videos\previous_boot_video.log"

REM Check if the input file exists
if not exist "%inputFile%" (
    echo created > "%inputFile%"
)

set "fileToReplace=boot.webm"

REM Take a random file from the source folder
set "sourceFiles=%sourceFolder%\*.*"

REM Count files in the source folder
set /a sourceFilesCount=0
for %%f in (%sourceFiles%) do (
    set /a sourceFilesCount+=1
)

REM if only one file
if %sourceFilesCount% leq 1 (
    set /a "randIdx=0"
    
) else (
    REM Take a Random Index initially
    set /a "randIdx=!random! %% sourceFilesCount"
        :check_match
        REM Read the content of inputFile
        for /f "usebackq tokens=*" %%i in ("%inputFile%") do (
            set "content=%%i"
        )

        REM Check if the boot movie was played last time
        if "%content%" equ "%randIdx%" (
            REM Generate a new random index if content does match
            set /a "randIdx=!random! %% sourceFilesCount"
            goto :check_match
        )
    )
)

REM Writes the ID of the Boot movie that was played in the input file
< nul set /p=!randIdx!> "%inputFile%"

REM Chooses Random a File
set "randomFile="
set /a "count=0"
for /f "tokens=* delims=" %%f in ('dir /b /a-d "%sourceFiles%"') do (
    if !count! equ %randIdx% (
        set "randomFile=!sourceFolder!\%%f"
        goto :break
    )
    set /a "count+=1"
)

:break

REM Copies the random file to the destination folder and renames it to boot.webm
if defined randomFile (
    del "%destinationFolder%\%fileToReplace%" 2>nul
    copy "!randomFile!" "%destinationFolder%\%fileToReplace%"

) else (
    echo No files found in the source folder.
)

endlocal
