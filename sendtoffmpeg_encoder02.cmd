REM This is one of the SenTo FFmpeg modular transcoders, keep it with the rest of the files
REM v3.1

ECHO %divline%
ECHO SendTo FFmpeg encoder v3.1 by Keerah
ECHO %wset.hline1%
IF NOT "[%wset.hline2%]"=="[]" ECHO %wset.hline2%
ECHO %wset.hline3%
ECHO %divline%
ECHO    %argCount% files queued to encode

FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO %divline%
	
	SET "vlen="
	FOR /F "tokens=* delims=" %%f IN ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argFile[%%i].name!"') DO SET "vlen=%%f"

	IF !vlen! == N/A (
		ECHO      The source is a single image file with no length
		SET "wset.audiocomp="

		IF !imgseq! GTR 0 (
			REM detecting image sequence
			IF !frcounter! GTR 0 (
				REM detecting the counter in the end of the filename
				SET "basename=!argFile[%%i].trname:~0,-%frcounter%!"
				SET "countername=!argFile[%%i].trname:~-%frcounter%!"
				
				SET "middelim="
				SET /A frnumber=-1
				SET "zer="
				FOR /L %%I IN (1,1,%frcounter%) DO SET "zer=!zer!0"
				
				IF !countername!==!zer! (
					REM Zero frame
					SET /A frnumber=0
				) ELSE (
					REM Validating frame number
					SET "ddet="
					FOR /F "delims=0123456789" %%I IN ("!countername!") DO SET ddet=%%i

					IF defined ddet (
						ECHO      The last %frcounter% symbols of the filename is not a number

						IF NOT [%frdelim%] == [] (
							REM Now let's try to use delimiter
							FOR /f "tokens=1-3 delims=%frdelim%" %%A in ("!argFile[%%i].trname!") do (
								SET "beforedelim=%%A"
								SET "middelim=%%B"
								SET "afterdelim=%%C"
							)
							REM Limiting the counter. Lazy way, will consider string length calculation in future to get all digits
							SET "middelimtr=!middelim:~0,%frcounter%!"

							REM Validating frame number
							SET "ddet="
							FOR /F "delims=0123456789" %%I IN ("!middelimtr!") DO SET ddet=%%i
							IF defined ddet (
								ECHO      No frame number after delimiter found. No sequence assumed
							) ELSE (
								ECHO      Image sequence detected. Frame number after delimiter "%frdelim%". Digits:%frcounter%
								REM Removing leading zeroes (if any)
								FOR /F "tokens=* delims=0" %%N IN ("!middelimtr!") DO SET "frnumbername=%%N"
								SET /A "frnumber=!frnumbername!"
							)
						)
					) ELSE (
						ECHO      Image sequence detected. Frame number at the end of the filename. Digits:%frcounter%
						REM Removing leading zeroes (if any)
						FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET "frnumbername=%%N"
						SET /A "frnumber=!frnumbername!"
					)
				)

				IF !frnumber! GTR -1 (
					IF [!middelim!] == [] (
						REM Constructing the pattern in the end of the name
						SET "argFile[%%i].name=!argFile[%%i].path!!basename!%%0%frcounter%d!argFile[%%i].ext!"
						ECHO      Basename:"!basename!" Start frame:!frnumber! Pattern:"!basename!%%0%frcounter%d"
					) ELSE (
						REM Constructing the pattern after the delimiter
						REM !!! Needs a fix if middelim was trimmed to frcounter = add the trimmed part to filename!!!
						IF !middelim! == !middelimtr! (SET "midsfx=") ELSE (SET midsfx=!middelim:~%frcounter%!)
						SET "argFile[%%i].name=!argFile[%%i].path!!beforedelim!%frdelim%%%0%frcounter%d!midsfx!%frdelim%!afterdelim!!argFile[%%i].ext!"
						ECHO      Basename:"!beforedelim!" Start frame:!frnumber! Pattern:"!beforedelim!%frdelim%%%0%frcounter%d!midsfx!%frdelim%!afterdelim!"
					)
					SET /A fps=!wset.fps!
					SET "wset.seqfr=-framerate !fps! -start_number !frnumber! -pattern_type sequence"
					ECHO      The source and output FPS synced to !fps!
				) ELSE (
					SET "wset.seqfr="
				)
			)
		) ELSE (
			SET "wset.seqfr="
		)
	) ELSE (
		ECHO      Video length is: !vlen! seconds
	)
		
	ECHO      Encoding file %%i of %argCount%
	ECHO      STAGE 1: Generating a palette
	"%ffpath%ffmpeg.exe" !wset.params! !wset.seqfr! -i "!argFile[%%i].name!" !wset.prepass! !wset.seqfrout! -y "!argFile[%%i].trname!"palette.png  
	
	ECHO %divline%
	ECHO      Encoding file %%i of %argCount%
	ECHO      STAGE 2: Encoding to Gif using the generatied palette
	"%ffpath%ffmpeg.exe" !wset.params! !wset.seqfr! -i "!argFile[%%i].name!" -i "!argFile[%%i].trname!"palette.png !wset.videocomp! !wset.over! "!argFile[%%i].trname!"!wset.suff! 
	
	IF EXIST "!argFile[%%i].trname!palette.png" DEL /s "!argFile[%%i].trname!palette.png" > nul
)

ECHO %divline%
ECHO SERVED                                                                             
ECHO %divline%