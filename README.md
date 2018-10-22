# sendto_ffmpeg
This is a set of Windows **batch** scripts for effortless converting/transcoding videos using the free **FFmpeg** tool.
First you need to download **FFmpeg** itself from [here](https://www.ffmpeg.org/download.html), it's free.
Install it, by default its path is **c:\Program Files\ffmpeg**
If you install it into a different path than this,
you will need to edit the path to **FFmpeg.exe** inside each of the bat files.

You can use these batches in a few different ways:

## 1st way
Just drag your video over the corresponding **.bat** file icon.
You can drag files one by one, each will be encoded in a separate process.
By now only the **Gif** bat supports multiple files at once.

## 2nd way
You can integrate these batches as commands into Windows' **Send To** menu (right click on any file in the Explorer).

For this you need:

1. Put these batches to any convenient location (or use your cloud sync folder to have these presets on all your machines)
Edit them if your **FFmpeg** installation is different from **c:\Program Files\ffmpeg**.

2. Create the shortcuts for these files (Alt drag). Place these shortcuts into **%userprofile%/SendTo** or on Windows 10 into **C:\Users\[YOUR USER NAME]\AppData\Roaming\Microsoft\Windows\SendTo**

3. Rename these shortcuts to get rid of "Shortcut" in the names or to whatever you want, but do not change the **.lnk** extension.
You can also change the icon of the shortcuts in their file properties, these icons will be displayed in the **Send To** menu.

4. So basically you just did it. Now you can right click on any file and navigate to **Send To** item.
You'll find your new preset item there. The corresponding **.bat** file will run ffmpeg to convert it
and then will place the result into same folder with **__output** added to your filename.

## 3rd way

Use it in CMD or Powershell as usual.


Each batch has a brief description of its functionality in its REM section.

You can visit my [blog](https://keeraah.blogspot.com/2018/02/ffmpeg-lifehack-1.html) for more info.
I update this batch set regularly.
