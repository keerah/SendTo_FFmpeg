@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2020 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
   set "argVn[!argCount!]=%%~nx"
)

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.1 by Keerah.com                                 ---]
ECHO [---  Multi MP4 h264 module has been invoked                                   ---]
ECHO [---  Preset: 420, veryslow, crf 14, FILM, kf 2 sec, Audio Copy                ---]

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
	
IF %dscr% GTR 0 (SET "dscrName=_420_crf14") ELSE (SET "dscrName=")

FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding %%i of %argCount%: !argVn[%%i]!

	for /F "delims=" %%f in ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argVec[%%i]!"') do echo [     Video length is: %%f

	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i "!argVec[%%i]!" -c:v libx264 -preset veryslow -crf 14 -pix_fmt yuv420p -tune film -force_key_frames 0:00:02 -c:a copy -y "!argVn[%%i]!%dscrName%.mp4"
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]

if %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description inside it
rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02