REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2022 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

REM This is a SendTo_FFmpeg settings file
REM You need to be careful here, cause it's an executable part of the script for each preset

REM If you copy of this file to the folder of your source files, then these localized settings
REM will be used for transcoding all files inside this folder instead of the global settings
REM For example, you can disable the pause after processing or reduce verbose level to errors only
REM for a particular folder only. 

rem Path to ffmpeg.exe
set "ffpath=c:\Program Files\ffmpeg\bin\"

rem FFmpeg verbosity level, use "info" for full verbosity or "error" for errors only 
set "vbl=warning" 

rem Enable pause after encoding, any positive value enables the pause
set /A pse=1

rem  Descriptive naming for output files, any positive value enables description
set /A dscr=1