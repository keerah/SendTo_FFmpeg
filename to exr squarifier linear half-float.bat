@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM exr compatible special case preset
REM This one process only on per frame basis, no sequence detection, no video splitting as of yet
REM Saves results into a subfolder named Suaqrified-#####

COLOR 0F
SETLOCAL ENABLEDELAYEDEXPANSION 

REM === compression settings =======================================================================
SET "wset.out.format=.exr"
SET "wset.out.video.codec=exr"
SET "wset.out.video.codec.depth=half"
	REM availableEXR formats: float, half 
SET "wset.out.video.codec.compression=zip16"
	REM available EXR compressions: none, rle, zip1, zip16
SET "wset.out.video.codec.gamma=1"
	REM gamma value between, min 0.001 

REM === consolidated transcoding settings =============================================================
SET "wset.con.line[0]=Square EXR, gamma [01m%wset.out.video.codec.gamma%[0m, depth [01m%wset.out.video.codec.depth%[0m, compression [01m%wset.out.video.codec.compression%[0m"
SET "wset.con.line[2]=Scales to the next power of 2 of the maximum of width/height. No sequence support."
SET "wset.out.video.comp=-format %wset.out.video.codec.depth% -compression %wset.out.video.codec.compression% -gamma %wset.out.video.codec.gamma%"

SET "wset.con.line[1]=Audio is not supported for this format"
SET "wset.con.line[11]=None"
SET "wset.out.audio.comp="

SET "wset.out.descriptive=_exr_square"
SET "wset.out.params=-hide_banner -stats"
SET "wset.out.sequence=0"
REM ================================================================================================

TITLE SendTo FFmpeg: initializing
SET /A stf.result=0
SET "wset.path.cmd=%~dp0"
SET "wset.path.arg=%~dp1"

SET wset.argCount=0
FOR %%f IN (%*) DO (
   SET /A wset.argCount+=1
   SET "wset.files[!wset.argCount!].name=%%~f"
   SET "wset.files[!wset.argCount!].trname=%%~nf"
   SET "wset.files[!wset.argCount!].ext=%%~xf"
   SET "wset.files[!wset.argCount!].path=%%~dpf"
)

