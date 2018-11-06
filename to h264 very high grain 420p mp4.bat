@ECHO OFF
ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked                                         ---]
ECHO [---  Preset: 420 main 4.0, veryslow, crf 18, GRAIN, keyfr 2 sec, Audio Copy   ---]
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
) ELSE (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -i %1 -c:v libx264 -profile:v main -level 4.0 -preset veryslow -crf 18 -pix_fmt yuv420p -tune grain -force_key_frames 0:00:02 -c:a copy -y %~n1_420_highest.mp4
)
ECHO [---------------------------------------------------------------------------------]
ECHO [---  SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.

rem ==== this is a dynamic preset I use to encode things differently