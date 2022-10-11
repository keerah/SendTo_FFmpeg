# Description
This is a set of Windows **batch** scripts for effortless video transcoding using the free **FFmpeg** tool. This is a set of tools I develop mainly for myself and it saves me tons of time in every day work.

![send_to_ffmpeg](https://user-images.githubusercontent.com/9025818/155185990-32fec47d-e557-4a2f-a412-49f2f9a57f3d.jpg "SendTo_FFmpeg presets in the Windows Explorer's Send To menu")

First click **Code** -> **Donwload ZIP** on this page or downlad from the [releases page](https://github.com/keerah/SendTo_FFmpeg/releases) to get all the scripts, its free forever.

Then you will need to [download the FFmpeg executables](https://ffmpeg.org/download.html#build-windows), it's free.

By default these scripts assume the path to FFmpeg.exe is **c:\Program Files\ffmpeg\bin**, so you can simply extract the downloaded ffmpeg archive into **c:\Program Files\ffmpeg**. If you install it into a different path, you will need to edit the path to **FFmpeg.exe** in the main settings file **sendtoffmpeg_settings.cmd**.

# Usage
You can use these batches in a few different ways:

## Drag-n-drop
Just drag your video over the corresponding **.bat** file icon.
You can drag files one by one, each will be encoded in a separate process, you can also select multiple files for any script except a few which mux external audio.

## Windows explorer's Send To menu
You can integrate these batches as commands into Windows' **Send To** menu (right click on any file in the Explorer).

For this you need to:

1. Put all of these batches to any convenient location (for example in cloud sync folder to have them synced for all machines). Find the file named **sendtoffmpeg_settings.cmd** and edit it to change the path to **FFmpeg** installation if it's different from **c:\Program Files\ffmpeg**.

2. Create the shortcuts for these files (Alt-drag them onto your Desktop for example). Then place these shortcuts into **C:\Users\[YOUR USER NAME]\AppData\Roaming\Microsoft\Windows\SendTo** folder.

3. Now you may want to rename these shortcuts to get rid of "Shortcut" in the names or to whatever you want, but do not change the **.lnk** extension. Then you have to clear the "Start In" field in each shortcut (this lets the scripts save output files next to your sources) by right clicking one after another and selecting Properties menu. Along with it you can also change the icon of the shortcuts ("Change Icon" button in the same Properties window), these icons will be displayed in the **Send To** menu.

That's all. You can right click on any file and navigate to **Send To**. You'll find your new preset items there. The corresponding **.bat** file will run ffmpeg to convert it and then will place the result into same folder with something like **_420_high.mp4** added to your filename.

## Shell

Use it in CMD or Powershell as usual.

# FFmpeg versions

Currently there's some kind of palette generation incompatibility (required for GIFs) with FFmpeg version 5+ branches.
While I am investigating this I recommend using the latest version 4+ branch instead. [These of version 4.4.3](https://github.com/BtbN/FFmpeg-Builds/releases/tag/autobuild-2022-10-10-12-40) for example.

# Notes

This works with Windows OS only. 

Each batch has a brief description of its functionality inside.

SendTo_FFmpeg has its global settings:

- Path to FFmpeg
- FFmpeg verbosity level
- Pause after encoding
- Descriptive naming

They affect all batches at once. You can change them by editing **sendtoffmpeg_settings.cmd**, their brief description is inside the file.

If you put a copy of **sendtoffmpeg_settings.cmd** into the folder with your source video files, the scripts will use these settings instead of the globals, this lets you use different settings for different folders.
