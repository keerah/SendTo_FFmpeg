@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
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

SET "cmdp=%~dp0"
SET "argp=%~dp1"

REM get settings
IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	SET "wset.hline3=Settings: *LOCAL*, Verbosity: !vbl!"
) ELSE (
	IF EXIST "%cmdp%sendtoffmpeg_settings.cmd" (
		CALL "%cmdp%sendtoffmpeg_settings.cmd"
		SET "wset.hline3=Settings: Global, Verbosity: !vbl!"
	) ELSE (
		ECHO !    Sorry, the sendtoffmpeg_settings.cmd is unreacheable. Unable to continue!
		GOTO :End
	)
)

IF %argCount% LEQ 0 (
	ECHO %divline%
	ECHO      NO FILE^(S^) SPECIFIED
	ECHO %divline%
	GOTO :End
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
	ECHO !    Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!
	GOTO :End
)


REM compression settings
SET "wset.hline1=Preset: JPEG quality 100"
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-vf "scale=in_range=mpeg:out_range=full" -q:v 0"
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_jpeg100") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!_%%0!frcounter!d.jpg"


IF EXIST "%cmdp%sendtoffmpeg_encoder01.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder01.cmd"
) ELSE (
	ECHO !    Sorry, the sendtoffmpeg_encoder01.cmd is unreacheable. Unable to continue!
	GOTO :End
)

:End
if %pse% GTR 0 PAUSE