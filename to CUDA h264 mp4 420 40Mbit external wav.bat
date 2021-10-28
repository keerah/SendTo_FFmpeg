@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2021 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v2.13 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked, this preset is single file only        ---]
ECHO [---  Preset: CUDA 420, slow, 40 Mbps, kf 2 sec, External Audio to aac256      ---]
ECHO [---  Using external audio source file: %~n1.wav

SET "cmdp=%~dp0"
SET "argp=%~dp1"

IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: LOCAL                                                          ---]
) ELSE (
	CALL "%cmdp%sendtoffmpeg_settings.cmd"
	ECHO [---  Settings: GLOBAL                                                         ---]
)

IF %1.==. (

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]

) ELSE (

	IF not EXIST %~n1.wav (

		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Couldn't find the external audio file: %~n1.wav
		GOTO End
	)	

	IF %dscr% GTR 0 (SET "dscrName=_cuda420_40Mbit_slow_ext") ELSE (SET "dscrName=")

	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	
	for /F "delims=" %%f in ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argVec[%%i]!"') do echo [     Video length is: %%f

	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i %1 -i %~n1.wav -c:a aac -b:a 256k -shortest -c:v h264_nvenc -preset slow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -y %~n1%dscrName%.mp4
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]

if %pse% GTR 0 PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem This batch uses your Cuda card for encoding (to 420 40Mbit mp4)
rem but also looks for a .wav file with the same name as your source video has
rem and places it instead of whatever audio was in your source video.
rem If the streams are different in length the arg -shortest tells FFmpeg
rem to cut the output to the shortest of audio or video.
rem New audio will be compressed into 256kbps AAC,
rem FFmpeg is clever and takes in account all the source audio channels.
rem Your source video and audio files must have exact names (except the extension of course).
rem The script checks if there's appropriate .wav file found and stops if it wasn't.

rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.