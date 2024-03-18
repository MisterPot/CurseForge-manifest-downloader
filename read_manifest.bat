@echo off


setlocal enabledelayedexpansion


echo Reading file - %1
echo =============================


set "JSON_FILE=%1"
set "SAVE_PATH=%2"
set "index=0"


if not exist "%SAVE_PATH%" (
    mkdir "%SAVE_PATH%"
    echo Created save dir: %SAVE_PATH%
) else (
    echo Directory %SAVE_PATH% exist. Writing files...
)
echo =============================


for /f "tokens=1,2,3 delims=,{}:" %%a in (
    'type "%JSON_FILE%" ^| findstr /C:"\"projectID\"" /C:"\"fileID\""'
) do (

    set /a "modulus=!index! %% 2"

    if !modulus! equ 0 (
        set "projectID=%%b"
        set "projectID=!projectID: =!"
    ) else (
        set "fileID=%%b"
        set "fileID=!fileID: =!" 
        set "REDIRECTS=3"
        set "URL=https://www.curseforge.com/api/v1/mods/!projectID!/files/!fileID!/download"
        echo Checking !URL!

        for /l %%i in (1, 1, !REDIRECTS!) do (
            for /f "delims=" %%a in ('curl -s -o NUL -w "%%{redirect_url}" "!URL!"') do (
                set "URL=%%a"
            )
        )
        for /f "tokens=*" %%a in ("!URL!") do (
            set "filename=%%~nxa"

            if /I not "!filename:~-4!" == ".jar" (
                echo File "!filename!" is not .jar. Skipping.
            ) else (
                echo Downloading ...
                curl -X GET !URL! -o !SAVE_PATH!\!filename! --progress-bar -w "Downloaded: %%{size_download} bytes\n"
                echo New file `!filename!` created
            )
            echo =============================
        )
    )
    set /a "index+=1"
)


echo Files downloaded successfully !
