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
ECHO [---  Preset: h264 mp4 420, veryslow, crf 18, Film, kf 2 sec, Audio aac256            ---]

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
SET "wset.videocomp=-c:v libx264 -preset veryslow -crf 18 -pix_fmt yuv420p -tune film -force_key_frames 0:00:02"
	REM The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02
SET "wset.audiocomp=-c:a aac -b:a 256k"
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_420_crf18") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.mp4"

IF EXIST "%cmdp%sendtoffmpeg_encoder01.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder01.cmd"
) ELSE (
	ECHO [---  Sorry, the sendtoffmpeg_encoder01.cmd is unreacheable. Unable to continue!      ---]
	GOTO :End
)

:End
if %pse% GTR 0 PAUSE