REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM v3.5

REM This is a SendTo_FFmpeg settings file
REM    You have to be careful here, cause it's an executable part of the scripts
REM    Scripts won't be able to run without this file nearby

REM If you copy this file to the folder of your source files then these "localized" settings
REM    will be used for transcoding of the files inside this folder instead of the global settings.
REM    For example, you can disable the descriptive name suffixes, use another default framerate
REM    or even use another FFmpeg version for a particular folder only

REM Each line after SET must be eclosed in quotes and contain no spaces around =, like they initially are


REM === SendTo FFmpeg settings =====================================================================

SET "stf.path.ffmpeg=c:\Program Files\ffmpeg\bin\"
REM Path to ffmpeg.exe. Must end with the "\" symbol

SET "stf.con.verbose=warning"
REM FFmpeg verbosity level
REM    "info" for full verbosity, "warning" for all important messaes, "error" for errors only 

SET "stf.con.pause=1"
REM Enable pause after encoding
REM    Any positive value enables the pause

SET "stf.out.descriptive=1"
REM Descriptive naming for output files
REM    Any positive value enables filename suffixes 

SET "stf.out.quiet=1"
REM Quiet overwrite
REM    If it is set to 1, the output files will be always overwritten
REM    otherwise you'll be getting prompts to overwrite each time

SET "stf.in.sequence.fps=25"
REM Default framerate for image sequences in Hz. Can either be a number or a fraction (eg 25/1)
REM    It will aslo be used for the framerate of Gifs generated from sequences

SET "stf.out.sequence.folder=1"
REM Sequences to new subfolders
REM     if 1 the output sequences will be saved into a new subfolder

SET "stf.in.sequence.counter=4"
REM Frame counter digits
REM    The number of digits of the frame counter to detect (leading zeroes assumed)
REM    SendTo_FFmpeg will look for this number of symbols at the end of the filename
REM    Set to 0 to disable sequence detection

SET "stf.in.sequence.delim=."
REM Framecounter delimiter (separation symbol)
REM   After the code fails to find frame numbers in the end of the filename, it will try
REM   to find the first delimiter symbol and detect if there's frame number after it.
REM   Set this to SET "frdelim=" (empty string) if you do not want this detection to run.

SET "stf.cm.on=1"
REM Color managment toggle
REM   If set to 1 the color management is on

SET "stf.con.divline=[38;5;8m-----------------------------------------------------------------------------------------------[0m"
REM Divider string used for UI

REM === End of settings ============================================================================

:End
EXIT /B