# MythsList Engine Changelog

All notable changes will be documented in this file.

## [V.1.1.1]
### Addition
- MP4 SUPPORT
- Added a new menu in the Options, giving you the ability to change the color of your arrows (Experimental)
- Added the option to Enable/Disable bot play
- Added StageSprite.hx for easier stage creation
- Recoded Stage.hx
- Added new achievements
- Added myself in the health icons lol

### Tweak
- Achievements menu's UI have been tweaked
- Better dialogue support (more automatized, now includes end dialogues)
- Inputs have been recoded once again for bot play and special notes
- Highscore system recoded (Tell me how to fix freeplay scores lol)
- Made it so it doesn't play the scroll sound when you enter a menu
- It is now easier to make difficulties (Everything is in CoolUtil.hx, have fun)
- New bf winning icon (Thanks zPablo)
- New winning icons
- When a dialogue starts, the camera will now always focus on gf or on the center of the screen
- When selecting a song in freeplay, you will now see the winning icon of this one character

### Bugfix
- Template's offsets are officially fixed
- Fixed gf's scared animation

### Improvement
- Cleaned code, once again (DialogueBox.hx, Portrait.hx, PlayState.hx, etc...)

### Removal
- WEBM support

## [V.1.1.0]
### Addition
- Added a Performance tab in the Options menu
- Added the option to Enable/Disable the background display in the new Options tab
- You can now save the offsets via the Animation Debug menu as a txt file
- The pause menu now shows the icon of the current player 2
- Added the "breakfast" track in the Animation Debug menu (Sorry, I checked a lot of Psych Engine's source code)

### Tweak
- Another massive code cleaning
- Discord rich presence now always show the difficulty
- Made HealthIcon.hx better (Code was inspired by Psych Engine's)
- HUD is now invisible when you enter a cutscene and/or dialogue
- Made portraits more customizable (You can now set the size of portraits instead of just using 540x540 everytime)
- When changing the player 1 via charting debug menu, the offsets should be better than before now
- Changed some icons to make them "better"
- Animation Debug menu's UI has been changed
- Title screen's button's pressed animation is now aligned with the idle animation
- Moved the Antialiasing option to the Options' Performance tab

### Bugfix
- Character selection menu or playable character deletion no longer makes the game crash (hopefully)
- Fixed the camera zoom permanently
- Charting debug menu's icons and missing vocals fixed
- Fixed multiple Animation Debug menu bugs
- Fixed inputs once again

### Removal
- Boyfriend can't be stunned anymore

## [V.1.0.9]
### Overhaul
- Made AchievementsSubState.hx modder friendly (Still needs coding knowledge)

### Addition
- Added AchievementsUnlock.hx to make it "easier" setting up your own achievement

### Tweak
- Massive code cleaning including : Character.hx, ChartingState.hx, AnimationDebug.hx and some other files

### Bugfix
- Fixed V.1.0.8's inputs counter crash

### Removal
- Removed more useless or unused stuff

## [V.1.0.8]
### Addition
- ADDED A WIKI ON THE GITHUB PAGE

- New rating system
- Inputs counter (Can be enabled via the Options menu)
- Readded the reset keybind and made the pause keybind work
- New folders so the game data is organized
- Week names and week colors are now in `assets/preload/data/WEEKDATA`
- (Not added) New character "corrupted boyfriend" in the character selection menu made by Artistmaybe (Will not be credited for now, will be when actually used)

### Tweak
- Dialogues, portraits and dialogue boxes are easier to use
- No separate menu characters yet but better MenuCharacter.hx code
- Made the charting debug menu a debug only feature to avoid people cheating on mods
- Removed the "Senpai" chart stacked note
- Some StoryMenuState.hx changes
- While disabling version display, song infos should go in the corner of the screen now
- GameOverSubstate.hx now checks for the current player1 instead of the current stage

### Bugfix
- I wonder why i haven't realized that yet but you couldn't hit "shits" so now you can hit them
- Voice in the Charting Debug menu now starts/resumes correctly
- Fixed week 6 death screen's OST (Game would crash)
- Fixed week 6 death screen's animation (Console would open with a warning, i hate warnings)
- We now check if boyfriend is dead before playing an animation
- Fixed week 3 camera

### Removal
- Removed the keybind (ONE) to skip a song
- Removed the gitaroo pause assets because I forgot

## [V.1.0.7]
### Overhaul
- You can now see the currently selected character (not just the health icon) inside of the Character Selection menu and you can check how the animations look like using the arrows

### Addition
- Added more portraits for you, modders

### Improvement
- Inputs have been improved once more
- GameplaySubState.hx code isn't a big code mess anymore (modder friendly? idk)
- "Better code" - MythsList

### Tweak
- In DialogueBox.hx, you can now choose how the BG will fade between a basic fade or a fade like the one from week 6, you can also add your custom fade if you know how to code
- Forgot to remove the note in the Outdated screen because of custom keybinds being a thing so now I did
- You can't choose the same keybind multiple times anymore in the Keybinds Options menu and added more keybinds in the blacklist

### Bugfix
- Combo now resets when you miss an arrow
- Week 6 camera zoom fixed (maybe?)
- Playing as other non-playable characters now flip the animations correctly
- Playing as other non-playable characters will now have their health icon instead of the currently selected character's health icon
- Week 2 monster up animation offset fixed
- Fixed the confirm sound seizure in the Keybinds Options menu
- Fixed story menu tracks not appearing after finishing a week

### Removal
- Removed unused txt files (Please don't tell me they are used somewhere, i deleted the code)

## [V.1.0.6]
### Addition
- Special arrows support (Feature hasn't been tested, please report bugs on the Discord server in #bug-reports or literally in my DMs)
- Reworked the controls options menu : Custom keybinds (Same thing lol but I got to test it a bit atleast)
- Added Stage.hx (Might be an useless feature but it's there)

### Tweak
- Replaced "old" monster with "new" monster (Using CVal's spritesheet)
- Week 3's background lights now use white lights then change color using code instead of changing the asset (Was changed due to the Stage.hx addition)
- Week 6's second song in the freeplay menu now uses the angry senpai health icon (I forgor 💀)

### Improvement
- Removed duplicated code and useless code

## [V.1.0.5.1]
### Addition
- Added the Discord server on the GameBanana page

### Tweak
- Easier way to add trails to a character like "spirit" (Thanks Astr0verload)
- Animation Debug minor changes

### Bugfix
- Removing character selection then playing a song while having data from that menu no longer causes crashes (Haven't tested but hopefully it works)
- Mouse still appearing after closing the chart debug menu fixed

## [V.1.0.5]
### Overhaul
- Better chart debug menu

### Tweak
- GF now has an actual losing icon
- Discord rich presence now tells exactly on which menu you are (now other people can spy on you haha)
- You can now press ESCAPE while being in-game to enable/disable the fullscreen (It's a bit meh but it works)

### Bugfix
- Pixel arrows now use a XML to avoid the "no animation called..." errors
- Made it so after an animated dialogue box open they don't make an error "no animation called..." pop up
- Main menu song stops playing when entering a cutscene so it still doesn't play after the cutscene finishes playing

### Improvement
- PlayState code has been a bit improved
- CharacterSelectionSubState code has been a bit improved (It is now Modder friendly)

### Removal
- Removed OptionsMenu.hx because it was unused, we already have OptionsSubState.hx for that
- Removed GitarooPause.hx because it was also unused
- Removed ButtonRemapSubstate because it was also unused

## [V.1.0.4]
### Addition
- Added WEBM cutscene support (Haven't really tested it, let me know if there're bugs with it (Watch bbpanzu's tutorial to know how to use it))
- The dialogue system now supports the "middle" option, it will basically show both left and right portrait (How to use it : in the txt file add "bf/bf" instead of "bf", the / separates the character portraits)
- Added "rhys" into the Character Selection menu

### Tweak
- README.md now have the new informations to help you compile the engine with WEBM support

### Bugfix
- Added the library to pretty much all current assets mentioned in the code so it doesn't show the funny HaxeFlixel placeholder logo

## [V.1.0.3]
### Addition
- Added an option to enable/disable the song position bar
- Added an option to enable/disable ghost tapping
- Added an option to enable/disable antialiasing (Only affects the gameplay, not menus)

### Tweak
- FPS cap got increased to 90
- Changed the UI of the week selection
- Achievements now have a name
- You can now press backspace or esc to exit the animation debug menu

### Removal
- Pressing F while being on the title screen no longer fullscreen
- Removed some Newgrounds related stuff because it's useless 

## [V.1.0.2]
### Addition
- Almost all characters now have a winning icon and some characters now have a losing icon (Thanks zPablo)
- Added a BF portrait for an example of what you can do with dialogues (it comes with an unused txt file in the tutorial folder)
- Added an option to fullscreen in the Options Gameplay tab
- Added an option to exit to the Options menu via the Pause menu

### Tweak
- Dialogue system now also supports 540x540 portraits with 100x100 portraits
- "Template" character offsets are now correct (kinda) 
- Slightly changed inputs

### Bug fix
- Fixed week locks

### Improvement
- Better code for the Story menu (Thanks BitDev)

## [V.1.0.1]
### Overhaul
- New Dialogue system (some changes will be made in V.1.0.2)

### Addition
- 2 new Characters in the Character Selection Menu (Brody Foxx and Template)

### Tweak
- Old Boyfriend's Health Icon is now centered

### Improvement
- Some code improvements for the gameplay

## [V.1.0.0]
### Addition
- The whole ass engine with all it's changes.