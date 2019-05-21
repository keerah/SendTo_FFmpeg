@ECHO OFF


SET "cmdp=%~dp0"
CALL "%cmdp%sendtoffmpeg_settings.cmd"

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  audio muxing module has been invoked                                     ---]
ECHO [---  Preset: video copy, mux external mp3                                     ---]
ECHO [---  Using external audio source file: %~n1.mp3
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
) ELSE (
	IF not EXIST "%~n1.mp3" (
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Couldn't find the external audio file: %~n1.wav
		GOTO End
	)	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	"%ffpath%ffmpeg.exe" -v %vbl% -i %1 -i "%~n1.mp3" -codec copy -shortest -y "%~n1_mux_mp3.mp4"
)
:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
IF %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description inside it
rem This batch looks for a .wav file with the same name as your source video has
rem and places it instead of whatever audio was in your source video.
rem If the streams are different in length the arg -shortest tells FFmpeg
rem to cut the output to the shortest of audio or video.
rem New audio will be a copy of the external audio, the video stream is copied also (no recompression).
rem FFmpeg is clever and takes in account all the source audio channels.
rem This script does not support muliple files 