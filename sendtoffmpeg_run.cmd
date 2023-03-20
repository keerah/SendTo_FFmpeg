REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM This is one of the SenTo_FFmpeg's modules, keep it with the rest of the files

COLOR 0F
title SendTo FFmpeg: initializing

REM Consolidating settings
REM Scale
IF DEFINED wset.out.video.scale.x IF DEFINED wset.out.video.scale.y (
	SET "wset.out.video.scale.vf=,scale=!wset.out.video.scale.x!:!wset.out.video.scale.y!:flags=!wset.out.video.scale.algo!"
	SET "wset.con.video.scale=, [01m!wset.out.video.scale.x![0m:[01m!wset.out.video.scale.y! !wset.out.video.scale.algo![0m"
	SET "wset.dscr.video.scale=_!wset.out.video.scale.x!x!wset.out.video.scale.y!"
)
REM Framerate
IF DEFINED wset.out.video.fps (
	SET /A wset.out.video.fps=!wset.out.video.fps!
	IF NOT !wset.out.video.fps! == 0 (SET "wset.con.video.fps=, [01m!wset.out.video.fps![0m fps" && SET "wset.dscr.video.fps=_!wset.out.video.fps!fps")
	IF !wset.out.video.fps! LSS 0 (
		SET /A wset.out.video.fps=-!wset.out.video.fps! 
		SET "wset.out.video.fps.sync=sync" 
		SET "wset.con.video.fps=, [01msync !wset.out.video.fps![0m fps" 
		SET "wset.dscr.video.fps=_sync!wset.out.video.fps!fps")
)

REM No audio default
SET "wset.con.line[1]=Audio is not supported for this format"
SET "wset.con.line[11]=None"
SET "wset.out.audio.comp="
SET "wset.dscr.audio.comp="


