@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2019 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
   set "argVn[!argCount!]=%%~nx"
)

SET "cmdp=%~dp0"
CALL "%cmdp%sendtoffmpeg_settings.cmd"

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.1 by Keerah.com                                 ---]
ECHO [---  Multi MP4 h264 module has been invoked                                   ---]
ECHO [---  Preset: 420 baseline 3.0, slow, crf 24, keyfr 2 sec, Audio AAC 128       ---]

IF %argCount% == 0 (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
	GOTO End
)
	
IF %argCount% GTR 1 (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     %argCount% files queued to encode
)
	
	IF %dscr% GTR 0 (SET "dscrName=_420_Baseline3") ELSE (SET "dscrName=")
	
	FOR /L %%i IN (1,1,%argCount%) DO (
		
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Transcoding %%i of %argCount%: !argVn[%%i]!
		
		"%ffpath%ffmpeg.exe" -v %vbl% -i "!argVec[%%i]!" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -preset slow -crf 24 -force_key_frames 0:00:02 -c:a aac -b:a 128k -y "!argVn[%%i]!%dscrName%.mp4"
	)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
if %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description inside it
rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02
rem This batch encodes to a very strict (very compatible) Baseline v3.0 profile 
rem It also reencodes the audio to 128 kbps AAC to guarantee full compatibility to virtually any player
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.