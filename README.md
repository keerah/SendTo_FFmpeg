# Description
This is a set of Windows **batch** scripts that can transcode mostly everything without opening any clunky software. This is a set of tools I develop mainly for myself and it saves me tons of time in everyday work.

![send_to_ffmpeg](https://user-images.githubusercontent.com/9025818/155185990-32fec47d-e557-4a2f-a412-49f2f9a57f3d.jpg "SendTo_FFmpeg presets in the Windows Explorer's Send To menu")

# Installation 

First click `Code` -> `Donwload ZIP` on this page or downlad from the [releases page](https://github.com/keerah/SendTo_FFmpeg/releases) to get all the scripts, it's all yours for free and forever.

Then you will need to [download the FFmpeg executables](https://ffmpeg.org/download.html#build-windows) or from [here on Github](https://github.com/BtbN/FFmpeg-Builds/releases), it's free as well.

By default these scripts assume the path to FFmpeg.exe is `c:\Program Files\ffmpeg\bin`, so you can simply extract the downloaded ffmpeg archive into `c:\Program Files\ffmpeg`. If you place ffmpeg into a different folder, you will need to edit the `ffpath` option in the settings file named `sendtoffmpeg_settings.cmd`. There's a full description for each option in that file.

# Usage
You can use these batches in a few different ways:

## Drag-n-drop
Just drag your files over the corresponding `.bat` file's icon. You can drag files one by one, each will be encoded in a separate process, you can also select multiple files for any script except a couple. Eaxh script announces its features and report about the process, so keep an eye on the output.

## Windows explorer's Send To menu
You can integrate these batches as commands into Windows' `Send To` menu (right-click on any file in the Explorer).

For this you will need to:

1. Put all of these batches to any convenient location (for example in cloud sync folder to have them synced for all machines). Find the file named _sendtoffmpeg_settings.cmd_ and edit it to change the `ffpath` option, that points to the **FFmpeg** executables. If this path is different from `c:\Program Files\ffmpeg`.

2. Now create the shortcuts for these files (Alt-drag them onto your Desktop first). Then move these shortcuts into `C:\Users\[_YOUR USER NAME_]\AppData\Roaming\Microsoft\Windows\SendTo` folder (this will require elevated privileges).

3. Now you may want to rename these shortcuts to get rid of the `Shortcut` word in the names or to whatever you want, but do not change the `.lnk` extension.

4. And finally you will have to manually clear the `Start In` field in each shortcut (this lets the scripts save output files next to your sources) by right-clicking one after another and selecting the `Properties` menu. Along with it you can change the icon of the shortcuts (`Change Icon` button in the same Properties window), these icons will be handy to identify the tasks in the `Send To` menu. This takes time, but a backup of those will serve you well later.

That's all. Now you can right-click on any file(s), navigate to `Send To` menu item and select one of the presets there. The corresponding `.bat` file will do the rest and will place the result into the same folder with s suffix like `_CUDA_420_high.mp4` added to the filename(s) (if descriptive names option `dscr` is enabled).

## Shell

Use it in CMD, Powershell or Terminal as usual.

# User settings

**SendTo** has its own global settings, that you can read more about in the `sendtoffmpeg_settings.cmd` file. They affect all presets at once. You can change them by simply editing this file in a text editor.

## Global vs Local settings

You can have very different settings for your current (and any other) folder by making a copy of `sendtoffmpeg_settings.cmd` in that folder. All parameters you change in it will affect only the files that are transcoded inside this folder. It can be any setting available: the framerate setting, or descriptive naming flag or even the path to FFMpeg itself, so you can use different versions for different cases.

# Image sequence transcoding

- To transcode an image sequence you need to select the first frame of the sequence(s), or any other frame to trim the sequence(s).
- **SendTo** will look for the frame counter at the end of the filename first, it will consider the number of ending symbols defined by `frcounter` setting, which by default is `4`.
- If you select a few frames that belong to different sequences, they will be transcoded independently. If you select a few images of the same image sequence you will get separate outputs for each with different in-point.
- You can supress the sequence detection by changing the `imgset` (Consider image sequences) to `0` in the settings file. Do not forget you can do it for just one particular folder(s) by copying the settings file into this folder and changing this option in it.
- If the frame counter was not found at the end of the filename **SendTo** will attempt to find the counter after the delimiter symbol, which is defined by the setting `frdelim` (Framecounter delimiter) and by default is set to `.`. If it is set to empty string `SET "frdelim="` then this detection is skipped. This feature lets you encode the sequences named like this _`Renderout.0001.puzzleMatte.exr`_.

# Limitations

When you select a large amount of the files to transcode you can easily bump into the command line length limitation. You can either select fewer files or change the windows command line length system setting. 

# Compatibility

**SendTo** works with Windows OS only, any relatively modern version of it. 

# License

You can modify, distribute and use this set of scripts however you want. Just do not sell it.
