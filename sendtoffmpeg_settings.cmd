REM SendTo_FFmpeg is a set of windows batches for effortless transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg

REM This is a SendTo_FFmpeg settings file
rem    You have to be careful here, cause it's an executable part of the scripts
rem    Scripts won't be able to run without this file nearby.

REM If you copy this file to the folder of your source files
REM    then these "localized" settings will be used for transcoding
REM    of the files inside this folder instead of the global settings.
REM    For example, you can disable the descriptive name suffixes,
REM    use another default framerate or even use another FFmpeg version
REM    for a particular folder only

SET "ffpath=c:\Program Files\ffmpeg\bin\"
REM Path to ffmpeg.exe
REM    will also look for exiftool.exe here when needed

SET "vbl=warning" 
REM FFmpeg verbosity level
REM    "info" for full verbosity, "warning" for all important messaes, "error" for errors only 

SET /A pse=1
REM Enable pause after encoding
REM    Any positive value enables the pause

SET /A dscr=1
REM Descriptive naming for output files
REM    Any positive value enables filename suffixes 

SET /A quietover=1
REM Quiet overwrite
REM    If it is set to 1, the output files will be always overwritten

SET /A fps=30
REM Default framerate for image seuences

SET /A imgseq=1 
REM Consider image sequences
REM    if 0 then ffmpeg won't look for image sequences containing the selected file

SET /A frcounter=4
REM Frame counter digits
REM    The number of digits in the frame counter to detect (leading zeroes assumed)
REM    If set to 0, the scripts will search for the counter after the first dot in the filename
REM    taking all digits available (future feature)