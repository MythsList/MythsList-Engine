# MythsList Engine

This is the GitHub repository for **MythsList Engine**.

[![GitHub issues](https://img.shields.io/github/issues/MythsList/MythsList-Engine)](https://github.com/MythsList/MythsList-Engine/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/MythsList/MythsList-Engine)](https://github.com/MythsList/MythsList-Engine/pulls)
![GitHub repo size](https://img.shields.io/github/repo-size/MythsList/MythsList-Engine)
![GitHub](https://img.shields.io/github/license/MythsList/MythsList-Engine)

## Building Instructions

### Downloading the Required Programs

Follow all of the steps here so you can proceed to the next section:

1. Download [Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Downloading the most recent version (4.2.0) is NOT recommended at all, you must download the version 4.1.5)
2. Download [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)
3. Download [git-scm](https://git-scm.com/downloads)
4. Open Powershell as administrator or cmd.exe and enter those commands (after you did the 3 steps above):
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
```

You should have everything ready for compiling the game, you can continue your building now!

------

### Installing the Required Programs for Certain Devices

- For **Windows** devices, you have to install [Visual Studio Community 2019](https://visualstudio.microsoft.com/en/vs/community/). While installing the required program, do not click on any of the options to install workloads but instead, go to the "individual components" tab and choose the following components below (THEY MUST BE INSTALLED OR ELSE YOU WON'T BE ABLE TO COMPILE THE GAME):

```
MSVC v141 - VS 2017 C++ x64/x86 build tools
MSVC v142 - VS 2019 C++ x64/x86 build tools
Windows SDK (10.0.17763.0)
C++ Profiling tools
C++ CMake tools for windows
C++ ATL for v142 build tools (x86 & x64)
```

Make sure you have more than 7GB on your computer before installing those components.

- For **MacOS** devices, you have to install [Xcode](https://developer.apple.com/xcode/). If you get any error, try installing an older version of the program.

------

### Compiling the Game

Once you have **all** of those installed (Required programs for All devices and required VSC components for Windows devices), it's now pretty easy to compile the game. You just need to run one of the commands below (First command is recommended if you want to have the HaxeFlixel console activated and FNF's debugging features but if you want to play the game without them then the second command is most likely to be used):

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

All Devices
```
lime test html5 -debug
lime test html5 -release
lime test html5 -32bit
```

After you entered one of those commands, powershell/cmd.exe will take a while before exporting all of the source code's assets, depending on your computer's performance it can take up to a whole hour because it is like downloading a game, it's a pretty large file to process so I suggest you to do something else while Friday Night Funkin' is exporting.

Once it is done, have fun with the engine!

## Contact

- Discord - 52#9242
- [Twitter](https://twitter.com/mythslist)
- [GameBanana](https://gamebanana.com/members/1947708)
- [Roblox](https://www.roblox.com/users/851155547/profile) (why not?)
- [E-mail](mailto:mythslistofficial@gmail.com)

## Credits

### MythsList Engine

- [MythsList](https://twitter.com/mythslist) - Basically everything

### Friday Night Funkin'

- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) - Artist
- [Evilsk8r](https://twitter.com/evilsk8r) - Artist
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician