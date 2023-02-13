@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2021 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

ECHO [----------------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v2.15 by Keerah                                           ---]
ECHO [---  Preset: h264 mp4 CUDA 420, slow, 40 Mbps, kf 2 sec, External Audio to aac256    ---]
ECHO [---  This preset is single file only. Looking for audio source: %~n1.wav

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

	ECHO [----------------------------------------------------------------------------------------]

IF %1.==. (

	ECHO [     NO FILE SPECIFIED                                                                  ]

) ELSE (

	IF not EXIST %~n1.wav (

		ECHO [     Couldn't find the external audio file: %~n1.wav
		GOTO :End
	)	
	
	IF %dscr% GTR 0 (SET "dscrName=_420_cuda_40Mbit_muxaac256") ELSE (SET "dscrName=")

	SET "vlen="
	FOR /F "tokens=* delims=" %%f IN ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argFile[%%i].name!"') DO SET "vlen=%%f"

	ECHO [     Video length is: !vlen! seconds
	ECHO [     Muxing and Transcoding...                                                          ]
	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -stats -i %1 -i "%~n1.wav" -c:a aac -b:a 256k -shortest -c:v h264_nvenc -preset slow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -y "%~n1%dscrName%.mp4"
)

:End
ECHO [----------------------------------------------------------------------------------------]
ECHO [     SERVED                                                                             ]
ECHO [----------------------------------------------------------------------------------------]

if %pse% GTR 0 PAUSE