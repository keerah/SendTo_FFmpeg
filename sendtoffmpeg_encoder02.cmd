REM This is one of the SenTo FFmpeg modular transcoders, keep it with the rest of the files

ECHO [----------------------------------------------------------------------------------------]
ECHO [     %argCount% files queued to encode

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
				FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET /A frnumber=%%N
				IF !frnumber! GTR 0 (
					REM overwrite default framerate setting with the preset's one
					SET /A fps=%wset.fps%
					SET "argFile[%%i].name=!argFile[%%i].path!!basename!%%0!frcounter!d!argFile[%%i].ext!"
					ECHO [     Image sequence detected                                                       ]
					ECHO [     Basename: "!basename!" Start frame: !frnumber! Pattern: "!basename!%%0!frcounter!d"
					SET "wset.seqfr=-framerate %fps% -start_number !frnumber! -pattern_type sequence"
					REM No audio assumed
					SET "wset.audiocomp="
				) ELSE (
					REM No sequence, no pattern
					SET "wset.seqfr="
					SET "wset.seqfrout="
				)
			) ELSE ( 
				REM detecting the counter after first found dot
				REM No implementation yet
			)
		) ELSE (
			SET "wset.seqfr="
			SET "wset.seqfrout="
		)
	) ELSE (
		echo [     Video length is: !vlen! seconds
	)
		
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 1: Generating a palette                                                      ]
	"%ffpath%ffmpeg.exe" !wset.params! !wset.seqfr! -i "!argFile[%%i].name!" !wset.prepass! !wset.seqfrout! -y "!argFile[%%i].trname!"palette.png  
	
	ECHO [----------------------------------------------------------------------------------------]
	ECHO [     Encoding file %%i of %argCount%
	ECHO [     STAGE 2: Encoding to Gif using the generatied palette                              ]
	"%ffpath%ffmpeg.exe" !wset.params! !wset.seqfr! -i "!argFile[%%i].name!" -i "!argFile[%%i].trname!"palette.png !wset.videocomp! !wset.over! "!argFile[%%i].trname!"!wset.suff! 
	
	IF EXIST "!argFile[%%i].trname!palette.png" DEL /s "!argFile[%%i].trname!palette.png" > nul
)

ECHO [----------------------------------------------------------------------------------------]
ECHO [     SERVED                                                                             ]
ECHO [----------------------------------------------------------------------------------------]