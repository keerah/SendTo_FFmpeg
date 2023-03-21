@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM gif compatible preset

REM === compression settings =======================================================================
SET "wset.out.video.fps=-10"
	REM Output framerate in Hz. 1 is to output 1 frame per second. Leave empty for no change. Set to negative value to override input framerate to the Abs(fps), this is useful for Gifs to presere all frames but change playback speed
SET "wset.out.video.colors=16"
	REM Output gif color resolution
SET "wset.out.video.scale.x=640"
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.y=-1"
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.algo=lanczos"
	REM bilinear, bicubic, bicublin, gauss, sinc, lanczos, spline and more https://ffmpeg.org/ffmpeg-scaler.html Can be combined using +
SET "wset.out.format=.gif"
SET "wset.out.video.codec=gif"
SET "wset.out.video.dither=sierra2_4a"
	REM sierra2_4a, none, sierra2, sierra3, bayer, heckbert, floyd_steinberg, burkes, atkinson and more https://ffmpeg.org/ffmpeg-filters.html#paletteuse 
SET "wset.out.video.palette=full"
	REM full for more static parts, diff for more active parts, single for each frame
SET "wset.out.params=-hide_banner -stats -thread_queue_size 256"
SET "wset.out.sequence=0"

REM === color management settings ==================================================================
SET "wset.in.cm.space=bt709"
SET "wset.in.cm.primaries=bt709"
SET "wset.in.cm.transfer=bt709"
SET "wset.in.cm.range=tv"
SET "wset.out.cm.space=bt709"
SET "wset.out.cm.primaries=bt709"
SET "wset.out.cm.transfer=bt709"
SET "wset.out.cm.range=tv"
	REM Leave the cm.space empty to disable management for input/output. Color spaces: rgb, bt709, fcc, bt470bg, bt2020nc, bt2020c, smpte170m, smpte240m. Ranges: pc, tv, mpeg, jpeg. Primaries: bt709, bt470m, bt470bg, bt2020, film, smpte170m, smpte240m. Transforms: bt709, gamma22, gamma28, linear, log, log_sqrt, bt2020_10, bt2020_12, smpte170m, smpte240m. For full list refer to https://ffmpeg.org/ffmpeg-codecs.html
REM ================================================================================================

COLOR 0F
SETLOCAL ENABLEDELAYEDEXPANSION 
SET /A stf.result=0
SET /A stf.pause=1

IF EXIST "%~dp0sendtoffmpeg_run.cmd" (
	SET "wset.out.type=02"
	CALL "%~dp0sendtoffmpeg_run.cmd" %*
) ELSE (
	SET /A stf.result=5
	ECHO [31mSorry, the [01m[30m[41msendtoffmpeg_run.cmd[0m[31m module is unreacheable. Unable to continue^^![0m
)

IF %stf.result% GTR 0 ECHO [31mResult code is %stf.result%[0m
ECHO.
if NOT %stf.pause% == 0 PAUSE