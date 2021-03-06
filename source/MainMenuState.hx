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
		FlxG.mouse.visible = false;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Main Menu", null);
		#end

		MythsListEngineData.dataSave();

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu', 'preload'));

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG', 'preload'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);

		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat', 'preload'));
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

		var tex = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets', 'preload');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 90 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + ' basic', 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + ' white', 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);

			menuItems.add(menuItem);

			menuItem.scrollFactor.set();
			menuItem.antialiasing = MythsListEngineData.menuAntialiasing;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var engineversion:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversion.scrollFactor.set();
		engineversion.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineversion);

		changeItem(0);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!selectedSomethin)
		{
			if (controls.UP_P)
				changeItem(-1);

			if (controls.DOWN_P)
				changeItem(1);

			if (controls.ACCEPT)
			{
				selectedSomethin = true;

				FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
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
									Sys.command('/usr/bin/xdg-open', ['https://ninja-muffin24.itch.io/funkin', '&']);
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
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

		curSelected += change;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		else if (curSelected < 0)
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
