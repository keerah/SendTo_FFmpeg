@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

SET argCount=0
FOR %%f IN (%*) DO (
   SET /A argCount+=1
   SET "argFile[!argCount!].name=%%~f"
   SET "argFile[!argCount!].trname=%%~nf"
   SET "argFile[!argCount!].ext=%%~xf"
   SET "argFile[!argCount!].path=%%~dpf"
)

IF %argCount% LEQ 0 (
	ECHO [----------------------------------------------------------------------------------------]
	ECHO [     NO FILE^(S^) SPECIFIED                                                               ]
	GOTO :End
)

ECHO [----------------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v3.0 by Keerah                                            ---]
ECHO [---  Preset: PNG, max compression of 9                                               ---]

SET "cmdp=%~dp0"
SET "argp=%~dp1"

REM get settings
IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: *LOCAL*, Verbosity: !vbl!
) ELSE (
	IF EXIST "%cmdp%sendtoffmpeg_settings.cmd" (
		CALL "%cmdp%sendtoffmpeg_settings.cmd"
		ECHO [---  Settings: Global, Verbosity: !vbl!
	) ELSE (
		ECHO [---  Sorry, the sendtoffmpeg_settings.cmd is unreacheable. Unable to continue!       ---]	
		GOTO :End
	)
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
	ECHO [---      Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!          ---]
	GOTO :End
)


REM compression settings
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-compression_level 9"
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_pnglow") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!_%%0!frcounter!d.png"

IF EXIST "%cmdp%sendtoffmpeg_encoder01.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder01.cmd"
) ELSE (
	ECHO [---  Sorry, the sendtoffmpeg_encoder01.cmd is unreacheable. Unable to continue!      ---]
	GOTO :End
)

:End
if %pse% GTR 0 PAUSE