- this is not packaged, so you have to unzip to a writeable folder
- you can open and edit the ```digiQclock.qml``` file (mostly for colors or change the font)
- you will need to have installed these Qt libs (should work if you've installed my latest HiQDock package from github (https://github.com/hey68you/hiqdock-distro) or from BeSly 64 repo (http://software.besly.de/repo64):
- ```
    lib:libqt6core >= 6.7.2
    lib:libqt6network >= 6.7.2
    lib:libqt6Qml >= 6.7.2
    lib:libqt6gui >= 6.7.2
    lib:libqt6openGL >= 6.7.2
	lib:libqt6quick >= 6.7.2
	lib:libqt6widgets >= 6.7.2
	lib:libqt6quickwidgets >= 6.7.2
- now supports command line args for config:
```
> ./DigiQClock --help
qml: 
The following CLI parameters may be passed when running from the command line:

--fg           ===> font color: friendly color names or hex string with # notation e.g. '#73D292' or 'green' - qoutes are required when using hex
--bg-start     ===> background start gradient color (same format as --fg parameter)
--bg-end       ===> background end gradient color (if you don't want gradient make sure to pass same value that you passed for --bg-start)
--offset-hours ===> e.g. for different time-zones (use minus sign or just plain number for forward e.g. '--offset-hours -3' or '--offset-hours 5')
--win-title    ===> use quotes for titles with spaces e.g. --win-title 'Los Angeles')
--no-italics   ===> only need to add this flag (default is using italic font)
--24hrs        ===> only need to add this flag (default is 12hr AM/PM implied )

Here's a full example:

> ./DigiQClock --fg '#000000' --bg-start lightblue --bg-end lightblue --offset-hours -3 --win-title 'Los Angeles' --no-italics --24hrs


