@ECHO OFF
REM SendTo_FFmpeg is an FFmpeg based set of batch scripts for transcoding
REM Download from https://github.com/keerah/SendTo_FFmpeg
REM nvenc compatible preset

COLOR 0F
SETLOCAL ENABLEDELAYEDEXPANSION 

REM === compression settings =======================================================================
SET "wset.out.video.rate=10M"
	REM copy to copy the stream, leave empty to disable video
SET "wset.out.audio.rate=128k"
	REM 64k, 96k, 128k, 256k, 320k, copy to copy the stream, leave empty to disable audio
SET "wset.out.format=.mp4"
SET "wset.out.video.codec=h264_nvenc"
	REM h264_nvenc, hevc_nvenc - CUDA h264, h265 encoders. h264_qsv, hevc_qsv - Intel Quick Sync h264, h265 encoders. libvpx, libvpx-vp9, vp9_qsv - vp8, vp9 codecs. libx264, libx265, dnxhd, prores, prores_aw, prores_ks, rawvideo. Use "ffmpeg -ecncoders" command to list. Other codecs may have requirements not compatible with this preset
SET "wset.out.video.rate.control=vbr"
	REM h264_nvenc supports: constqp, vbr, cbr, cbr_ld_hq, cbr_hq, vbr_hq
SET "wset.out.video.sampling=yuv420p"
	REM h264_nvenc supports: yuv420p, nv12, p010le, yuv444p, p016le, yuv444p16le, bgr0, bgra, rgb0, rgba, x2rgb10le, x2bgr10le, gbrp, gbrp16le, cuda, d3d11
SET "wset.out.video.preset=p7"
	REM h264_nvenc supports: slow (2 passes), medium, fast, lossless, hq, p1...p7. Use ffmpeg -h encoder=h264_nvenc command for all options
SET "wset.out.video.tune=hq"
	REM h264_nvenc supports: hq, ll (low latency), ull, lossless
SET "wset.out.video.keyframes=50"
	REM The output video will have keyframes each 2 seconds, more keyframe (lower value) increases the output size
SET "wset.out.audio.codec=aac"
	REM aac, aac_mf, alac, flac, mp3_mf, opus, pcm_s16be, pcm_s16le, pcm_s24le, pcm_s24be, vorbis. Use "ffmpeg -ecncoders" command to list. Other codecs may have requirements not compatible with this preset
SET "wset.out.audio.sampling="
	REM Not used yet. aac supports: 96000 88200 64000 48000 44100 32000 24000 22050 16000 12000 11025 8000 7350
SET "wset.in.audio.file.extension="
	REM If the file extension is defined here (eg .wav), the audio file with the same name as the source's but with this extension will be added as audio to the output. Use uncompressed audio like wav for faster and more precise muxing
SET "wset.out.params=-hide_banner -stats"
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

SET /A stf.result=0
SET /A stf.con.pause=1

IF EXIST "%~dp0sendtoffmpeg_run.cmd" (
	SET "wset.out.type=05"
	CALL "%~dp0sendtoffmpeg_run.cmd" %*
) ELSE (
	SET /A stf.result=5
	ECHO [31mSorry, the [01m[30m[41msendtoffmpeg_run.cmd[0m[31m module is unreacheable. Unable to continue^^![0m
)

IF %stf.result% GTR 0 ECHO [31mResult code is %stf.result%[0m
ECHO.
if NOT %stf.con.pause% == 0 PAUSE