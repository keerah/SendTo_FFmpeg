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
	GOTO :End
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
	ECHO !    Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!
	GOTO :End
)


REM compression settings
SET "wset.hline1=Preset: Gif 256 colors, 304px width, 30 fps, 2 pass, sierra2_4a"
SET "wset.fps=30"
SET "wset.params=-v %vbl% -hide_banner -stats -thread_queue_size 256"
SET "wset.prepass=-vf "fps=%wset.fps%,scale=304:-1:flags=lanczos,palettegen=max_colors=128:stats_mode=full""
SET "wset.videocomp=-filter_complex "fps=%wset.fps%,scale=304:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=sierra2_4a""
	REM There's no alpha channel support yet. The output file will be saved to the same folder your source comes from.
	REM You can change the frame rate/resolution by changing fps=XX/scale=XXX values to your preference, just do it in both FFmpeg command lines.
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_hqgif256_304_30") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.gif"
SET "wset.seqfrout=-update 1 -frames:v 1" 


IF EXIST "%cmdp%sendtoffmpeg_encoder02.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder02.cmd"
) ELSE (
	ECHO !    Sorry, the sendtoffmpeg_encoder02.cmd is unreacheable. Unable to continue!
	GOTO :End
)

:End
IF %pse% GTR 0 PAUSE