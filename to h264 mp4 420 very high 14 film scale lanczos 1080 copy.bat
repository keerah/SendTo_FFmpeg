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
	ECHO [-----------------------------------------------------------------------------------]
	ECHO [     NO FILE^(S^) SPECIFIED                                                          ]
	GOTO :End
)

ECHO [-----------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v3.0 by Keerah                                       ---]
ECHO [---  Preset: h264 mp4 420, veryslow, crf 14, lanczos 1080p, Film, kf 2 sec, Copy --]

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
		ECHO [---  Sorry, the sendtoffmpeg_settings.cmd is unreacheable. Unable to continue!  ---]	
		GOTO :End
	)
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
	ECHO [---      Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!     ---]
	GOTO :End
)


REM compression settings
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-c:v libx264 -preset veryslow -crf 14 -pix_fmt yuv420p -vf scale=-1:1080 -sws_flags lanczos -tune film -force_key_frames 0:00:02"
	REM The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02
	REM scales to fit vertically to 1080px
SET "wset.audiocomp=-c:a copy"
	REM This one simply copies the source audio stream
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_420_crf16_x1080") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.mp4"

IF EXIST "%cmdp%sendtoffmpeg_encoder01.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder01.cmd"
) ELSE (
	ECHO [---  Sorry, the sendtoffmpeg_encoder01.cmd is unreacheable. Unable to continue! ---]
	GOTO :End
)

:End
if %pse% GTR 0 PAUSE