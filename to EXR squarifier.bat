@ECHO OFF
REM SendTo_FFmpeg is a set of windows batches for effortless transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg

setlocal enabledelayedexpansion

SET argCount=0
FOR %%f IN (%*) DO (
   SET /A argCount+=1
   SET "argFile[!argCount!].name=%%~f"
   SET "argFile[!argCount!].trname=%%~nf"
   SET "argFile[!argCount!].ext=%%~xf"
   SET "argFile[!argCount!].path=%%~dpf"
)

SET "wset.hline1=Preset: EXR linear half-float, zip16"
SET "wset.hline2=Scales to the next power of 2 to the maximum of width or height"

REM This one process only on per frame basis, no sequence detection, no video splitting as of yet

SET "cmdp=%~dp0"
SET "argp=%~dp1"

REM get settings
IF EXIST "%argp%sendtoffmpeg_settings.cmd" ( 
	CALL "%argp%sendtoffmpeg_settings.cmd"
	SET "wset.hline3=Settings: *LOCAL*, Verbosity: !vbl!"
) ELSE (
	IF EXIST "%cmdp%sendtoffmpeg_settings.cmd" (
		CALL "%cmdp%sendtoffmpeg_settings.cmd"
		SET "wset.hline3=Settings: Global, Verbosity: !vbl!"
	) ELSE (
		ECHO !    Sorry, the sendtoffmpeg_settings.cmd is unreacheable. Unable to continue!
		GOTO :End
	)
)

IF %argCount% LEQ 0 (
	ECHO %divline%
	ECHO      NO FILE^(S^) SPECIFIED
	GOTO :End
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
		ECHO !    Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!
		GOTO :End
	)	

REM Check for exiftool
IF NOT EXIST "%ffpath%exiftool.exe" ( 
		ECHO !    Sorry, the path to exifprobe.exe is unreacheable. Unable to continue!
		GOTO :End
	)	

ECHO %divline%
ECHO SendTo FFmpeg encoder v3.1 by Keerah
ECHO %wset.hline1%
IF NOT "[%wset.hline2%]"=="[]" ECHO %wset.hline2%
ECHO %wset.hline3%
ECHO %divline%
ECHO    %argCount% files queued to encode


REM compression settings
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-format 1 -compression 3 -gamma 1"
	REM available EXR compressions:      0 - none (default), 1 - rle, 2 - zip1, 3 - zip16
	REM availableEXR formats:            1 - half, 2 - float (default)
	REM available EXR gamma correction:  -gamma <float>, where float is between 0.001 and FLT_MAX, default = 1
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_exr_square") ELSE (SET "wset.dscr=")
SET "wset.seqfr="
	rem -pattern_type none
SET "wset.seqfrout=-update 1 -frames:v 1" 
SET "wset.suff=!wset.dscr!.exr"


FOR /L %%i IN (1,1,%argCount%) DO (

	ECHO %divline%

	REM fetch for the image dimensions using exiftool
	REM exiftool was chosen because of the its clean output, unlike the ffprobe's, less parsing is simpler and faster
	
	SET /A "pWidth=0"
	FOR /F "tokens=*" %%G IN ('""%ffpath%exiftool.exe" -b "!argFile[%%i].name!" -ImageWidth"') DO SET /A pWidth=%%G
	FOR /F "tokens=*" %%H IN ('""%ffpath%exiftool.exe" -b "!argFile[%%i].name!" -ImageHeight"') DO SET /A pHeight=%%H
	
	REM max of Height or Width
	SET /A "mSize=!pHeight!"
	IF !pWidth! GTR !pHeight! (SET /A "mSize=!pWidth!")

	REM choose the next nearest power of 2 factor
	SET /A "sFac=256"
	IF !mSize! GTR 256 (SET /A "sFac=512")
	IF !mSize! GTR 512 (SET /A "sFac=1024")
	IF !mSize! GTR 1024 (SET /A "sFac=2048")
	IF !mSize! GTR 2048 (SET /A "sFac=4096")
	IF !mSize! GTR 4096 (SET /A "sFac=8192")

	ECHO      Converting %%i of %argCount%: !argFile[%%i].trname!
	ECHO      Image dimensions: !pHeight! by !pWidth!	
	ECHO      Target scale: !sFac!x!sFac!
	"%ffpath%ffmpeg.exe" %wset.params% %wset.seqfr% -i "!argFile[%%i].name!" -vf "scale=!sFac!:!sFac!,setsar=1:1" %wset.videocomp% %wset.audiocomp% %wset.over% %wset.seqfrout% "!argFile[%%i].trname!"%wset.suff%
)

ECHO %divline%
ECHO      SERVED                                                                        
ECHO %divline%

:End
if %pse% GTR 0 PAUSE