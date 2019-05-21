@ECHO OFF
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
ECHO [---  Preset: 420 main 4.0, veryslow, crf 14, GRAIN, keyfr 2sec, Audio AAC 128 ---]

IF %argCount% == 0 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
	GOTO End
	)
	
IF %argCount% GTR 1 (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     %argCount% files queued to encode
	)
	
	FOR /L %%i IN (1,1,%argCount%) DO (
		ECHO [---------------------------------------------------------------------------------]
		ECHO [     Transcoding %%i of %argCount%: !argVn[%%i]!
	"%ffpath%ffmpeg.exe" -v %vbl% -i "!argVec[%%i]!" -c:v libx264 -profile:v main -level 4.0 -preset veryslow -crf 14 -pix_fmt yuv420p -tune grain -force_key_frames 0:00:02 -c:a aac -b:a 128k -y "!argVn[%%i]!_420_veryhigh.mp4"
	)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
if %pse% GTR 0 PAUSE

rem the main settings are defined in file sendtoffmpeg_settings.cmd, read the description insite it
rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02