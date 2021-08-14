package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'storymode',
		'freeplay',
		'options'
	];

	override function create()
	{
		/*
		Added that shit so it doesn't crash saying "null object reference".
		Basically set any null data to the default value.

		Only will work the first time you launch the game 
		Or after you clicked on the "Reset data" button in the Options menu.

		if (FlxG.save.data.keyBinds == null)
			FlxG.save.data.keyBinds = 'SDKL';

		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.statsDisplay == null)
			FlxG.save.data.statsDisplay = true;
		if (FlxG.save.data.songinfosDisplay == null)
			FlxG.save.data.songinfosDisplay = true;
		if (FlxG.save.data.versionDisplay == null)
			FlxG.save.data.versionDisplay = true;

		if (FlxG.save.data.characterSkin == null)
			FlxG.save.data.characterSkin = 'bf';

		if (FlxG.save.data.dataCategoryOne == null)
			FlxG.save.data.dataCategoryOne = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryTwo == null)
			FlxG.save.data.dataCategoryTwo = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree == null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree == null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];

		if (FlxG.save.data.fcAmount == null)
			FlxG.save.data.fcAmount = 0;
		if (FlxG.save.data.playAmount == null)
			FlxG.save.data.playAmount = 0;
		if (FlxG.save.data.deathAmount == null)
			FlxG.save.data.deathAmount = 0;

		MythsListEngineData.keyBinds = FlxG.save.data.keyBinds;

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataCategoryOne = FlxG.save.data.dataCategoryOne;
		MythsListEngineData.dataCategoryTwo = FlxG.save.data.dataCategoryTwo;
		MythsListEngineData.dataCategoryThree = FlxG.save.data.dataCategoryThree;

		MythsListEngineData.fcAmount = FlxG.save.data.fcAmount;
		MythsListEngineData.playAmount = FlxG.save.data.playAmount;
		MythsListEngineData.deathAmount = FlxG.save.data.deathAmount;


		FlxG.save.flush();

		End of the data saving mess
		*/

		MythsListEngineData.dataLoad();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);

		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;

		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 90 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);

			menuItems.add(menuItem);

			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var engineversionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionShit.scrollFactor.set();
		engineversionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineversionShit);

		var versionShit:FlxText = new FlxText(5, engineversionShit.y - engineversionShit.height, 0, MythsListEngineData.modVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;

				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							switch(optionShit[curSelected])
							{
								case 'storymode':
									FlxG.switchState(new StoryMenuState());
								case 'freeplay':
									FlxG.switchState(new WeekselectState());
								case 'donate':
								{
									#if linux
									Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
									#else
									FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
									#end
								}
								case 'options':
									FlxG.switchState(new OptionsSubState());
							}
						});
					}
				});
			}
		}
		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(change:Int = 0)
	{
		curSelected += change;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
