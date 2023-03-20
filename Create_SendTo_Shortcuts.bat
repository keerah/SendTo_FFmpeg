@echo off
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM v3.5

TITLE SendTo shorcuts installer
ECHO [03m[33mSendTo_ffmpeg v3.5 installation script[0m
SET "divline=-----------------------------------------------------------------------------------------------"

ECHO %divline%
ECHO Make sure you're running this script from the [31mpermanent location containing all scripts[0m.
ECHO The script will create shortcuts to all of the presets in the Windows SendTo folder.
ECHO The folder will be open for you after that so you could remove unnecessary ones.
ECHO %divline%

setlocal enabledelayedexpansion

REM Path to icon. You can change this path to an .ico file as well.
SET "iconpath=%WINDIR%\System32\shell32.dll,115"

SET "lnksource=%~dp0"
SET "SCRIPT=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
SET "lnkdir=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-shortcuts"
SET "stfolder=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo"

MKDIR "%lnkdir%"

IF EXIST %stfolder% (

    ECHO [34mThe SendTo shortcuts folder is:[0m [03m"%stfolder%"[0m
    ECHO [34mCurrent folder is:[0m [03m"!lnksource!"[0m
    ECHO !divline!
    ECHO If you renamed the shortcuts previously or it's a major SendTo_FFmpeg update,
    ECHO then it's [31mrecommended[0m to remove all of the older shortcuts prior proceeding.
    ECHO I can open the Windows SendTo folder for you now and wait for you to remove them.
    ECHO All other shortcuts will be overwritten after this.
    SET /P openfolder="[34mOpen the folder and wait (Y=yes) or skip (hit enter)?[0m"

    SET "cond=0"
    IF "!openfolder!" == "y" SET "cond=1"
    IF "!openfolder!" == "yes" SET "cond=1"
    IF "!openfolder!" == "ya" SET "cond=1"
    IF "!openfolder!" == "yeah" SET "cond=1"

    IF "!cond!" == "1" (
        ECHO.
        EXPLORER "!stfolder!"
        ECHO The folder opened. After you finished return to this window and hit any key...
        PAUSE > NUL
    )

    ECHO !divline!
    ECHO [01m[34mStage 1/3:[0m Getting the preset list...

    SET /A cnt=0
    FOR /F "tokens=1 delims=" %%F IN ('dir /b /a-d "to *.bat"') DO (
        SET /A cnt=!cnt!+1
        SET "prs[!cnt!].file=%%F"
        CALL SET "prs[!cnt!].arr=Prs^(!cnt!^) = "%%prs[!cnt!].file:.bat=%%""
    )
    ECHO    !cnt! presets found.
    ECHO !divline!

    IF !cnt! GEQ 0 (

        ECHO [01m[34mStage 2/3:[0m Creating shortcuts...

        ECHO Dim Prs^(!cnt!^) >> %SCRIPT%

        FOR /L %%I IN (1,1,!cnt!) DO (
            ECHO    Preset #%%I: "!prs[%%I].file!"
            ECHO !prs[%%I].arr!  >> !SCRIPT!
        )

        ECHO For I = 1 to !cnt! >> !SCRIPT!
        ECHO    Set oWS = WScript.CreateObject^("WScript.Shell"^) >> !SCRIPT!
        ECHO    Set oLink = oWS.CreateShortcut^("!lnkdir!" + "\" + Prs^(I^)^ + ".lnk"^) >> !SCRIPT!
        ECHO    oLink.IconLocation = "!iconpath!" >> !SCRIPT!
        ECHO    oLink.TargetPath = "!lnksource!" + Prs^(I^) + ".bat" >> !SCRIPT!
        ECHO    oLink.WorkingDirectory ="" >> !SCRIPT!
        ECHO    oLink.Save >> !SCRIPT!
        ECHO Next >> !SCRIPT!

        cscript /nologo "!SCRIPT!"
        IF EXIST "!SCRIPT!" DEL "!SCRIPT!"
        ECHO !divline!

        ECHO [01m[34mStage 3/3:[0m Moving the sortucuts...

        MOVE /Y "!lnkdir!\*.lnk" "!stfolder!" > NUL
        RMDIR /S /Q "!lnkdir!"
        
        ECHO !divline!
        ECHO The SendTo folder will now open.
        EXPLORER "!stfolder!"
        ECHO [34mThat's all. Enjoy^^![0m
        ECHO !divline!
    ) ELSE (
        
        ECHO [31mNo presets were found in the current folder.[0m
        ECHO Make sure you're running this script from the folder that contains the downloaded SendTo_FFmpeg files.
        ECHO !divline!
    )
) ELSE (
    ECHO !divline!
    ECHO [01m[31mUnable to locate the SendTo folder^^![0m
    ECHO The path [01m"!stfolder!"[0m does not exist.
    ECHO !divline!
)

endlocal
ECHO.
PAUSE
EXIT