REM SendTo_FFmpeg is a set of windows batches for effortless and free transcoding
REM Copyright (c) 2018-2019 Keerah, keerah.com. All rights reserved
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg

REM SendTo_FFmpeg settings file
REM You need to be careful here, cause it's an executable part of the script for each preset
REM Multiple files are not implemented for mux (external audio) scripts

rem Path to ffmpeg.exe
set "ffpath=c:\Program Files\ffmpeg\bin\"

rem FFmpeg verbosity level, use "info" for full verbosity
set "vbl=warning" 

rem Enable pause after encoding, any positive value enables the pause
set /A pse=1

rem  Descriptive naming for output files, any positive value enables description
set /A dscr=1
