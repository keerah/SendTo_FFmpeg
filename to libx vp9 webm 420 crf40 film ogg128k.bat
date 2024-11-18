@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM vp compatible preset

REM === compression settings =======================================================================
SET "wset.out.video.rate=30"
	REM copy to copy the stream, libvpx-vp9 crf supports: -1 to 63
SET "wset.out.audio.rate=128k"
	REM 64k, 96k, 128k, 256k, 320k, copy to copy the stream, leave empty to disable audio
SET "wset.out.video.scale.x=-2"
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.y="
	REM Leave empty to disable scaling. -1 is to scale proportionally, -2 to also keep it to multiple of 2
SET "wset.out.video.scale.algo=lanczos"
	REM bilinear, bicubic, bicublin, gauss, sinc, lanczos, spline and more https://ffmpeg.org/ffmpeg-scaler.html. Can be combined using +
SET "wset.out.video.fps="
	REM Output framerate in Hz. 1 is to output 1 frame per second. Leave empty for no change. Set to negative value to override input framerate to the Abs(fps), this is useful for Gifs to presere all frames but change playback speed
SET "wset.out.format=.webm"
SET "wset.out.video.codec=libvpx-vp9"
	REM h264_nvenc, hevc_nvenc - CUDA h264, h265 encoders. h264_qsv, hevc_qsv - Intel Quick Sync h264, h265 encoders. libvpx, libvpx-vp9, vp9_qsv - vp8, vp9 codecs. libx264, libx265dnxhd, prores, prores_aw, prores_ks, rawvideo. Use "ffmpeg -ecncoders" command to list. Other codecs may have requirements not compatible with this preset
SET "wset.out.video.sampling=yuv420p"
	REM libvpx-vp9 supports: yuv420p yuva420p yuv422p yuv440p yuv444p yuv420p10le yuv422p10le yuv440p10le yuv444p10le yuv420p12le yuv422p12le yuv440p12le yuv444p12le gbrp gbrp10le gbrp12le
SET "wset.out.video.preset=best"
	REM libvpx-vp9 supports: good, best, realtime
SET "wset.out.video.tune=film"
	REM libvpx-vp9 supports: default, screen, film
SET "wset.out.audio.codec=libvorbis"
	REM aac, aac_mf, alac, flac, mp3_mf, opus, pcm_s16le, pcm_s24le, vorbis. Use "ffmpeg -ecncoders" command to list. Other codecs may have requirements not compatible with this preset
SET "wset.out.audio.sampling="
	REM Not used yet. aac supports: 96000 88200 64000 48000 44100 32000 24000 22050 16000 12000 11025 8000 7350
SET "wset.in.audio.file.extension=.wav"
	REM If the file extension is defined here (eg .wav), the audio file with the same name as the source's but with this extension will be added as audio to the output. Use uncompressed audio like wav for faster and more precise muxing
SET "wset.out.params=-hide_banner -stats"
SET "wset.out.sequence=0"

REM === color management settings ==================================================================
SET "wset.in.cm.space=bt709"
SET "wset.in.cm.primaries=bt709"
SET "wset.in.cm.transfer=bt709"
SET "wset.in.cm.range=pc"
SET "wset.out.cm.space=bt709"
SET "wset.out.cm.primaries=bt709"
SET "wset.out.cm.transfer=bt709"
SET "wset.out.cm.range=pc"
	REM Leave the cm.space empty to disable management for input/output. Color spaces: rgb, bt709, fcc, bt470bg, bt2020nc, bt2020c, smpte170m, smpte240m. Ranges: pc, tv, mpeg, jpeg. Primaries: bt709, bt470m, bt470bg, bt2020, film, smpte170m, smpte240m. Transforms: bt709, gamma22, gamma28, linear, log, log_sqrt, bt2020_10, bt2020_12, smpte170m, smpte240m. For full list refer to https://ffmpeg.org/ffmpeg-codecs.html
REM ================================================================================================

COLOR 0F
SETLOCAL ENABLEDELAYEDEXPANSION 
SET /A stf.result=0
SET /A stf.con.pause=1

IF EXIST "%~dp0sendtoffmpeg_run.cmd" (
	SET "wset.out.type=07"
	CALL "%~dp0sendtoffmpeg_run.cmd" %*
) ELSE (
	SET /A stf.result=5
	ECHO [31mSorry, the [01m[30m[41msendtoffmpeg_run.cmd[0m[31m module is unreacheable. Unable to continue^^![0m
)

IF %stf.result% GTR 0 ECHO [31mResult code is %stf.result%[0m
ECHO.
if NOT %stf.con.pause% == 0 PAUSE