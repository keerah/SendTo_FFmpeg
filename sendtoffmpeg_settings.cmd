REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM v3.15

REM This is a SendTo_FFmpeg settings file
REM    You have to be careful here, cause it's an executable part of the scripts
REM    Scripts won't be able to run without this file nearby.

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
REM    otherwise you'll be getting prompts to overwrite each time

SET /A fps=30
REM Default framerate for image seuences
REM    It will aslo be used for the framerate of Gifs generated from sequences

SET /A imgseq=1 
REM Consider image sequences
REM    if 0 then ffmpeg won't look for image sequences even if the selected file is a part of one
REM    When this option is on, be cautios if the files you specified are part of a sequence(s),
REM    each of them can be encoded into a separate video then.

SET /A frcounter=4
REM Frame counter digits
REM    The number of digits of the frame counter to detect (leading zeroes assumed)
REM    SendTo_FFmpeg will look for this number of symbols at the end of the filename

SET "frdelim=."
REM Framecounter delimiter (separation symbol)
REM   After the code fails to find frame numbers in the end of the filename, it will try
REM   to find the first delimiter symbol and detect if there's frame number after it.
REM   Set this to SET "frdelim=" (empty string) if you do not want this detection to run.

SET "divline=-----------------------------------------------------------------------------------------------"
REM Divider string used for UI
