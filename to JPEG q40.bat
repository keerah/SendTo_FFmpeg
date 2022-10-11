@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2022 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
   set "argVn[!argCount!]=%%~nx"
)

ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v2.3 by Keerah.com                                 ---]
ECHO [---  Multi JPEG module has been invoked                                       ---]
ECHO [---  Preset: JPEG quality 40%%                                                 ---]

set "cmdp=%~dp0"
set "argp=%~dp1"

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

IF %dscr% GTR 0 (SET "dscrName=_jpeg40") ELSE (SET "dscrName=") 

FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Converting %%i of %argCount%: !argVn[%%i]!

	"%ffpath%ffmpeg.exe" -v %vbl% -hide_banner -i "!argVec[%%i]!" -vf "scale=in_range=mpeg:out_range=full" -q:v 6 -y "!argVn[%%i]!%dscrName%_%%04d.jpg"
)

:End
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]

if %pse% GTR 0 PAUSE
