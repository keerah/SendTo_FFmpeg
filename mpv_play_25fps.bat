@ECHO OFF

TITLE MPV sequence player

SET "mpv.path=C:\Users\Keerah\AppData\Local\Programs\mpv\"
SET /A mpv.fps=25
SET /A mpv.sequence.counter=4
SET /A "mpv.sequence.delim=_"

SET "mpv.file.name=%~f1"
SET "mpv.file.trname=%~n1"
SET "mpv.file.ext=%~x1"
SET "mpv.file.path=%~dp1"

SETLOCAL ENABLEDELAYEDEXPANSION 

REM Detecting the counter

IF DEFINED mpv.file.name (
	IF EXIST "%mpv.file.name%" (
		IF !mpv.sequence.counter! GTR 0 (
			SET "basename=!mpv.file.trname:~0,-%mpv.sequence.counter%!"
			SET "countername=!mpv.file.trname:~-%mpv.sequence.counter%!"
			
			SET "middelim="
			SET /A frnumber=-1
			
			REM Constructing zero pattern
			SET "zer="
			FOR /L %%I IN (1,1,!mpv.sequence.counter!) DO SET "zer=!zer!0"
			
			IF !countername!==!zer! (
				REM Zero frame
				SET /A frnumber=0
				ECHO      Frame counter detected at the end of the filename, digits: [01m!mpv.sequence.counter![0m.
			) ELSE (
				REM Validating frame number at the end
				SET "ddet="
				FOR /F "delims=0123456789" %%I IN ("!countername!") DO SET ddet=%%i
				IF DEFINED ddet (
					REM Not a number
					ECHO      The last [01m!mpv.sequence.counter![0m symbols of the filename is not a number.
					IF DEFINED mpv.sequence.delim (
						REM Try to use delimiter
						FOR /f "tokens=1-3 delims=%mpv.sequence.delim%" %%A in ("!mpv.file.trname!") do (
							SET "beforedelim=%%A"
							SET "middelim=%%B"
							SET "afterdelim=%%C"
						)
						REM Limiting the counter. Lazy way, will consider string length calculation in future to get all digits
						SET "middelimtr=!middelim:~0,%mpv.sequence.counter%!"

						REM Validating frame number after delimiter
						SET "ddet="
						FOR /F "delims=0123456789" %%I IN ("!middelimtr!") DO SET ddet=%%i
						IF DEFINED ddet (
							ECHO      No frame counter found after delimiter "[01m!mpv.sequence.delim![0m". No image sequence assumed.
						) ELSE (
							ECHO      Frame counter detected after delimiter "[01m!mpv.sequence.delim![0m", digits: [01m!mpv.sequence.counter![0m.
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
					ECHO      Frame counter detected at the end of the filename, digits: [01m!mpv.sequence.counter![0m.
					REM Removing leading zeroes (if any)
					FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET "frnumbername=%%N"
					SET /A "frnumber=!frnumbername!"
				)
			)

			IF !frnumber! GTR -1 (
				IF NOT DEFINED middelim (
					REM Constructing the pattern in the end of the name
					SET "mpv.file.pat=!basename!*"
				) ELSE (
					REM Constructing the pattern after the delimiter
					REM If middelim was trimmed to mpv.sequence.counter = add the trimmed part to filename
					IF !middelim! == !middelimtr! (SET "midsfx=") ELSE (SET midsfx=!middelim:~%mpv.sequence.counter%!)
					SET "mpv.file.pat=!beforedelim!!mpv.sequence.delim!*!mpv.sequence.delim!!afterdelim!"
					SET "basename=!beforedelim!"
				)
				ECHO      Basename: [03m"!basename!"[0m, start frame: [01m!frnumber![0m, pattern: [03m"!mpv.file.pat!!mpv.file.ext!"[0m
				REM Replace counter with the pattern
				SET "mpv.file.name=!mpv.file.path!!mpv.file.pat!!mpv.file.ext!"

			)
			
			REM Playing
			ECHO      Let's play at !mpv.fps! fps...
			"!mpv.path!mpv.exe" "!mpv.file.name!" "--merge-files=yes" "--no-correct-pts" "--fps=!mpv.fps!" "--idle=yes" "--loop=inf" "--title=Playing !mpv.file.name!"

		) ELSE (
			ECHO The counter length is not set or zero
		)
	) ELSE (
		ECHO The file was not found	
	)
) ELSE (
	ECHO No file specified
)