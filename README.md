# Description
This is a set of Windows **batch** scripts for effortless video transcoding using the free **FFmpeg** tool. This is a set of tools I develop mainly for myself and it saves me tons of time in every day work.

![send_to_ffmpeg](https://user-images.githubusercontent.com/9025818/155185990-32fec47d-e557-4a2f-a412-49f2f9a57f3d.jpg "SendTo_FFmpeg presets in the Windows Explorer's Send To menu")

First click **Code** -> **Donwload ZIP** on this page or downlad from the [releases page](https://github.com/keerah/SendTo_FFmpeg/releases) to get all the scripts, its free forever. Or get it from the [Releases page](https://github.com/keerah/SendTo_FFmpeg/releases).

Then you will need to [download the FFmpeg executables](https://ffmpeg.org/download.html#build-windows), it's free.

By default these scripts assume the path to FFmpeg.exe is **c:\Program Files\ffmpeg\bin**, so you can simply extract the downloaded ffmpeg archive into **c:\Program Files\ffmpeg**. If you place ffmpeg into a different folder, you will need to edit the path to **FFmpeg.exe** in the main settings file **sendtoffmpeg_settings.cmd**.

# Usage
You can use these batches in a few different ways:

## Drag-n-drop
Just drag your files over the corresponding **.bat** file icon. You can drag files one by one, each will be encoded in a separate process, you can also select multiple files for any script except a couple.

## Windows explorer's Send To menu
You can integrate these batches as commands into Windows' **Send To** menu (right click on any file in the Explorer).

For this you need to:

1. Put all of these batches to any convenient location (for example in cloud sync folder to have them synced for all machines). Find the file named **sendtoffmpeg_settings.cmd** and edit it to change the path to **FFmpeg** installation if it's different from **c:\Program Files\ffmpeg**.

2. Create the shortcuts for these files (Alt-drag them onto your Desktop for example). Then place these shortcuts into **C:\Users\[YOUR USER NAME]\AppData\Roaming\Microsoft\Windows\SendTo** folder.

3. Now you may want to rename these shortcuts to get rid of "Shortcut" in the names or to whatever you want, but do not change the **.lnk** extension. Then you have to clear the "Start In" field in each shortcut (this lets the scripts save output files next to your sources) by right clicking one after another and selecting Properties menu. Along with it you can also change the icon of the shortcuts ("Change Icon" button in the same Properties window), these icons will be displayed in the **Send To** menu. This takes time, but a backup of those will serve you well later.

That's all. Now you can right click on any file, navigate to **Send To** and select one of the presets there. The corresponding **.bat** file will do the rest and will place the result into the same folder with something like **_420_high.mp4** added to your filename (if descriptive names option is still on).

## Shell

Use it in CMD or Powershell as usual.

# More features

## Compatibility

This works with Windows OS only. 

## Other cool features

SendTo_FFmpeg has its global settings, that you can read more about in the sendtoffmpeg_settings.cmd file. They affect all presets at once. You can change them by simply editing **sendtoffmpeg_settings.cmd** in a text editor.

But you can have very different settings for your current (and any other) folder by making a copy of **sendtoffmpeg_settings.cmd** in that folder. All parameters you change in it will affect only the files that are transcoded here. It can be the framerate setting, or descriptive naming flag or even the path to FFMpeg itself, so you can use different versions for different cases.

## Image sequence transcoding

Available since Release 3.0. To transcode an image sequence you need to select the first file of the sequence. There's a limitation for now, it cant be frame with number 0 (or 0000). This frame will be the starting point of the output video. Be cautious when transcoding images that are part of a detectable sequence, you may end up with a bunch of sequences on your hands :)
