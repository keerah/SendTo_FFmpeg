@ECHO OFF
setlocal enabledelayedexpansion

ECHO [--------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.01 by Keerah.com                         ---]
ECHO [---  Concatenation (2 files) module has been invoked                   ---]
echo [ Both files must be in the same location, current is %~p1
echo [ File1: %~n1%~x1
echo [ File2: %~n2%~x2

cd %~p1
"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -i "concat:%~n1%~x1|%~n2%~x2" -c copy -y %~n1_concat_%~n1%~x2

ECHO [--------------------------------------------------------------------------]
ECHO [     SERVED                                                               ]
ECHO [--------------------------------------------------------------------------]
PAUSE

rem Experimental batch for 2 video files concatenation