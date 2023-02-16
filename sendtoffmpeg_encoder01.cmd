REM This is one of the SenTo FFmpeg modular transcoders, keep it with the rest of the files

ECHO [----------------------------------------------------------------------------------------]
ECHO [     %argCount% files queued to encode

SET "zer="
FOR /L %%I IN (1,1,%frcounter%) DO SET "zer=!zer!0"

FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO [----------------------------------------------------------------------------------------]

	SET "vlen="
	FOR /F "tokens=* delims=" %%f IN ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argFile[%%i].name!"') DO SET "vlen=%%f"

	IF !vlen! == N/A (
		ECHO [     The source is a single image file with no length 
		
		IF !imgseq! GTR 0 (
			REM detecting image sequence
			IF !frcounter! GTR 0 (
				REM detecting the counter in the end of the filename
				SET "basename=!argFile[%%i].trname:~0,-%frcounter%!"
				SET "countername=!argFile[%%i].trname:~-%frcounter%!"
				SET /A frnumber=-1
				IF !countername!==%zer% (
					REM Zero frame
					SET /A frnumber=0
				) ELSE (
				 	FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET /A frnumber=%%N 
				)
				IF !frnumber! GTR -1 (
					SET "argFile[%%i].name=!argFile[%%i].path!!basename!%%0!frcounter!d!argFile[%%i].ext!"
					ECHO [     Image sequence detected                                                       ]
					ECHO [     Basename: "!basename!" Start frame: !frnumber! Pattern: "!basename!%%0!frcounter!d"
					SET "wset.seqfr=-framerate %fps% -start_number !frnumber! -pattern_type sequence"
					SET "wset.seqfrout=-r %fps%"
					REM No audio assumed
					SET "wset.audiocomp="
				) ELSE (
					SET "wset.seqfr="
					SET "wset.seqfrout="
				)
			) ELSE ( 
				REM detecting the counter after first found dot
				REM No implementation yet
				SET "wset.audiocomp="
			)
		) ELSE (
			SET "wset.seqfr="
			SET "wset.seqfrout="
		)
	) ELSE (
		ECHO [     Video length is: !vlen! seconds
	)

	ECHO [     Transcoding %%i of %argCount%: !argFile[%%i].trname!
	"%ffpath%ffmpeg.exe" !wset.params! !wset.seqfr! -i "!argFile[%%i].name!" !wset.videocomp! !wset.audiocomp! !wset.seqfrout! !wset.over! "!argFile[%%i].trname!"!wset.suff!
)

ECHO [----------------------------------------------------------------------------------------]
ECHO [     SERVED                                                                             ]
ECHO [----------------------------------------------------------------------------------------]
