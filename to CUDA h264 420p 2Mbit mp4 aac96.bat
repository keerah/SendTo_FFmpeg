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

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.1 by Keerah.com                                 ---]
ECHO [---  Multi MP4 h264 module has been invoked                                   ---]
ECHO [---  Preset: CUDA 420 main, 2 Mbps, nokeyfr, Audio AAC 96                     ---]

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
	
IF %dscr% GTR 0 (SET "dscrName=_cuda420_2Mbit_aac96") ELSE (SET "dscrName=")

FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding %%i of %argCount%: !argVn[%%i]!
	
	"%ffpath%ffmpeg.exe" -v %vbl% -vsync 0 -hwaccel cuvid -i "!argVec[%%i]!" -c:v h264_nvenc -profile:v main -preset slow -b:v 2M -pix_fmt yuv420p -c:a aac -b:a 96k -y "!argVn[%%i]!%dscrName%.mp4"
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
if %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description insite it
rem This preset uses a separate Nvidia codec h264_nvenc.
rem For more information on the codec and its parameters refer to Nvidia's application note
rem https://developer.nvidia.com/designworks/dl/Using_FFmpeg_with_NVIDIA_GPU_Hardware_Acceleration-pdf
rem Just one hint from me on -b:v 10M argument, which defines the bitrate for the output.
rem The output video will have keyframes each second due to -force_key_frames 0:00:01