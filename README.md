# sendto_ffmpeg
This is a set of Windows batch scripts for converting video effortlessly using free ffmpeg tool

First you need download FFMPEG itself from here, it's free.
Install it, usually it's path to c:\Program Files\ffmpeg

You can use these batches in a few different ways:

##WAY 1
Just drag your video over the .bat file icon to start

OR

##WAY 2
You can integrate these batches as commands right into Windows Send To menu (right click on any file)
For this you need:

1. Put these batches to any convenient location for your presets (or use your cloud sync folder to have same presets on all your machines)
Edit them if your FFMPEG installation is different from c:\Program Files\ffmpeg

2. Create the shortcuts for these files (drag + Alt) or use the attached examples in Link files folder of this archive (but change the links inside their properties).
Place these shortcuts into %userprofile%/SendTo or on Windows 10 into C:\Users\[YOUR USER NAME]\AppData\Roaming\Microsoft\Windows\SendTo

3. Rename these shortcuts to get rid of "Shortcut" in the names or to whatever you want, but do not change the .lnk extension.
You can also change the icon of the shortcuts in their file properties, these icons will be displayed in the Send To menu.

4. So basically you just did it. Now you can right click on any file and navigate to Send To item.
You'll find your new preset item there. The corresponding .bat file will run ffmpeg to convert whatever you clicked to mp4 h264 video
and it will place it into same folder with _output added to your filename.

Source and more info at https://keeraah.blogspot.com/2018/02/ffmpeg-lifehack-1.html
Also check out my other posts, I update this batch set constantly

