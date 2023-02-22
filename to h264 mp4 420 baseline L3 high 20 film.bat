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
SET "wset.hline1=Preset: h264 mp4, 420 L3 3.0, veryslow, crf 20, Film, kf 2 sec, Audio aac128"
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -tune film -preset veryslow -crf 20 -force_key_frames 0:00:02"
	REM The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02
	REM This batch encodes to a very strict (very compatible) Baseline v3.0 profile 
	REM It also reencodes the audio to 128 kbps AAC to guarantee full compatibility to virtually any player
SET "wset.audiocomp=-c:a aac -b:a 128k"
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_420_crf20_Baseline3") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.mp4"


IF EXIST "%cmdp%sendtoffmpeg_encoder01.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder01.cmd"
) ELSE (
	ECHO !    Sorry, the sendtoffmpeg_encoder01.cmd is unreacheable. Unable to continue!
	GOTO :End
)

:End
if %pse% GTR 0 PAUSE