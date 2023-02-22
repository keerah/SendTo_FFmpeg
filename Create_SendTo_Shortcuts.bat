@echo off
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM v3.15

SET "divline=-----------------------------------------------------------------------------------------------"

ECHO %divline%
ECHO This is an installation script for SendTo_FFmpeg batches.
ECHO Make sure you're running this script from the folder that is going to keep the presets present all the time.
ECHO The script will create shortcuts to all of the presets and will put them into Windows SendTo folder.
ECHO You can remove the unnecessary ones after that. The new Explorer window with that folder will be open for you.
ECHO You will be prompted to overwrite shortcuts if they're already exist.
ECHO %divline%

ECHO.
PAUSE
ECHO.

setlocal enabledelayedexpansion

REM Path to icon. You can change this path to an .ico file as well.
SET "iconpath=%WINDIR%\System32\shell32.dll,115"

SET "lnksource=%~dp0"
SET "SCRIPT=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
SET "lnkdir=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-shortcuts"
SET "stfolder=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo"

MKDIR "%lnkdir%"

IF EXIST %stfolder% (

    ECHO %divline%
    ECHO The current folder is: %lnksource%
    ECHO Stage 1/3
    ECHO    Getting the preset list...

    SET /A cnt=0
    FOR /F "tokens=1 delims=" %%F IN ('dir /b /a-d "to *.bat"') DO (
        SET /A cnt=!cnt!+1
        SET "prs[!cnt!].file=%%F"
        CALL SET "prs[!cnt!].arr=Prs^(!cnt!^) = "%%prs[!cnt!].file:.bat=%%""
    )
    ECHO    !cnt! presets found.
    ECHO %divline%

    IF !cnt! GEQ 0 (

        ECHO Stage 2/3
        ECHO    Creating shortcuts...

        ECHO Dim Prs^(!cnt!^) >> %SCRIPT%

        FOR /L %%I IN (1,1,!cnt!) DO (
            ECHO       Preset #%%I: "!prs[%%I].file!"
            ECHO !prs[%%I].arr!  >> %SCRIPT%
        )

        ECHO For I = 1 to !cnt! >> %SCRIPT%
        ECHO    Set oWS = WScript.CreateObject^("WScript.Shell"^) >> %SCRIPT%
        ECHO    Set oLink = oWS.CreateShortcut^("%lnkdir%" + "\" + Prs^(I^)^ + ".lnk"^) >> %SCRIPT%
        ECHO    oLink.IconLocation = "%iconpath%" >> %SCRIPT%
        ECHO    oLink.TargetPath = "%lnksource%" + Prs^(I^) + ".bat" >> %SCRIPT%
        ECHO    oLink.WorkingDirectory ="" >> %SCRIPT%
        ECHO    oLink.Save >> %SCRIPT%
        ECHO Next >> %SCRIPT%

        cscript /nologo "%SCRIPT%"
        IF EXIST "%SCRIPT%" DEL "%SCRIPT%"
        ECHO %divline%

        ECHO Stage 3/3
        ECHO    Moving the sortucuts...
        ECHO    The SendTo folder is: "%stfolder%"

        MOVE /-Y "%lnkdir%\*.lnk" "%stfolder%"
        RMDIR /S /Q "%lnkdir%"
        
        ECHO %divline%
        ECHO The SendTo folder will now open.
        ECHO That's all. Enjoy^!
        ECHO %divline%
        EXPLORER "%stfolder%"
    ) ELSE (
        
        ECHO No presets were found in the current folder.
        ECHO Make sure you're running this script from the folder that contains the downloaded SendTo_FFmpeg files.
        ECHO %divline%
    )
) ELSE (
    ECHO %divline%
    ECHO Unable to locate the SendTo folder^!
    ECHO The path "%stfolder%" does not exist.
    ECHO %divline%
)

endlocal
ECHO.
PAUSE
EXIT