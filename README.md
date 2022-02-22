# Description
This is a set of Windows **batch** scripts for effortless transcoding videos using the free **FFmpeg** tool. It is a set of tools I develop mainly for myself and it saves me tons of time in every day work.

![menu img](https://i.imgur.com/1SOp2wO.png "SendTo_FFmpeg presets in the standard windows Send To menu")

Click "Clone or donwload" on this page to get all the scripts, its free forever.
First you need to download **FFmpeg** itself from [here](https://www.ffmpeg.org/download.html), it's free.
Install it (extract), by default its path is **c:\Program Files\ffmpeg**. If you install it into a different path than this, you will need to edit the path to **FFmpeg.exe** in the main settings file **sendtoffmpeg_settings.cmd**. There're more parameters inside with description.

# Usage
You can use these batches in a few different ways:

## Drag-n-drop
Just drag your video over the corresponding **.bat** file icon.
You can drag files one by one, each will be encoded in a separate process, you can also select multiple files for any script except a few which mux external audio.

## Windows explorer's Send To menu
You can integrate these batches as commands into Windows' **Send To** menu (right click on any file in the Explorer).

For this you need:

1. Put all of these batches to any convenient location (I use my cloud sync folder to have these presets on all machines). Find the file named **sendtoffmpeg_settings.cmd** and edit it to change the path to **FFmpeg** installation if it's different from **c:\Program Files\ffmpeg**. You can also change here a few other settings for all scripts at once.

2. Create the shortcuts for these files (Alt drag). Place these shortcuts into **%userprofile%/SendTo** or on Windows 10 into **C:\Users\[YOUR USER NAME]\AppData\Roaming\Microsoft\Windows\SendTo**

3. Rename these shortcuts to get rid of "Shortcut" in the names or to whatever you want, but do not change the **.lnk** extension. Now you will need to clear the "Start In" field in each of them (this lets the scripts save output files next to your sources) by right clicking one after another and selecting Properties menu. Along with it you can also change the icon of the shortcuts ("Change Icon" button in the same Properties window), these icons will be displayed in the **Send To** menu.

4. So basically you just did it. Now you can right click on any file and navigate to **Send To** item.
You'll find your new preset item there. The corresponding **.bat** file will run ffmpeg to convert it
and then will place the result into same folder with something like **_420_high.mp4** added to your filename.

## Shell

Use it in CMD or Powershell as usual.

# Notes

This works with Windows OS only. 

Each batch has a brief description of its functionality inside. SendTo_FFmpeg has its global settings: Path to FFmpeg, FFmpeg verbosity level, pause after encoding, and descriptive naming. They affect all batches at once. You can change them by editing **sendtoffmpeg_settings.cmd**, their brief description is inside the file. If you put a copy of **sendtoffmpeg_settings.cmd** into the folder with your source video files, the scripts will use these settings instead of the globals, this lets you use different settings for different folders.
