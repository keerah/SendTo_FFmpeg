REM Send_To_FFmpeg settings file
REM You need to be careful here, cause it's an executable part of the script for each preset

REM Path to ffmpeg.exe
set "ffpath=c:\Program Files\ffmpeg\bin\"

REM FFmpeg verbosity level, use "info" for full verbosity
set "vbl=warning" 

REM Enable pause after encoding, any positive value enables the pause
set /A pse=1

REM  Descriptive naming for output files, any positive value enables description (not yet implemented)
set /A dscr=1

REM Send_To_FFmpeg is a set of windows batches for effortless and free transcoding
REM More information at https://keerah.com https://github.com/keerah/SendTo_FFmpeg