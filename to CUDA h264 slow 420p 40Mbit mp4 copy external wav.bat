@ECHO OFF
ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked                                         ---]
ECHO [---  Preset: CUDA 420 main, Slow, 40Mbps, kf 2 sec, External Audio to AAC     ---]
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
	"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -vsync 0 -hwaccel cuvid -i %1 -i %~n1.wav -c:a aac -b:a 256k -shortest -c:v h264_nvenc -profile:v main -level 4.1 -preset veryslow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -y %~n1_cuda420_40Mbit_slow_ext.mp4
)
:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
PAUSE

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