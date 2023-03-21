REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM This is one of the SenTo_FFmpeg's modules, keep it with the rest of the files

COLOR 0F
TITLE SendTo FFmpeg: initializing
ECHO [03m[33mSendTo_FFmpeg encoder REM v3.35b by Keerah[0m

REM Get arguments
SET "wset.path.cmd=%~dp0"
SET "wset.path.arg=%~dp1"
SET /A stf.result=0

SET /A wset.argCount=0
FOR %%f IN (%*) DO (
   SET /A wset.argCount+=1
   SET "wset.files[!wset.argCount!].name=%%~f"
   SET "wset.files[!wset.argCount!].trname=%%~nf"
   SET "wset.files[!wset.argCount!].ext=%%~xf"
   SET "wset.files[!wset.argCount!].path=%%~dpf"
)

REM Get settings
IF EXIST "!wset.path.arg!sendtoffmpeg_settings.cmd" ( 
	CALL "!wset.path.arg!sendtoffmpeg_settings.cmd"
	SET "wset.con.line.set=SendTo settings  : [30m[44m Local [0m"
	SET "wset.con.line.verb=Verbosity level  : !stf.con.verbose!"
) ELSE (
	IF EXIST "!wset.path.cmd!sendtoffmpeg_settings.cmd" (
		CALL "!wset.path.cmd!sendtoffmpeg_settings.cmd"
		SET "wset.con.line.set=SendTo settings  : [30m[47m Global [0m"
		SET "wset.con.line.verb=Verbosity level  : !stf.con.verbose!"
	) ELSE (
		SET /A stf.result=1
		ECHO [38;5;8m-----------------------------------------------------------------------------------------------[0m
		ECHO [31mSorry, the [30m[41msendtoffmpeg_settings.cmd[0m[31m is unreacheable. Unable to continue^^![0m	
		ECHO This file was expected at path [03m"!wset.path.cmd!"[0m.
		ECHO [38;5;8m-----------------------------------------------------------------------------------------------[0m
		GOTO :End
	)
)

REM Check for FFmpeg
IF NOT EXIST "%stf.path.ffmpeg%ffmpeg.exe" ( 
	SET /A stf.result=3
	ECHO !stf.con.divline!
	ECHO [31mSorry, the [30m[41mffmpeg.exe[0m[31m is unreacheable. Unable to continue^^![0m
	ECHO Your ffmpeg path is [03m"!stf.path.ffmpeg!ffmpeg.exe"[0m.
	ECHO Check it and change the current settings accordingly.
	ECHO Your current settings are !wset.con.line.set:~12!
	ECHO !stf.con.divline!
	GOTO :End
)

REM Check arguments
IF !wset.argCount! LSS 1 (
	SET /A stf.result=2
	ECHO !stf.con.divline!
	ECHO [30m[41mNo file^(s^) specified^^![0m
	ECHO !stf.con.divline!
	GOTO :End
)

REM If init errors
IF !stf.result! GTR 0 (
	 GOTO :End
	 SET "stf.con.pause=1"
)

REM Consolidating preset settings

REM Scale
IF DEFINED wset.out.video.scale.x IF DEFINED wset.out.video.scale.y (
	SET "wset.out.video.scale.vf=,scale=!wset.out.video.scale.x!:!wset.out.video.scale.y!:flags=!wset.out.video.scale.algo!"
	SET "wset.con.video.scale=scale [01m!wset.out.video.scale.x![0m:[01m!wset.out.video.scale.y! !wset.out.video.scale.algo![0m"
	SET "wset.dscr.video.scale=_!wset.out.video.scale.x!x!wset.out.video.scale.y!"
)

REM Framerate
IF DEFINED wset.out.video.fps (
	SET /A wset.out.video.fps=!wset.out.video.fps!
	IF NOT !wset.out.video.fps! == 0 (
		SET "wset.con.video.fps=[01m!wset.out.video.fps![0m fps"
		SET "wset.dscr.video.fps=_!wset.out.video.fps!fps"
	)
	IF !wset.out.video.fps! LSS 0 (
		SET /A wset.out.video.fps=-!wset.out.video.fps! 
		SET "wset.out.video.fps.sync=sync" 
		SET "wset.con.video.fps=[01msync !wset.out.video.fps![0m fps" 
		SET "wset.dscr.video.fps=_sync!wset.out.video.fps!fps")
)

REM Constructing video transform line
IF DEFINED wset.con.video.fps IF DEFINED wset.con.video.scale SET "wset.con.video.scale=, !wset.con.video.scale!"
SET "wset.con.line.vt=!wset.con.video.fps!!wset.con.video.scale!"


REM Defaulting no audio
SET "wset.con.line.a=Audio is not supported for this format"
SET "wset.con.line.ac=None"
SET "wset.out.audio.comp="
SET "wset.dscr.audio.comp="

REM === apng
IF "!wset.out.type!"=="01" (
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! -plays !wset.out.loop! -final_delay !wset.out.loop.finaldelay!"
	SET "wset.con.line.v=!wset.out.video.codec!, loop forever"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === gif
IF "!wset.out.type!"=="02" (

	SET "wset.con.line.v=Gif [01m!wset.out.video.colors![0m, colors [01m!wset.out.video.dither![0m, [01m!wset.out.video.palette![0m palette 2 pass"
	SET "wset.out.video.prepass=-vf "fps=!wset.out.video.fps!!wset.out.video.scale.vf!,palettegen=max_colors=!wset.out.video.colors!:stats_mode=!wset.out.video.palette!""
	SET "wset.out.video.comp=-c:v !wset.out.video.codec! -filter_complex "fps=!wset.out.video.fps!!wset.out.video.scale.vf![x];[x][1:v]paletteuse=dither=!wset.out.video.dither!""

	SET "wset.out.descriptive=_!wset.out.video.codec!!wset.out.video.colors!!wset.dscr.video.scale!!wset.dscr.video.fps!"
	GOTO :Process
)

REM === jpeg
IF "!wset.out.type!"=="03" (
	SET "wset.out.video.vf.comp=-vf "scale=in_range=mpeg:out_range=full!wset.out.video.scale.vf!""

	SET "wset.con.line.v=jpeg, chroma [01m!wset.out.video.sampling![0m, rate [01m!wset.out.video.rate![0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_jpeg_!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! "-q:v" !wset.out.video.rate! !wset.out.video.fps.comp! -pix_fmt !wset.out.video.sampling!"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === libxh264
IF "!wset.out.type!"=="04" (
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line.v=h264 mp4 libx, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate![0m, tune [01m!wset.out.video.tune![0m, key int [01m!wset.out.video.keyframes! fr[0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_crf!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! !wset.out.video.profile! -preset !wset.out.video.preset! -crf !wset.out.video.rate! -rc-lookahead 10 -pix_fmt !wset.out.video.sampling! !wset.out.video.scale.comp! -tune !wset.out.video.tune! -x264-params opencl=true -g !wset.out.video.keyframes!"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line.v=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line.v=Copy video stream" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line.a=[01m!wset.out.audio.codec![0m rate [01m!wset.out.audio.rate![0m"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line.a=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line.a=Copy audio stream" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === libxh265
IF "!wset.out.type!"=="08" (
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line.v=h265 mp4 libx, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate![0m, tune [01m!wset.out.video.tune![0m, key int [01m!wset.out.video.keyframes! fr[0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_crf!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! !wset.out.video.profile! -preset !wset.out.video.preset! -crf !wset.out.video.rate! -pix_fmt !wset.out.video.sampling! !wset.out.video.scale.comp! -tune !wset.out.video.tune! -x265-params log-level=warning -g !wset.out.video.keyframes!"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line.v=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line.v=Copy video stream" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line.a=[01m!wset.out.audio.codec![0m rate [01m!wset.out.audio.rate![0m"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line.a=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line.a=Copy audio stream" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === nvenc
IF "!wset.out.type!"=="05" (

	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line.v=h264 mp4 CUDA, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate![0m, tune [01m!wset.out.video.tune![0m, key int [01m!wset.out.video.keyframes! fr[0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! -b:v !wset.out.video.rate! -rc !wset.out.video.rate.control! -pix_fmt !wset.out.video.sampling! -preset !wset.out.video.preset! -tune !wset.out.video.tune! -multipass 2 -rc-lookahead 10 -g !wset.out.video.keyframes!"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line.v=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line.v=Copy video stream" && SET "wset.con.line.vc=Same as source" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line.a=[01m!wset.out.audio.codec![0m rate [01m!wset.out.audio.rate![0m"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line.a=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line.a=Copy audio stream" && SET "wset.con.line.ac=Same as source" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === png
IF "!wset.out.type!"=="06" (
	SET "wset.out.video.vf.comp=-vf "scale=in_range=full:out_range=full!wset.out.video.scale.vf!""

	SET "wset.con.line.v=PNG, chroma [01m!wset.out.video.sampling![0m, compression [01m!wset.out.video.compress![0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_png_c!wset.out.video.compress!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! -compression_level !wset.out.video.compress! -pix_fmt !wset.out.video.sampling!"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM === libxvp9
IF "!wset.out.type!"=="07" (
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line.v=WebM VP9, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate![0m, tune [01m!wset.out.video.tune![0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_crf!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! -crf !wset.out.video.rate! -pix_fmt !wset.out.video.sampling! -quality !wset.out.video.preset! -tune-content !wset.out.video.tune! -rc_lookahead 25"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line.v=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line.v=Copy video stream" && SET "wset.con.line.vc=Same as source" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line.a=!wset.out.audio.codec! !wset.out.audio.rate!"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line.a=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line.a=Copy audio stream" && SET "wset.con.line.ac=Same as source" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

REM End of consolidating preset settings

:Process

REM STF settings to current set
IF "!stf.out.quiet!" == "1" (SET "wset.out.quiet=-y") ELSE (SET "wset.out.quiet=")
IF NOT "!stf.out.descriptive!" == "1" SET "wset.out.descriptive="
SET "wset.out.params=-v !stf.con.verbose! !wset.out.params!"
SET "wset.in.meta="
SET "wset.out.meta="

REM Consolidating color management preset settings
IF "!stf.cm.on!"=="1" (
	SET "wset.con.line.cm=Color management : Input "
	
	IF NOT DEFINED wset.in.cm.space (
		SET "wset.con.line.cm=!wset.con.line.cm![01mfrom source[0m"
	) ELSE (
		SET "wset.in.meta=-color_primaries !wset.in.cm.primaries! -color_range !wset.in.cm.range! -color_trc !wset.in.cm.transfer! -colorspace !wset.in.cm.space!"
		SET "wset.con.line.cm=!wset.con.line.cm![01m!wset.in.cm.space![0m r:!wset.in.cm.range! p:!wset.in.cm.primaries! t:!wset.in.cm.transfer!"
	)
	
	SET "wset.con.line.cm=!wset.con.line.cm! ^| Convert to "

	IF NOT DEFINED wset.out.cm.space (
		SET "wset.con.line.cm=!wset.con.line.cm![01moff[0m"
	) ELSE (
		SET "wset.out.meta=-color_primaries !wset.out.cm.primaries! -color_range !wset.out.cm.range! -color_trc !wset.out.cm.transfer! -colorspace !wset.out.cm.space!"
		SET "wset.con.line.cm=!wset.con.line.cm![01m!wset.out.cm.space![0m r:!wset.out.cm.range! p:!wset.out.cm.primaries! t:!wset.out.cm.transfer!"
	)
) ELSE (
	
	SET "wset.con.line.cm=Color management: OFF"
)

REM Checking video codec support
IF DEFINED wset.out.video.codec IF DEFINED wset.out.video.comp IF NOT "!wset.out.video.rate!"=="copy" (
	SET first=1
	FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffmpeg.exe" -hide_banner -h "encoder=!wset.out.video.codec!"') DO (
		IF !first!==1 SET "wset.con.line.vc=%%f"
		SET first=0
	) 
	IF NOT "x!wset.con.line.vc:is not recognized=!"=="x!wset.con.line.vc!" (
		SET /A stf.result=10
		ECHO !stf.con.divline!
		ECHO [31mSorry, the FFmpeg you're using does not recognize the requested video encoder [30m[41m !wset.out.video.codec! [0m[31m.[0m
		ECHO Check the [30m[41m wset.out.video.codec [0m preset settings or try using another version of FFmpeg.
		ECHO !stf.con.divline!
		GOTO :End
	)
	IF NOT "x!wset.con.line.vc:need to be recompiled=!"=="x!wset.con.line.vc!" (
		SET /A stf.result=11
		ECHO !stf.con.divline!
		ECHO [31mSorry, the video encoder [30m[41m !wset.out.video.codec! [0m [31mis unavailable in the version of FFmpeg you're using.[0m
		ECHO Although this codec is known to FFmpeg. You most likely need to get another build/version of it.
		ECHO You can utilize various instances of FFmpeg binaries using SendTo's [30m[44m Local [0m settings.
		ECHO !stf.con.divline!
		GOTO :End
	)
	SET "wset.con.line.vc=!wset.con.line.vc:Encoder =!"
	SET "wset.con.line.vc=!wset.con.line.vc:~0,-1!"
)	

REM Checking audio codec support
IF DEFINED wset.out.audio.comp IF NOT "!wset.out.audio.rate!"=="copy" (
	SET first=1
	FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffmpeg.exe" -hide_banner -h "encoder=!wset.out.audio.codec!"') DO (
		IF !first!==1 SET "wset.con.line.ac=%%f"
		SET first=0
	)
	IF NOT "x!wset.con.line.ac:is not recognized=!"=="x!wset.con.line.ac!" (
		SET /A stf.result=10
		ECHO !stf.con.divline!
		ECHO [31mSorry, the FFmpeg you're using does not recognize the requested audio encoder [30m[41m !wset.out.audio.codec! [0m[31m.[0m
		ECHO Check the [30m[41m wset.out.audio.codec [0m preset settings or try using another version of FFmpeg.
		ECHO !stf.con.divline!
		GOTO :End
	)
	IF NOT "x!wset.con.line.ac:need to be recompiled=!"=="x!wset.con.line.ac!" (
		SET /A stf.result=11
		ECHO !stf.con.divline!
		ECHO [31mSorry, the audio encoder [30m[41m !wset.out.audio.codec! [0m [31is unavailable in the version of FFmpeg you're using.[0m
		ECHO Although this codec is known to FFmpeg. You most likely need to get another build/version of it.
		ECHO You can utilize various instances of FFmpeg binaries using SendTo's [30m[44m Local [0m settings.
		ECHO !stf.con.divline!
		GOTO :End
	)
	SET "wset.con.line.ac=!wset.con.line.ac:Encoder =!"
	SET "wset.con.line.ac=!wset.con.line.ac:~0,-1!"
)

REM UI header
ECHO !stf.con.divline!
ECHO Video preset     : !wset.con.line.v!
ECHO       codec      : !wset.con.line.vc!
IF DEFINED wset.con.line.vt ECHO       transform  : !wset.con.line.vt!
ECHO Audio preset     : !wset.con.line.a!
ECHO       codec      : !wset.con.line.ac!
IF DEFINED wset.con.line.at ECHO       transform  : !wset.con.line.at!
IF DEFINED wset.con.line.info ECHO Preset notes     : !wset.con.line.info!
ECHO !wset.con.line.set!
ECHO !wset.con.line.verb!
ECHO !wset.con.line.cm!
ECHO !stf.con.divline!
ECHO [01m   !wset.argCount![0m files queued to encode

REM Encode
IF DEFINED stf.in.sequence.counter (SET /A stf.in.sequence.counter=!stf.in.sequence.counter!) ELSE (SET /A stf.in.sequence.counter=0)
IF DEFINED stf.in.sequence.fps (SET /A stf.in.sequence.fps=!stf.in.sequence.fps!) ELSE (SET /A stf.in.sequence.fps=25)

FOR /L %%i IN (1,1,!wset.argCount!) DO (
	
	ECHO !stf.con.divline!

	IF EXIST "!wset.files[%%i].name!" (

		TITLE SendTo FFmpeg: %%i of !wset.argCount!
		ECHO [01m[34m     Transcoding file %%i of !wset.argCount!:[0m [03m"!wset.files[%%i].trname!!wset.files[%%i].ext!"[0m
		SET "wset.files[%%i].trnameout=!wset.files[%%i].trname!"
		SET "wset.out.suff=!wset.out.descriptive!!wset.out.format!"

		REM Determine if video or still
		SET "formatname="
		SET "isimage="
		FOR /F "tokens=* delims=" %%f IN ('call "!stf.path.ffmpeg!ffprobe.exe" -v error -hide_banner -show_entries "format=format_name" -of "default=noprint_wrappers=1:nokey=1" -sexagesimal "!wset.files[%%i].name!"') DO SET "formatname=%%f"
		IF "x!formatname!"=="ximage2" SET "isimage=1"
		IF NOT "x!formatname:pipe=!"=="x!formatname!" SET "isimage=1"

		IF DEFINED isimage (
			ECHO      The source is a single image file
			SET "wset.out.audio.comp="

			IF !stf.in.sequence.counter! GTR 0 (
				REM Detecting the counter
				SET "basename=!wset.files[%%i].trname:~0,-%stf.in.sequence.counter%!"
				SET "countername=!wset.files[%%i].trname:~-%stf.in.sequence.counter%!"
				
				SET "middelim="
				SET /A frnumber=-1
				
				REM Constructing zero pattern
				SET "zer="
				FOR /L %%I IN (1,1,!stf.in.sequence.counter!) DO SET "zer=!zer!0"
				
				IF !countername!==!zer! (
					REM Zero frame
					SET /A frnumber=0
					ECHO      Frame counter detected at the end of the filename, digits: [01m!stf.in.sequence.counter![0m.
				) ELSE (
					REM Validating frame number at the end
					SET "ddet="
					FOR /F "delims=0123456789" %%I IN ("!countername!") DO SET ddet=%%i
					IF DEFINED ddet (
						REM Not a number
						ECHO      The last [01m!stf.in.sequence.counter![0m symbols of the filename is not a number.
						IF DEFINED stf.in.sequence.delim (
							REM Try to use delimiter
							FOR /f "tokens=1-3 delims=%stf.in.sequence.delim%" %%A in ("!wset.files[%%i].trname!") do (
								SET "beforedelim=%%A"
								SET "middelim=%%B"
								SET "afterdelim=%%C"
							)
							REM Limiting the counter. Lazy way, will consider string length calculation in future to get all digits
							SET "middelimtr=!middelim:~0,%stf.in.sequence.counter%!"

							REM Validating frame number after delimiter
							SET "ddet="
							FOR /F "delims=0123456789" %%I IN ("!middelimtr!") DO SET ddet=%%i
							IF DEFINED ddet (
								ECHO      No frame counter found after delimiter "[01m!stf.in.sequence.delim![0m". No image sequence assumed.
							) ELSE (
								ECHO      Frame counter detected after delimiter "[01m!stf.in.sequence.delim![0m", digits: [01m!stf.in.sequence.counter![0m.
								REM Removing leading zeroes (if any)
								FOR /F "tokens=* delims=0" %%N IN ("!middelimtr!") DO SET "frnumbername=%%N"
								SET /A "frnumber=!frnumbername!"
							)
						)  ELSE (
							ECHO      Delimiter symbol is set to empty, no sequence detection.
							SET /A frnumber=-1
							SET "wset.in.sequence.range="
							SET "wset.out.sequence.range=-update 1 -frames:v 1"
						)
					) ELSE (
						ECHO      Frame counter detected at the end of the filename, digits: [01m!stf.in.sequence.counter![0m.
						REM Removing leading zeroes (if any)
						FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET "frnumbername=%%N"
						SET /A "frnumber=!frnumbername!"
					)
				)

				REM Constructing input sequence
				IF !frnumber! GTR -1 (
					IF NOT DEFINED middelim (
						REM Constructing the pattern in the end of the name
						SET "wset.files[%%i].pat=!basename!%%0!stf.in.sequence.counter!d"
					) ELSE (
						REM Constructing the pattern after the delimiter
						REM If middelim was trimmed to stf.in.sequence.counter = add the trimmed part to filename
						IF !middelim! == !middelimtr! (SET "midsfx=") ELSE (SET midsfx=!middelim:~%stf.in.sequence.counter%!)
						SET "wset.files[%%i].pat=!beforedelim!!stf.in.sequence.delim!%%0!stf.in.sequence.counter!d!midsfx!!stf.in.sequence.delim!!afterdelim!"
						SET "basename=!beforedelim!"
					)
					IF "!wset.out.sequence!"=="1" SET "wset.files[%%i].trnameout=!wset.files[%%i].pat!"
					ECHO      Basename: [03m"!basename!"[0m, start frame: [01m!frnumber![0m, pattern: [03m"!wset.files[%%i].pat!!wset.files[%%i].ext!"[0m
					REM Replace counter with the pattern
					SET "wset.files[%%i].name=!wset.files[%%i].path!!wset.files[%%i].pat!!wset.files[%%i].ext!"
					IF "!wset.out.video.fps.sync!"=="sync" (
						REM Preset requests framerate override with sync
						SET "wset.in.sequence.range=-pattern_type sequence -framerate !wset.out.video.fps! -start_number !frnumber!"
						ECHO      Framerate sync is on, input and output are synced to [01m!wset.out.video.fps![0m fps. All frames will be preserved.
					) ELSE (
						REM Default framerate for input
						SET "wset.in.sequence.range=-pattern_type sequence -framerate !stf.in.sequence.fps! -start_number !frnumber!"
					)
					IF DEFINED wset.out.video.fps (
						REM Sync start frame number to output and requested framerate
						SET "wset.out.sequence.range=-framerate !wset.out.video.fps! -start_number !frnumber!"
						SET "wset.out.fps.comp=-r !wset.out.video.fps!"
					) ELSE (
						REM Sync start frame number to output and default framerate for output as well
						SET "wset.out.sequence.range=-framerate !stf.in.sequence.fps! -start_number !frnumber!"
					)
				)
			) ELSE (
				ECHO      Frame counter is zet to 0, sequence detection is off.
				SET "wset.in.sequence.range="
				SET "wset.out.sequence.range=-update 1 -frames:v 1"
			)
		) ELSE (
			ECHO      The source is the first video stream
			SET "wset.in.sequence.range="
			SET "wset.out.sequence.range="
			REM Out pattern for video-to-sequence
			IF "!wset.out.sequence!" == "1" SET "wset.files[%%i].trnameout=!wset.files[%%i].trnameout!_%%0!stf.in.sequence.counter!d"
			IF DEFINED wset.out.video.fps (
				REM Preset requests framerate conversion
				IF "!wset.out.sequence!" == "1" SET "wset.out.sequence.range=-framerate !wset.out.video.fps!"
				SET "wset.out.fps.comp=-r !wset.out.video.fps!"
			)
			IF "!wset.out.video.fps.sync!"=="sync" (
				REM Preset requests framerate override with sync
				SET "wset.in.fps.comp=-r !wset.out.video.fps!"
				ECHO      Framerate sync is on, input and output are synced to [01m!wset.out.video.fps![0m fps. All frames will be preserved.
			)
		)

		REM Mux external audio
		IF DEFINED wset.in.audio.file.extension IF NOT "!wset.out.sequence!" == "1" (
			SET "wset.in.audio.file.name=!wset.files[%%i].trname!!wset.in.audio.file.extension!"
			IF EXIST !wset.path.arg!!wset.in.audio.file.name! (
				ECHO      The audio file [03m"!wset.in.audio.file.name!"[0m [34mwas found and will be muxed[0m.
				SET "wset.in.audio.file.comp=-i "!wset.path.arg!!wset.in.audio.file.name!""
				SET "wset.out.audio.comp=!wset.out.audio.comp! -map 0:v -map 1:a -shortest"
			) ELSE (
				ECHO      The audio file: [03m"!wset.in.audio.file.name!"[0m [31mwas not found and won't be muxed[0m.
				SET "wset.in.audio.file.comp="
			)
		) ELSE (
			SET "wset.in.audio.file.comp="
		)

		REM Saving location
		SET "savepath=!wset.path.arg!"
		IF "!wset.out.sequence!" == "1" (
			IF "!stf.out.sequence.folder!" == "1" (
				REM Descriptive goes to the subfolder name and removed from name
				SET subfolder=!wset.path.arg!!wset.files[%%i].trname!!wset.out.suff!
				SET "wset.out.suff=!wset.out.format!"
				IF NOT EXIST "!subfolder!" MKDIR "!subfolder!" > NUL
				IF EXIST "!subfolder!" (
					SET "savepath=!subfolder!\"
				) ELSE (
					ECHO [31m     Unable to create subfolder:[0m [03m"!subfolder!"[0m. Saving to the source location. 
				)
			)
		)

		REM Fetch meta, ffprobe passes through the sequence fps that was set earlier and calculates the duration
		FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffprobe.exe" -v error -hide_banner -show_entries "stream=width,height,duration,codec_name,pix_fmt,color_space,color_primaries,color_transfer,color_range,avg_frame_rate" -of "default=noprint_wrappers=1" -select_streams "v:0" -sexagesimal !wset.in.sequence.range! "!wset.files[%%i].name!"') DO (
			SET "tmpline=%%f"
			IF NOT "x!tmpline:codec_name=!"=="x!tmpline!" (SET "wset.in.meta.codec=!tmpline:codec_name=!" && SET "wset.in.meta.codec=!wset.in.meta.codec:~1!")
			IF NOT "x!tmpline:width=!"=="x!tmpline!" (SET "wset.in.meta.width=!tmpline:width=!" && SET "wset.in.meta.width=!wset.in.meta.width:~1!")
			IF NOT "x!tmpline:height=!"=="x!tmpline!" (SET "wset.in.meta.height=!tmpline:height=!" && SET "wset.in.meta.height=!wset.in.meta.height:~1!")
			IF NOT "x!tmpline:pix_fmt=!"=="x!tmpline!" (SET "wset.in.meta.sampling=!tmpline:pix_fmt=!" && SET "wset.in.meta.sampling=!wset.in.meta.sampling:~1!")
			IF NOT "x!tmpline:color_range=!"=="x!tmpline!" (SET "wset.in.meta.cm.range=!tmpline:color_range=!" && SET "wset.in.meta.cm.range=!wset.in.meta.cm.range:~1!")
			IF NOT "x!tmpline:color_space=!"=="x!tmpline!" (SET "wset.in.meta.cm.space=!tmpline:color_space=!" && SET "wset.in.meta.cm.space=!wset.in.meta.cm.space:~1!")
			IF NOT "x!tmpline:color_transfer=!"=="x!tmpline!" (SET "wset.in.meta.cm.transfer=!tmpline:color_transfer=!" && SET "wset.in.meta.cm.transfer=!wset.in.meta.cm.transfer:~1!")
			IF NOT "x!tmpline:color_primaries=!"=="x!tmpline!" (SET "wset.in.meta.cm.primaries=!tmpline:color_primaries=!" && SET "wset.in.meta.cm.primaries=!wset.in.meta.cm.primaries:~1!")
			IF NOT "x!tmpline:avg_frame_rate=!"=="x!tmpline!" (SET "wset.in.meta.fps=!tmpline:avg_frame_rate=!" && SET /A wset.in.meta.fps=!wset.in.meta.fps:~1!)
			IF NOT "x!tmpline:duration=!"=="x!tmpline!" (SET "wset.in.meta.duration=!tmpline:duration=!" && SET "wset.in.meta.duration=!wset.in.meta.duration:~1!")
		)

		ECHO.
		ECHO      Source duration: [01m!wset.in.meta.duration:~0,10![0m at [01m!wset.in.meta.fps![0m fps, dimensions: [01m!wset.in.meta.width![0m x [01m!wset.in.meta.height![0m
		ECHO                codec: [01m!wset.in.meta.codec![0m, chroma: [01m!wset.in.meta.sampling![0m
		ECHO                color: [01m!wset.in.meta.cm.space![0m r:!wset.in.meta.cm.range! p:!wset.in.meta.cm.primaries! t:!wset.in.meta.cm.transfer!

		REM Transcoding
		IF DEFINED wset.out.video.prepass (
			SET "wset.out.video.palette.file=!savepath!!wset.files[%%i].trname!palette.png"
			SET "wset.in.video.prepass=-i "!wset.out.video.palette.file!""
			SET "wset.out.video.prepass.range=-update 1 -frames:v 1"
			ECHO.	
			ECHO      [01m[34mFirst pass:[0m Generating a palette for Gif
			"!stf.path.ffmpeg!ffmpeg.exe" !wset.out.params! !wset.in.meta! !wset.in.sequence.range! -i "!wset.files[%%i].name!" !wset.out.video.prepass! !wset.out.meta! !wset.out.video.prepass.range! -y "!wset.out.video.palette.file!"  
		)

		ECHO.
		IF DEFINED wset.out.video.prepass (ECHO      [01m[34mSecond pass:[0m Encoding)
		IF DEFINED stf.debug.ffcommand ECHO [01mFF command[0m: !wset.out.params! !wset.in.meta! !wset.in.sequence.range! !wset.in.fps.comp! -i "!wset.files[%%i].name!" !wset.in.video.prepass! !wset.in.audio.file.comp! !wset.out.video.comp! !wset.out.fps.comp! !wset.out.audio.comp! !wset.out.meta! !wset.out.sequence.range! !wset.out.quiet! "!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"
		"!stf.path.ffmpeg!ffmpeg.exe" !wset.out.params! !wset.in.meta! !wset.in.sequence.range! !wset.in.fps.comp! -i "!wset.files[%%i].name!" !wset.in.video.prepass! !wset.in.audio.file.comp! !wset.out.video.comp! !wset.out.fps.comp! !wset.out.audio.comp! !wset.out.meta! !wset.out.sequence.range! !wset.out.quiet! "!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"
		ECHO.
		ECHO [01m[34m     Saved as:[0m [03m"!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"[0m

		IF DEFINED wset.out.video.prepass IF EXIST "!wset.out.video.palette.file!" DEL /s "!wset.out.video.palette.file!" > NUL
	) ELSE (
		ECHO      [31mThe file [0m[03m[31m"!wset.files[%%i].name!"[0m[31m was not found. Skipping[0m
	)
	REM End loop
)

:End

IF EXIST "x264_lookahead.clbin" DEL "x264_lookahead.clbin" > NUL
ECHO !stf.con.divline!
ECHO [01m[34mSERVED[0m                                                                             
ECHO !stf.con.divline!
TITLE SendTo FFmpeg: done
EXIT /B