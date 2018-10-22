@ECHO OFF
ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked                                         ---]
ECHO [---  Preset: 420 Baseline Level 3.0, Slow, crf 24, kf 2 sec, Audio AAC 128    ---]
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
) ELSE (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -i %1 -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -preset slow -crf 24 -force_key_frames 0:00:02 -c:a aac -b:a 128k -y %~n1_420_constrL3.mp4
)
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem This batch encodes to a very strict (very compatible) Baseline v3.0 profile 
rem It also reencodes the audio to 128 kbps AAC to guarantee full compatibility to virtually any player

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.