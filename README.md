# MythsList Engine

This is the GitHub repository for MythsList Engine.

[![GitHub issues](https://img.shields.io/github/issues/MythsList/MythsList-Engine)](https://github.com/MythsList/MythsList-Engine/issues) [![GitHub pull requests](https://img.shields.io/github/issues-pr/MythsList/MythsList-Engine)](https://github.com/MythsList/MythsList-Engine/pulls)
---
![GitHub repo size](https://img.shields.io/github/repo-size/MythsList/MythsList-Engine) ![Lines of code](https://img.shields.io/tokei/lines/github/MythsList/MythsList-Engine)
---
![GitHub](https://img.shields.io/github/license/MythsList/MythsList-Engine)

## Building Instructions

### Downloading the Required Programs

Follow all of the steps here so you can proceed to the next section:

1. Download [Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Downloading the most recent version (4.2.0) is NOT recommended at all, you must download the version 4.1.5)
2. Download [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)
3. Download [git-scm](https://git-scm.com/downloads)
4. In powershell or cmd.exe, enter those commands (after you did the 3 steps above):
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
```

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Enter the command `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in powershell/cmd.exe.

You should have everything ready for compiling the game! Follow the section below to continue with the building!

------

### Downloading the Required Programs for Certain Devices

- For **Windows**, you have to install [Visual Studio Community 2019](https://visualstudio.microsoft.com/en/vs/community/). While installing the program, do not click on any of the options to install workloads but instead, go to the "individual components" tab and choose the following components below (THEY MUST BE INSTALLED OR ELSE YOU WON'T BE ABLE TO COMPILE):

```
MSVC v141 - VS 2017 C++ x64/x86 build tools
MSVC v142 - VS 2019 C++ x64/x86 build tools
Windows SDK (10.0.17763.0)
C++ Profiling tools
C++ CMake tools for windows
C++ ATL for v142 build tools (x86 & x64)
```

Make sure you have over than 7GB on your computer before installing those components.

- For **MacOS**, you have to install [Xcode](https://developer.apple.com/xcode/). If you get any error, try installing an older version.

------

### Compiling the Game

Once you have **all** of those installed (Required programs for All devices and required VSC components for Windows devices), it's now pretty easy to compile the game. You just need to run one of the commands below (First command is recommended if you want to have the HaxeFlixel console activated and FNF's debugging features but if you want to play it without them then the second command is recommended):

#### Desktop

Windows
```
lime test windows -debug
lime test windows -release
lime test windows -32bit
```
Linux
```
lime test linux -debug
lime test linux -release
lime test linux -32bit
```
Mac
```
lime test mac -debug
lime test mac -release
lime test mac -32bit
```

#### Browser

All
```
lime test html5 -debug
lime test html5 -release
lime test html5 -32bit
```

After you entered one of those commands, powershell/cmd will take a while before exporting all of the source code's assets, depending on your computer's performance it can take up to 1 whole hour so I suggest doing something else while it is exporting.

## Credits

### MythsList Engine

- [MythsList](https://twitter.com/mythslist) - Basically everything

### Friday Night Funkin'

- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) - Art
- [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician