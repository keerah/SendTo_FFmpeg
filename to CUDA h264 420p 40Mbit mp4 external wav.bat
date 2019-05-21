@ECHO OFF


SET "cmdp=%~dp0"
CALL "%cmdp%sendtoffmpeg_settings.cmd"

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked                                         ---]
ECHO [---  Preset: CUDA 420 main, 40 Mbps, keyfr 2 sec, External Audio to AAC 256   ---]
ECHO [---  Using external audio source file: %~n1.wav
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
) ELSE (
	IF not EXIST %~n1.wav (
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Couldn't find the external audio file: %~n1.wav
		GOTO End
	)	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	"%ffpath%ffmpeg.exe" -v %vbl% -vsync 0 -hwaccel cuvid -i %1 -i "%~n1.wav" -c:a aac -b:a 256k -shortest -c:v h264_nvenc -profile:v main -level 4.1 -preset veryslow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -y "%~n1_cuda420_40Mbit_au.mp4"
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
rem Just one hint from me on -b:v 40M argument, which defines the bitrate for the output.
rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02
rem This script does not support muliple files 