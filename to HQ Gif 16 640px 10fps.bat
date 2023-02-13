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
ECHO [---  Preset: Gif 16 colors, 640px width, 10 fps, 2 pass                              ---]

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
SET "wset.fps=10"
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.prepass=-vf fps=10,scale=640:-1:flags=lanczos,palettegen=max_colors=16:stats_mode=full"
SET "wset.videocomp=-filter_complex "fps=10,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse""
	REM There's no alpha channel support yet. The output file will be saved to the same folder your source comes from.
	REM You can change the frame rate/resolution by changing fps=XX/scale=XXX values to your preference, just do it in both FFmpeg command lines.
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_hqgif16_640_10") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.gif"
SET "wset.seqfrout=-update 1 -frames:v 1" 
	REM prepass only to one frame palette


IF EXIST "%cmdp%sendtoffmpeg_encoder02.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder02.cmd"
) ELSE (
	ECHO [---  Sorry, the sendtoffmpeg_encoder02.cmd is unreacheable. Unable to continue!      ---]
	GOTO :End
)

:End
IF %pse% GTR 0 PAUSE