IF "!wset.out.type!"=="01" (
	REM === apng
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! -plays !wset.out.loop! -final_delay !wset.out.loop.finaldelay!"
	SET "wset.con.line[0]=!wset.out.video.codec!, loop forever!wset.con.video.scale!!wset.con.video.fps!"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

IF "!wset.out.type!"=="02" (
	REM === gif

	SET "wset.con.line[0]=Gif [01m!wset.out.video.colors![0m, colors [01m!wset.out.video.dither![0m!wset.con.video.scale!!wset.con.video.fps!, [01m!wset.out.video.palette![0m palette 2 pass"
	SET "wset.out.video.prepass=-vf "fps=!wset.out.video.fps!!wset.out.video.scale.vf!,palettegen=max_colors=!wset.out.video.colors!:stats_mode=!wset.out.video.palette!""
	SET "wset.out.video.comp=-c:v !wset.out.video.codec! -filter_complex "fps=!wset.out.video.fps!!wset.out.video.scale.vf![x];[x][1:v]paletteuse=dither=!wset.out.video.dither!""

	SET "wset.out.descriptive=_!wset.out.video.codec!!wset.out.video.colors!!wset.dscr.video.scale!!wset.dscr.video.fps!"
	GOTO :Process
)

IF "!wset.out.type!"=="03" (
	REM === jpeg
	SET "wset.out.video.vf.comp=-vf "scale=in_range=mpeg:out_range=full!wset.out.video.scale.vf!""

	SET "wset.con.line[0]=jpeg, chroma [01m!wset.out.video.sampling![0m, rate [01m!wset.out.video.rate![0m!wset.con.video.scale!!wset.con.video.fps!"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_jpeg_!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! "-q:v" !wset.out.video.rate! !wset.out.video.fps.comp! -pix_fmt !wset.out.video.sampling!"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

IF "!wset.out.type!"=="04" (
	REM === libxh
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line[0]=h264 mp4 libx, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate!!wset.con.video.scale!!wset.con.video.fps![0m, tune [01m!wset.out.video.tune![0m, key int [01m!wset.out.video.keyframes! fr[0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_BL3_crf!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! !wset.out.video.profile! -preset !wset.out.video.preset! -crf !wset.out.video.rate! -rc-lookahead 10 -pix_fmt !wset.out.video.sampling! !wset.out.video.scale.comp! -tune !wset.out.video.tune! -x264-params opencl=true -g !wset.out.video.keyframes!"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line[0]=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line[0]=Copy video stream" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line[1]=[01m!wset.out.audio.codec![0m rate [01m!wset.out.audio.rate![0m"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line[1]=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line[1]=Copy audio stream" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

IF "!wset.out.type!"=="05" (
	REM === nvench
	SET "wset.con.line[0]=h264 mp4 CUDA, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate!!wset.con.video.scale![0m, tune [01m!wset.out.video.tune![0m, key int [01m!wset.out.video.keyframes! fr[0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_!wset.out.video.rate!"
	SET "wset.out.video.comp=-c:v !wset.out.video.codec! -b:v !wset.out.video.rate! -rc !wset.out.video.rate.control! -pix_fmt !wset.out.video.sampling! -preset !wset.out.video.preset! -tune !wset.out.video.tune! -multipass 2 -rc-lookahead 10 -g !wset.out.video.keyframes!"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line[0]=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line[0]=Copy video stream" && SET "wset.con.line[10]=Same as source" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line[1]=[01m!wset.out.audio.codec![0m rate [01m!wset.out.audio.rate![0m"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line[1]=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line[1]=Copy audio stream" && SET "wset.con.line[11]=Same as source" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)

IF "!wset.out.type!"=="06" (
	REM === png
	SET "wset.out.video.vf.comp=-vf "scale=in_range=full:out_range=full!wset.out.video.scale.vf!""

	SET "wset.con.line[0]=PNG, chroma [01m!wset.out.video.sampling![0m, compression [01m!wset.out.video.compress![0m!wset.con.video.scale!!wset.con.video.fps!"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_png_c!wset.out.video.compress!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! "-c:v" !wset.out.video.codec! -compression_level !wset.out.video.compress! -pix_fmt !wset.out.video.sampling!"

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.video.fps!!wset.dscr.audio.comp!"
	GOTO :Process
)

IF "!wset.out.type!"=="07" (
	REM === libxvp9
	IF DEFINED wset.out.video.scale.vf SET "wset.out.video.vf.comp=-vf "showinfo!wset.out.video.scale.vf!""

	SET "wset.con.line[0]=WebM VP9, chroma [01m!wset.out.video.sampling![0m, preset [01m!wset.out.video.preset![0m, rate [01m!wset.out.video.rate!!wset.con.video.scale![0m, tune [01m!wset.out.video.tune![0m"
	SET "wset.dscr.video.comp=_!wset.out.video.sampling!_crf!wset.out.video.rate!"
	SET "wset.out.video.comp=!wset.out.video.vf.comp! -c:v !wset.out.video.codec! -crf !wset.out.video.rate! -pix_fmt !wset.out.video.sampling! -quality !wset.out.video.preset! -tune-content !wset.out.video.tune! -rc_lookahead 25"
	IF NOT DEFINED wset.out.video.rate (SET "wset.out.video.comp=" && SET "wset.con.line[0]=Off" && SET "wset.dscr.video.comp=")
	IF "!wset.out.video.rate!"=="copy" (SET "wset.out.video.comp=-c:v copy" && SET "wset.con.line[0]=Copy video stream" && SET "wset.con.line[10]=Same as source" && SET "wset.dscr.video.comp=_vcopy") 

	SET "wset.con.line[1]=!wset.out.audio.codec! !wset.out.audio.rate!"
	SET "wset.dscr.audio.comp=_!wset.out.audio.codec!!wset.out.audio.rate!"
	SET "wset.out.audio.comp=-c:a !wset.out.audio.codec! -b:a !wset.out.audio.rate!"
	IF NOT DEFINED wset.out.audio.rate (SET "wset.con.line[1]=Off" && SET "wset.out.audio.comp=" && SET "wset.dscr.audio.comp=")
	IF "!wset.out.audio.rate!"=="copy" (SET "wset.out.audio.comp=-c:a copy" && SET "wset.con.line[1]=Copy audio stream" && SET "wset.con.line[11]=Same as source" && SET "wset.dscr.audio.comp=_acopy")

	SET "wset.out.descriptive=!wset.dscr.video.comp!!wset.dscr.video.scale!!wset.dscr.audio.comp!"
	GOTO :Process
)


:Process
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
	SET "wset.con.line[3]=SendTo settings  : [30m[44m Local [0m"
	SET "wset.con.line[4]=Verbosity level  : !stf.con.verbose!"
) ELSE (
	IF EXIST "!wset.path.cmd!sendtoffmpeg_settings.cmd" (
		CALL "!wset.path.cmd!sendtoffmpeg_settings.cmd"
		SET "wset.con.line[3]=SendTo settings  : [30m[47m Global [0m"
		SET "wset.con.line[4]=Verbosity level  : !stf.con.verbose!"
	) ELSE (
		SET /A stf.result=1
		ECHO !stf.con.divline!
		ECHO [31mSorry, the [30m[41msendtoffmpeg_settings.cmd[0m[31m is unreacheable. Unable to continue^^![0m	
		ECHO This file was expected at path [03m"!wset.path.cmd!"[0m.
		ECHO !stf.con.divline!
		GOTO :End
	)
)

REM Check for ffmpeg
IF NOT EXIST "!stf.path.ffmpeg!ffmpeg.exe" ( 
	SET /A stf.result=3
	ECHO !stf.con.divline!
	ECHO [31mSorry, the [30m[41mffmpeg.exe[0m[31m is unreacheable. Unable to continue^^![0m
	ECHO Your ffmpeg path is [03m"!stf.path.ffmpeg!ffmpeg.exe"[0m.
	ECHO Check it and change the current settings accordingly.
	ECHO Your current settings are !wset.con.line[3]:~12!
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

IF !stf.result!==0 (

	IF "!stf.out.quiet!" == "1" (
		SET "wset.out.quiet=-y"
	) ELSE (
		SET "wset.out.quiet="
	)
	
	IF NOT "!stf.out.descriptive!" == "1" SET "wset.out.descriptive="
	
	SET "wset.out.params=-v !stf.con.verbose! !wset.out.params!"
	SET "wset.in.meta="
	SET "wset.out.meta="

	IF "!stf.cm.on!"=="1" (

		SET "wset.con.line[5]=Color management : Input "
		
		IF NOT DEFINED wset.in.cm.space (
			SET "wset.con.line[5]=!wset.con.line[5]![01mfrom source[0m"
		) ELSE (
			SET "wset.in.meta=-color_primaries !wset.in.cm.primaries! -color_range !wset.in.cm.range! -color_trc !wset.in.cm.transfer! -colorspace !wset.in.cm.space!"
			SET "wset.con.line[5]=!wset.con.line[5]![01m!wset.in.cm.space![0m r:!wset.in.cm.range! p:!wset.in.cm.primaries! t:!wset.in.cm.transfer!"
		)
		
		SET "wset.con.line[5]=!wset.con.line[5]! ^| Convert to "

		IF NOT DEFINED wset.out.cm.space (
			SET "wset.con.line[5]=!wset.con.line[5]![01moff[0m"
		) ELSE (
			SET "wset.out.meta=-color_primaries !wset.out.cm.primaries! -color_range !wset.out.cm.range! -color_trc !wset.out.cm.transfer! -colorspace !wset.out.cm.space!"
			SET "wset.con.line[5]=!wset.con.line[5]![01m!wset.out.cm.space![0m r:!wset.out.cm.range! p:!wset.out.cm.primaries! t:!wset.out.cm.transfer!"
		)
	) ELSE (
		
		SET "wset.con.line[5]=Color management: OFF"
	)

	REM Checking codec support
	IF DEFINED wset.out.video.codec IF DEFINED wset.out.video.comp IF NOT "!wset.out.video.rate!"=="copy" (
		SET first=1
		FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffmpeg.exe" -hide_banner -h "encoder=!wset.out.video.codec!"') DO (
			IF !first!==1 SET "wset.con.line[10]=%%f"
			SET first=0
		) 
		IF NOT "x!wset.con.line[10]:is not recognized=!"=="x!wset.con.line[10]!" (
			SET /A stf.result=10
			ECHO !stf.con.divline!
			ECHO [31mSorry, the FFmpeg you're using does not recognize the requested video encoder [30m[41m !wset.out.video.codec! [0m[31m.[0m
			ECHO Check the [30m[41m wset.out.video.codec [0m preset settings or try using another version of FFmpeg.
			ECHO !stf.con.divline!
			GOTO :End
		)
		IF NOT "x!wset.con.line[10]:need to be recompiled=!"=="x!wset.con.line[10]!" (
			SET /A stf.result=11
			ECHO !stf.con.divline!
			ECHO [31mSorry, the video encoder [30m[41m !wset.out.video.codec! [0m [31mis unavailable in the version of FFmpeg you're using.[0m
			ECHO Although this codec is known to FFmpeg. You most likely need to get another build/version of it.
			ECHO You can utilize various instances of FFmpeg binaries using SendTo's [30m[44m Local [0m settings.
			ECHO !stf.con.divline!
			GOTO :End
		)
		SET "wset.con.line[10]=!wset.con.line[10]:Encoder =!"
		SET "wset.con.line[10]=!wset.con.line[10]:~0,-1!"
	)	

	IF DEFINED wset.out.audio.comp IF NOT "!wset.out.audio.rate!"=="copy" (
		SET first=1
		FOR /F "delims=" %%f IN ('call "!stf.path.ffmpeg!ffmpeg.exe" -hide_banner -h "encoder=!wset.out.audio.codec!"') DO (
			IF !first!==1 SET "wset.con.line[11]=%%f"
			SET first=0
		)
		IF NOT "x!wset.con.line[11]:is not recognized=!"=="x!wset.con.line[11]!" (
			SET /A stf.result=10
			ECHO !stf.con.divline!
			ECHO [31mSorry, the FFmpeg you're using does not recognize the requested audio encoder [30m[41m !wset.out.audio.codec! [0m[31m.[0m
			ECHO Check the [30m[41m wset.out.audio.codec [0m preset settings or try using another version of FFmpeg.
			ECHO !stf.con.divline!
			GOTO :End
		)
		IF NOT "x!wset.con.line[11]:need to be recompiled=!"=="x!wset.con.line[11]!" (
			SET /A stf.result=11
			ECHO !stf.con.divline!
			ECHO [31mSorry, the audio encoder [30m[41m !wset.out.audio.codec! [0m [31is unavailable in the version of FFmpeg you're using.[0m
			ECHO Although this codec is known to FFmpeg. You most likely need to get another build/version of it.
			ECHO You can utilize various instances of FFmpeg binaries using SendTo's [30m[44m Local [0m settings.
			ECHO !stf.con.divline!
			GOTO :End
		)
		SET "wset.con.line[11]=!wset.con.line[11]:Encoder =!"
		SET "wset.con.line[11]=!wset.con.line[11]:~0,-1!"
	)

	IF EXIST "!wset.path.cmd!sendtoffmpeg_encoder.cmd" (
		CALL "!wset.path.cmd!sendtoffmpeg_encoder.cmd"
	) ELSE (
		ECHO !stf.con.divline!
		ECHO [31mSorry, the module [30m[41msendtoffmpeg_encoder.cmd[0m[31m is unreacheable. Unable to continue^^![0m
		ECHO This file was expected at path [03m"!wset.path.cmd!"[0m.
		ECHO !stf.con.divline!
		SET /A stf.result=4
	)
) ELSE (
	SET "stf.con.pause=0"
)

:End
EXIT /B