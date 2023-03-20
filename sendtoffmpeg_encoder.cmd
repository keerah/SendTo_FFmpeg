REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM This is one of the SenTo_FFmpeg's modules, keep it with the rest of the files

ECHO [03m[33mSendTo FFmpeg encoder v3.5 by Keerah[0m
ECHO !stf.con.divline!
ECHO Video preset     : !wset.con.line[0]!
ECHO       codec      : !wset.con.line[10]!
ECHO Audio preset     : !wset.con.line[1]!
ECHO       codec      : !wset.con.line[11]!
IF DEFINED wset.con.line[2] ECHO Preset notes     : !wset.con.line[2]!
ECHO !wset.con.line[3]!
ECHO !wset.con.line[4]!
ECHO !wset.con.line[5]!
ECHO !stf.con.divline!
ECHO [01m   !wset.argCount![0m files queued to encode

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
				REM detecting the counter in the end of the filename
				SET "basename=!wset.files[%%i].trname:~0,-%stf.in.sequence.counter%!"
				SET "countername=!wset.files[%%i].trname:~-%stf.in.sequence.counter%!"
				
				SET "middelim="
				SET /A frnumber=-1
				SET "zer="
				REM Construct zero pattern
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
				ECHO      The audio file [03m"!wset.in.audio.file.name!"[0m was found and will be muxed.
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
		ECHO command is !wset.out.params! !wset.in.meta! !wset.in.sequence.range! !wset.in.fps.comp! -i "!wset.files[%%i].name!" !wset.in.video.prepass! !wset.out.video.comp! !wset.out.audio.comp! !wset.out.meta! !wset.out.sequence.range! !wset.out.quiet! "!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"
		"!stf.path.ffmpeg!ffmpeg.exe" !wset.out.params! !wset.in.meta! !wset.in.sequence.range! !wset.in.fps.comp! -i "!wset.files[%%i].name!" !wset.in.video.prepass! !wset.in.audio.file.comp! !wset.out.video.comp! !wset.out.fps.comp! !wset.out.audio.comp! !wset.out.meta! !wset.out.sequence.range! !wset.out.quiet! "!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"
		ECHO.
		ECHO [01m[34m     Saved as:[0m [03m"!savepath!!wset.files[%%i].trnameout!!wset.out.suff!"[0m

		IF DEFINED wset.out.video.prepass IF EXIST "!wset.out.video.palette.file!" DEL /s "!wset.out.video.palette.file!" > NUL
	) ELSE (
		ECHO      [31mThe file [0m[03m[31m"!wset.files[%%i].name!"[0m[31m was not found. Skipping[0m
	)
)

:End
IF EXIST "x264_lookahead.clbin" DEL "x264_lookahead.clbin" > NUL
ECHO !stf.con.divline!
ECHO [01m[34mSERVED[0m                                                                             
ECHO !stf.con.divline!
TITLE SendTo FFmpeg: done
EXIT /B