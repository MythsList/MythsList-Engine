# MythsList Engine Changelog

All notable changes will be documented in this file.

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