@ECHO OFF
setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.15 by Keerah.com                                ---]
ECHO [---  Multi GIF module has been invoked                                        ---]
ECHO [---  Preset: 15 fps, 420px, 2 pass                                            ---]

IF %argCount% == 0 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
	GOTO End
	)
	
IF %argCount% GTR 1 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     %argCount% files queued to encode
	)
	
	FOR /L %%i IN (1,1,%argCount%) DO (
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Encoding file %%i of %argCount%
		ECHO [     STAGE 1: Generating a palette                                               ]
		"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -v warning -i "!argVec[%%i]!" -vf fps=15,scale=420:-1:flags=lanczos,palettegen -y "!argVec[%%i]!"_palette.png  
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Encoding file %%i of %argCount%
		ECHO [     STAGE 2: Encoding to Gif using the generatied palette                       ]
		"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -v warning -i "!argVec[%%i]!" -i "!argVec[%%i]!"_palette.png -filter_complex "fps=15,scale=420:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "!argVec[%%i]!"_hqgif.gif 
		IF EXIST "!argVec[%%i]!"_palette.png DEL /s "!argVec[%%i]!"_palette.png > nul
	)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem This script creates high quality GIFs and supports multiple file selection at once (processes them in queue)
rem All videos rescaled to 420 pixels and stripped to 15 fps. The script doesn't have alpha channel support yet though.
rem You can change frame rate changing fps=15 value to your preference, just do it in both FFmpeg command lines.
rem The output file will be saved to the same folder your source comes from.

rem The script works in 2 stages (2 pass encoding). First one scans the source and creates a colour palette of it to minimise your Gif size.
rem And the second pass creates the Gif itself. 

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.
rem To encode just a piece of your source video add to command parameters something like -ss 12:23 -t 35 where -ss is start time and -t is duration
rem You can also make a few versions of this script for various Gif settings.