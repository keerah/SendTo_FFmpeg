@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM jpeg compatible preset

COLOR 0F
SETLOCAL ENABLEDELAYEDEXPANSION 

REM === compression settings =======================================================================
SET "wset.out.video.rate=2"
	REM mjpeg codec supports: 2 - 32 (high to low quality)
SET "wset.out.video.fps="
	REM Output framerate in Hz. 1 is to output 1 frame per second. Leave empty for no change. Set to negative value to override input framerate to the Abs(fps), this is useful for Gifs to presere all frames but change speed
SET "wset.out.video.scale.x="
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.y="
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.algo=lanczos"
	REM bilinear, bicubic, bicublin, gauss, sinc, lanczos, spline and more https://ffmpeg.org/ffmpeg-scaler.html
SET "wset.out.format=.jpg"
SET "wset.out.video.codec=mjpeg"
SET "wset.out.video.sampling=yuvj444p"
	REM mjpeg supports: yuvj444p, yuvj420p, yuvj422p, yuv420p, yuv422p, yuv444p
SET "wset.out.params=-hide_banner -stats"
SET "wset.out.sequence=1"

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

SET /A stf.result=0
SET /A stf.pause=1

IF EXIST "%~dp0sendtoffmpeg_run.cmd" (
	SET "wset.out.type=03"
	CALL "%~dp0sendtoffmpeg_run.cmd" %*
) ELSE (
	SET /A stf.result=5
	ECHO [31mSorry, the [01m[30m[41msendtoffmpeg_run.cmd[0m[31m module is unreacheable. Unable to continue^^![0m
)

IF %stf.result% GTR 0 ECHO [31mResult code is %stf.result%[0m
ECHO.
if NOT %stf.pause% == 0 PAUSE