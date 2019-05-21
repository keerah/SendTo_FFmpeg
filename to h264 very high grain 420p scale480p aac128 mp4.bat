@ECHO OFF
ECHO [---------------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                      ---]
ECHO [---  MP4 h264 module has been invoked                                               ---]
ECHO [---  Preset: 420 main 4.0, veryslow, crf 20, 480p, GRAIN, keyfr 2 sec, AAC 128k     ---]
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                                 ]
) ELSE (
	ECHO [---------------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                                    ]
	"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -i %1 -c:v libx264 -profile:v main -level 4.0 -preset veryslow -crf 20 -pix_fmt yuv420p -vf scale=480:270 -sws_flags bicubic -tune grain -force_key_frames 0:00:02 -c:a aac -b:a 128k -y "%~n1_420_high_480p.mp4"
)
ECHO [---------------------------------------------------------------------------------------]
ECHO [---  SERVED                                                                            ]
ECHO [---------------------------------------------------------------------------------------]
PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.

rem ==== this is a dynamic preset I use to encode things differently