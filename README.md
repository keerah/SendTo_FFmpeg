# Description

`SendTo_FFmpeg` is a zero-dependecy (except FFmpeg itself) workframe that helps you with repetitive and bulk transcoding tasks right from the Windows explorer (or from the command line).
This set of scripts can help you transode virtually everything into anything, it supports image sequences (for both input and/or output) and hardware acceleration.

The presets are simple Windows batch sripts that you engage via drag-n-drop or by using a provided script to incorporate them into the Explorer's `Send To` menu.
Each preset is a batch file that initializes the transoding settings and pass them along with your files to FFmpeg. 

There's a separate batch file that contains all global settings used by all presets. And these settings can be localized (overriden) to a specific folder by copying and modifying that settings file into the folder.
`SendTo_FFmpeg` presets are easy to run and to modify using a simple text editor.

<img src="https://github.com/keerah/SendTo_FFmpeg/assets/9025818/a6dbd6f0-73a2-484d-aaa1-0147b31e50ee)" alt="SendTo interface" width=80%>


# Installation 

First click `Code` -> `Donwload ZIP` on this page or downlad from the [releases page](https://github.com/keerah/SendTo_FFmpeg/releases) to get all the scripts. Unpack the downloaded zip to any convenient location where these presets will stay present.

Then you need to [download the offical FFmpeg executables](https://ffmpeg.org/download.html#build-windows) or from [here on Github](https://github.com/BtbN/FFmpeg-Builds/releases), it's free as well.

By default these scripts assume the path to FFmpeg.exe is `c:\Program Files\ffmpeg\bin`, so you can simply extract the downloaded ffmpeg archive into `c:\Program Files\ffmpeg`. If you place ffmpeg into a different folder, you will need to edit the `stf.path.ffmpeg` option in the settings file named `sendtoffmpeg_settings.cmd`. There's a full description for each option in that file.

# Usage

## Windows explorer's Send To menu

<img src="https://github.com/keerah/SendTo_FFmpeg/assets/9025818/cccdec6b-e887-4c94-b498-36987db94a92)" width=80%>

You can integrate these batches into Windows' `Send To` menu (right-click on any file in the Explorer). Now it's automated and easy to do.

After you unpacked the scripts into their permanent location, just run the file `Create_SendTo_Shortcuts.bat` by double-clicking it and follow instructions. This script requires VB script enabled on your system. It will create all the shortcut files for you and will open the folder containing them. There's plenty of presets already and you might decide to remove some of the links to unclutter the menu. 

Now you can right-click on any file(s), navigate to `Send To` menu item and select one of the presets there. The corresponding `.bat` file will do the rest and will place the result into the same folder with a suffix like `_yuv420p_20M_aac320k.mp4` added to the filename(s). This is the `Descriptive name` feature, that you can disable in the settings.

## Drag-n-drop
Just drag your files over the corresponding `.bat` file's icon. You can drag files one by one, each will be encoded in a separate process, you can also select multiple files for any script except a couple. Each script announces its features and reports about the process, so keep an eye on the output.

# Presets

## Pre-made
**SendTo** comes with a number of ready-to-use presets that have quality over speed proritization. 

Presets are built in groups dedicated to a particular encoder.

## Creating new presets

<img src="https://github.com/keerah/SendTo_FFmpeg/assets/9025818/c1112ed9-7999-42d4-a3ca-fa29292643a3)" width=80%>

Creating your own preset is now much more convenient. If there's a preset for the encoder you require a new preset to be made with, you can simply duplicate it and change the basic options in the topmost section of the preset by editing it in any text editor. It's more complicated to create a preset for encoder that is not represented in this pack. Feel free to ping me in [Issues](https://github.com/keerah/SendTo_FFmpeg/issues) with your request.

## Meta-options
This new feature simplifies the preset adjustments. For now there's just one `copy` option for the `wset.out.video.rate` and `wset.out.video.rate` that will loslessly copy the video/audio stream from the source into the output (if supported by the output format/muxer). It overrides all other encoding settings accordingly.

# User settings

**SendTo** has its own global settings, that you can read more about in the `sendtoffmpeg_settings.cmd` file. They affect all presets at once. You can change them by simply editing this file in a text editor. Each option in that file has a full description of its functionality.

<img src="https://github.com/keerah/SendTo_FFmpeg/assets/9025818/55a6320f-e1aa-45ba-8aa1-6f03c5ec1e2a" width=80%>

## Global vs Local settings
You can have very different settings for your current (and any other) folder by making a copy of `sendtoffmpeg_settings.cmd` in that folder. All parameters you change in it will affect only the files that belong to this folder. It can be any setting available: the framerate setting, or descriptive naming flag or even the path to **FFMpeg** itself, so you can use different versions for different cases.

# Image sequence transcoding

- To transcode an image sequence you need to select the first frame of the sequence(s), or any other frame to trim the sequence(s). You can supress the sequence detection by changing the `stf.in.sequence.counter` (Frame counter digits) option to `0` in the settings file. 
- **SendTo** will look for the frame counter at the end of the filename first, it will only consider the number of ending symbols defined by `stf.in.sequence.counter` setting, which by default is `4`. Do not forget you can do it for just one particular folder(s) by copying the settings file into this folder and changing this option in it.
- If the frame counter was not found at the end of the filename **SendTo** will attempt to find the counter after the delimiter symbol, which is defined by the setting `stf.in.sequence.delim` (Framecounter delimiter) and by default is set to `.`. If it is set to empty string `SET "stf.in.sequence.delim="` then this detection is skipped. This feature lets you encode the sequences named like this _`Renderout.0001.puzzleMatte.exr`_.
- If all attempts to detect the frame counter fail, you will get a single frame output.
- If you select a few frames that belong to different sequences, they will be transcoded independently. If you select a few images of the same image sequence you will get separate outputs for each with different in-points corresponding to the selected frames.

# Color management

Color management feature is still work in progress, no actual color conversion is applied in current beta.

There's a new section in each of the presets that defines 4 main parameters for both input and output: colorspace, primaries, transfer function and color range. The list of available options attached. 
There's also the new global option `stf.cm.on` that toggles the color management for all presetets. By default it is on (set to 1).

# Limitations

- **SendTo** currently considers the first video and audio streams as the source. Although FFmpeg still auto resolves other streams, there's no guarantee it'll work out for each case.
- When you select a large amount of the files to transcode you may bump into the command line length limitation of 8191 characters. To workaround this you can select fewer files.

# Compatibility

FFmpeg 4.3+, 5 and 6 compatible

No other dependencies 

**SendTo** works with Windows OS only, any relatively modern version of it. 

# License

You can modify, distribute and use this set of scripts however you want. Just do not sell it.