REM Get settings
IF EXIST "%wset.path.arg%sendtoffmpeg_settings.cmd" ( 
	CALL "%wset.path.arg%sendtoffmpeg_settings.cmd"
	SET "wset.con.line[3]=SendTo settings  : [30m[44m Local [0m"
	SET "wset.con.line[4]=Verbosity level  : !stf.con.verbose!"
) ELSE (
	IF EXIST "%wset.path.cmd%sendtoffmpeg_settings.cmd" (
		CALL "%wset.path.cmd%sendtoffmpeg_settings.cmd"
		SET "wset.con.line[3]=SendTo settings  : [30m[47m Global [0m"
		SET "wset.con.line[4]=Verbosity level  : !stf.con.verbose!"
	) ELSE (
		SET /A stf.result=1
		ECHO %stf.con.divline%
		ECHO [31mSorry, the [30m[41msendtoffmpeg_settings.cmd[0m[31m is unreacheable. Unable to continue^^![0m	
		ECHO This file was expected at path [03m"%wset.path.cmd%"[0m.
		ECHO %stf.con.divline%
		GOTO :End
	)
)

IF %stf.out.quiet% == 1 (SET "wset.out.quiet=-y") ELSE (SET "wset.out.quiet=")
SET "wset.out.params=-v %stf.con.verbose% %wset.out.params%"
SET "wset.out.suff=!wset.out.descriptive!!wset.out.format!"
SET "wset.in.sequence.range="
	rem -pattern_type none
SET "wset.out.sequence.range=-update 1 -frames:v 1" 


REM Check for ffmpeg
IF NOT EXIST "%stf.path.ffmpeg%ffmpeg.exe" ( 
	SET /A stf.result=3
	ECHO %stf.con.divline%
	ECHO [31mSorry, the [30m[30m[41mffmpeg.exe[0m[31m is unreacheable. Unable to continue^^![0m
	ECHO Your ffmpeg path is [03m"%stf.path.ffmpeg%ffmpeg.exe"[0m.
	ECHO Check it and change the current settings accordingly.
	ECHO Your current settings are %wset.con.line[2]:~12%
	ECHO %stf.con.divline%
	GOTO :End
)	

IF %wset.argCount% LEQ 0 (
	ECHO %stf.con.divline%
	ECHO [30m[41mNo file^(s^) specified^^![0m
	ECHO %stf.con.divline%
	GOTO :End
)

ECHO [03m[33mSendTo FFmpeg encoder v3.5x by Keerah[0m
ECHO !stf.con.divline!
ECHO Video preset     : !wset.con.line[0]!
ECHO       codec      : !wset.con.line[10]!
ECHO Audio preset     : !wset.con.line[1]!
ECHO       codec      : !wset.con.line[11]!
IF DEFINED wset.con.line[2] ECHO Preset notes     : !wset.con.line[2]!
ECHO %wset.con.line[3]%
ECHO %wset.con.line[4]%
ECHO %stf.con.divline%
ECHO    [01m%wset.argCount%[0m files queued to encode


SET "savepath=!wset.path.arg!"
SET "subfolder=!wset.path.arg!squarified-%RANDOM%"
MKDIR "%subfolder%"
IF EXIST "%subfolder%" (
	SET "savepath=%subfolder%\"
	ECHO      Transcoding to subfolder: [03m"%subfolder%"[0m.
) ELSE (
	ECHO [31m     Unable to create subfolder:[0m [03m"%subfolder%"[0m. Saving to the source location. 
)

FOR /L %%i IN (1,1,!wset.argCount!) DO (

	REM Fetch meta
	FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffprobe.exe" -v error -hide_banner -show_streams -select_streams "v:0" !wset.in.sequence.range! -sexagesimal "!wset.files[%%i].name!"') DO (
		SET "tmpline=%%f"
		IF NOT "x!tmpline:coded_width=!"=="x!tmpline!" (SET "wset.in.meta.width=!tmpline:coded_width=!" && SET "wset.in.meta.width=!wset.in.meta.width:~1!")
		IF NOT "x!tmpline:coded_height=!"=="x!tmpline!" (SET "wset.in.meta.height=!tmpline:coded_height=!" && SET "wset.in.meta.height=!wset.in.meta.height:~1!")
		IF NOT "x!tmpline:codec_name=!"=="x!tmpline!" (SET "wset.in.meta.codec=!tmpline:codec_name=!" && SET "wset.in.meta.codec=!wset.in.meta.codec:~1!")
		IF NOT "x!tmpline:pix_fmt=!"=="x!tmpline!" (SET "wset.in.meta.sampling=!tmpline:pix_fmt=!" && SET "wset.in.meta.sampling=!wset.in.meta.sampling:~1!")
		IF NOT "x!tmpline:color_space=!"=="x!tmpline!" (SET "wset.in.meta.cm.space=!tmpline:color_space=!" && SET "wset.in.meta.cm.space=!wset.in.meta.cm.space:~1!")
		IF NOT "x!tmpline:color_primaries=!"=="x!tmpline!" (SET "wset.in.meta.cm.primaries=!tmpline:color_primaries=!" && SET "wset.in.meta.cm.primaries=!wset.in.meta.cm.primaries:~1!")
		IF NOT "x!tmpline:color_transfer=!"=="x!tmpline!" (SET "wset.in.meta.cm.transfer=!tmpline:color_transfer=!" && SET "wset.in.meta.cm.transfer=!wset.in.meta.cm.transfer:~1!")
		IF NOT "x!tmpline:color_range=!"=="x!tmpline!" (SET "wset.in.meta.cm.range=!tmpline:color_range=!" && SET "wset.in.meta.cm.range=!wset.in.meta.cm.range:~1!")
	)

	SET /A pWidth=!wset.in.meta.width!
	SET /A pHeight=!wset.in.meta.height!

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

	ECHO !stf.con.divline!
	TITLE SendTo FFmpeg: %%i of !wset.argCount!
	ECHO [01m[34m     Transcoding file %%i of !wset.argCount!:[0m [03m"!wset.files[%%i].trname!"[0m
	ECHO      Source dimensions: [01m!wset.in.meta.width![0m x [01m!wset.in.meta.height![0m
	ECHO                  codec: [01m!wset.in.meta.codec![0m, chroma: [01m!wset.in.meta.sampling![0m
	ECHO                  color: [01m!wset.in.meta.cm.space![0m r:!wset.in.meta.cm.range! p:!wset.in.meta.cm.primaries! t:!wset.in.meta.cm.transfer!
	REM ECHO      Image dimensions: !pHeight! x !pWidth!	
	ECHO           Target scale: [01m!sFac![0m x [01m!sFac![0m
	

	
	ECHO.
	"!stf.path.ffmpeg!ffmpeg.exe" !wset.out.params! !wset.in.sequence.range! -i "!wset.files[%%i].name!" -vf "scale=!sFac!:!sFac!,setsar=1:1" !wset.out.video.comp! !wset.out.audio.comp! !wset.out.sequence.range! !wset.out.quiet! "%savepath%!wset.files[%%i].trname!!wset.out.suff!"
	ECHO.
	ECHO [01m[34m     Saved as:[0m [03m"!savepath!!wset.files[%%i].trname!!wset.out.suff!"[0m

)

ECHO %stf.con.divline%
ECHO [01m[34mSERVED[0m                                                                             
ECHO %stf.con.divline%

:End
IF %stf.result% GTR 0 ECHO [31mResult code is %stf.result%[0m
ECHO.
TITLE SendTo FFmpeg: done
if %stf.con.pause% GTR 0 PAUSE