@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
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
	ECHO %divline%
	GOTO :End
)

REM Check for ffmpeg
IF NOT EXIST "%ffpath%ffmpeg.exe" ( 
	ECHO !    Sorry, the path to ffmpeg.exe is unreacheable. Unable to continue!
	GOTO :End
)


REM compression settings
SET "wset.hline1=ECHO Preset: APNG plain, loop forever"
SET "wset.params=-v %vbl% -hide_banner -stats"
SET "wset.videocomp=-f apng -plays 0"
SET "wset.audiocomp="
IF %quietover% == 1 (SET "wset.over=-y") ELSE (SET "wset.over=")
IF %dscr% GTR 0 (SET "wset.dscr=_animpng") ELSE (SET "wset.dscr=")
SET "wset.suff=!wset.dscr!.png"

ECHO %divline%
ECHO SendTo FFmpeg encoder v3.1 by Keerah
ECHO %wset.hline1%
IF NOT "[%wset.hline2%]"=="[]" ECHO %wset.hline2%
ECHO %wset.hline3%
ECHO %divline%
ECHO    %argCount% files queued to encode


FOR /L %%i IN (1,1,%argCount%) DO (
	
	ECHO %divline%

	FOR /F "tokens=* delims=" %%f IN ('call "%ffpath%ffprobe.exe" -v error -show_entries "format=duration" -of "default=noprint_wrappers=1:nokey=1" "!argFile[%%i].name!"') DO SET "vlen=%%f"

	IF !vlen! == N/A (
		ECHO      The source is a single image file with no length 
		
		IF !imgseq! GTR 0 (
			REM detecting image sequence
			IF !frcounter! GTR 0 (
				REM detecting the counter in the end of the filename
				SET "basename=!argFile[%%i].trname:~0,-%frcounter%!"
				SET "countername=!argFile[%%i].trname:~-%frcounter%!"
				FOR /F "tokens=* delims=0" %%N IN ("!countername!") DO SET /A frnumber=%%N
				IF !frnumber! GTR 0 (
					SET "argFile[%%i].name=!argFile[%%i].path!!basename!%%0!frcounter!d!argFile[%%i].ext!"
					ECHO      Image sequence detected
					ECHO      Basename: "!basename!" Start frame: !frnumber! Pattern: "!basename!%%0!frcounter!d"
					SET "seqfr=-framerate %fps% -start_number !frnumber! -pattern_type sequence"
					SET "seqfrout=-r %fps%"
				) ELSE (
					SET "seqfr="
					SET "seqfrout="
				)
			) ELSE ( 
				REM detecting the counter after first found dot
				REM No implementation yet
			)
		) ELSE (
			SET "seqfr="
			SET "seqfrout="
		)
	) ELSE (
		echo      Video length is: !vlen! seconds
	)

	ECHO      Transcoding %%i of %argCount%: !argFile[%%i].trname!
	"%ffpath%ffmpeg.exe" !wset.params! !seqfr! -i "!argFile[%%i].name!" !wset.videocomp! !wset.audiocomp! !seqfrout! !wset.over! "!argFile[%%i].trname!"!wset.suff!
)

ECHO %divline%
ECHO SERVED                                                                        
ECHO %divline%

:End
if %pse% GTR 0 PAUSE