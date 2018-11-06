@ECHO OFF
ECHO [---------------------------------------------------------------------------------]
ECHO [---  SendTo FFmpeg encoder v1.03 by Keerah.com                                ---]
ECHO [---  MP4 h264 module has been invoked                                         ---]
ECHO [---  Preset: CUDA 420 main 4.0, 40 Mbps, keyfr 2 sec, Audio Copy              ---]
IF %1.==. (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     NO FILE SPECIFIED                                                           ]
) ELSE (
	ECHO [---------------------------------------------------------------------------------]
	ECHO [     Transcoding...                                                              ]
	"c:\Program Files\ffmpeg\bin\ffmpeg.exe" -vsync 0 -hwaccel cuvid -i %1 -c:v h264_nvenc -profile:v main -preset slow -b:v 40M -pix_fmt yuv420p -force_key_frames 0:00:02 -c:a copy -y %~n1_cuda420_40Mbit_slow.mp4
)
ECHO [---------------------------------------------------------------------------------]
ECHO [     SERVED                                                                      ]
ECHO [---------------------------------------------------------------------------------]
PAUSE

rem Do not forget to replace the path to FFmpeg if its installed into a different folder in your system.

rem As you can see it uses a separate Nvidia codec h264_nvenc.
rem For more information on the codec and its parameters refer to Nvidia's application note
rem https://developer.nvidia.com/designworks/dl/Using_FFmpeg_with_NVIDIA_GPU_Hardware_Acceleration-pdf
rem Just one hint from me on -b:v 20M argument, which defines the bitrate for the output.

rem PAUSE command in the end keeps the batch window open after it's finished just to let you see the messages.
rem If you need more info on encoding then change verbose level -v command from -v warning to -v info.

rem The output video will have keyframes each 2 seconds due to -force_key_frames 0:00:02