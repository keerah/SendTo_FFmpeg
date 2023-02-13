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
ECHO [---  SendTo FFmpeg encoder v3.0 by Keerah.com                                        ---]
ECHO [---  Preset: Gif 32 colors, 616px width, 10 fps, 2 pass, Bayer 3                     ---]

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
SET "wset.prepass=-vf "fps=10,scale=616:-1:flags=lanczos,palettegen=max_colors=32:stats_mode=full""
SET "wset.videocomp=-filter_complex "fps=10,scale=616:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3""
	REM There's no alpha channel support yet. The output file will be saved to the same folder your source comes from.
	REM You can change the frame rate/resolution by changing fps=XX/scale=XXX values to your preference, just do it in both FFmpeg command lines.
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_hqgif32_616_10") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.gif"
SET "wset.seqfrout=-update 1 -frames:v 1" 


IF EXIST "%cmdp%sendtoffmpeg_encoder02.cmd" (
	CALL "%cmdp%sendtoffmpeg_encoder02.cmd"
) ELSE (
	ECHO [---  Sorry, the sendtoffmpeg_encoder02.cmd is unreacheable. Unable to continue!      ---]
	GOTO :End
)

:End
IF %pse% GTR 0 PAUSE








FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 1: Generating a palette                                               ]
	
	"%ffpath%ffmpeg.exe" -v %vbl% -i "!argVec[%%i]!" -vf "fps=10,scale=616:-1:flags=lanczos,palettegen=max_colors=32:stats_mode=full" -y "!argVec[%%i]!"_palette.png  
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 2: Encoding to Gif using the generatied palette                       ]
	
	rem dither "bayer","heckbert","floyd_steinberg","sierra2","sierra2_4a"
	
	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i "!argVec[%%i]!" -i "!argVec[%%i]!"_palette.png -filter_complex "fps=10,scale=616:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" -y "!argVec[%%i]!"%dscrName%.gif 
	
	IF EXIST "!argVec[%%i]!"_palette.png DEL /s "!argVec[%%i]!"_palette.png > nul
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
IF %pse% GTR 0 PAUSE

rem This script creates high quality GIFs and supports multiple file selection at once (processes them in queue)
rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description inside of it
rem There's no alpha channel support yet. The output file will be saved to the same folder your source comes from.
rem You can change the frame rate/resolution by changing fps=XX/scale=XXX values to your preference, just do it in both FFmpeg command lines.
rem The script works in 2 stages (2 pass encoding). First one scans the source and creates a colour palette of it to minimise your Gif size. And the second pass creates the Gif itself.
rem To encode just a piece of your source video add to command parameters something like -ss 12:23 -t 35 where -ss is start time and -t is duration