@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2021 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v2.2 by Keerah.com                                ---]
ECHO [---  Multi GIF module has been invoked                                        ---]
ECHO [---  Preset: 10 fps, 420px, 2 pass                                            ---]

SET "cmdp=%~dp0"
SET "argp=%~dp1"

IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: LOCAL                                                          ---]
) ELSE (
	CALL "%cmdp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: GLOBAL                                                         ---]
)

IF %argCount% == 0 (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
	GOTO End
)
	
IF %argCount% GTR 1 (
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     %argCount% files queued to encode
)

IF %dscr% GTR 0 (SET "dscrName=_hqgif") ELSE (SET "dscrName=")

FOR /L %%i IN (1,1,%argCount%) DO (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 1: Generating a palette                                               ]
	
	"%ffpath%ffmpeg.exe" -v %vbl% -i "!argVec[%%i]!" -vf fps=10,scale=420:-1:flags=lanczos,palettegen -y "!argVec[%%i]!"_palette.png  
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 2: Encoding to Gif using the generatied palette                       ]
	
	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i "!argVec[%%i]!" -i "!argVec[%%i]!"_palette.png -filter_complex "fps=10,scale=420:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "!argVec[%%i]!"%dscrName%.gif 
	
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