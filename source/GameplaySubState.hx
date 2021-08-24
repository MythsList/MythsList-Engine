package;

import lime.app.Application;
import Controls.Control;
import Main;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flash.text.TextField;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import lime.utils.Assets;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class GameplaySubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [
		'Downscroll',
		'Middlescroll',
		'Ghost tapping',
		'Stats display',
		'Song infos display',
		'Version display',
		'Song position display',
		'Antialiasing',
		'Fullscreen'
	];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		menuBG.color = 0xFF71fd89;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;

			switch(textMenuItems[i])
			{
				case 'Downscroll':
					if (FlxG.save.data.downScroll)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.downScroll)
						optionText.color = FlxColor.RED;
				case 'Middlescroll':
					if (FlxG.save.data.middleScroll)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.middleScroll)
						optionText.color = FlxColor.RED;
				case 'Ghost tapping':
					if (FlxG.save.data.ghostTapping)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.ghostTapping)
						optionText.color = FlxColor.RED;
				case 'Stats display':
					if (FlxG.save.data.statsDisplay)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.statsDisplay)
						optionText.color = FlxColor.RED;
				case 'Song infos display':
					if (FlxG.save.data.songinfosDisplay)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.songinfosDisplay)
						optionText.color = FlxColor.RED;
				case 'Version display':
					if (FlxG.save.data.versionDisplay)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.versionDisplay)
						optionText.color = FlxColor.RED;
				case 'Song position display':
					if (FlxG.save.data.songpositionDisplay)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.songpositionDisplay)
						optionText.color = FlxColor.RED;
				case 'Antialiasing':
					if (FlxG.save.data.antiAliasing)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.save.data.antiAliasing)
						optionText.color = FlxColor.RED;
				case 'Fullscreen':
					if (FlxG.fullscreen)
						optionText.color = FlxColor.GREEN;
					else if (!FlxG.fullscreen)
						optionText.color = FlxColor.RED;
			}

			grpOptions.add(optionText);
		}

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		var modversionText:FlxText = new FlxText(5, engineversionText.y - engineversionText.height, 0, MythsListEngineData.modVersion, 12);
		modversionText.scrollFactor.set();
		modversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(modversionText);

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.BACK)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new OptionsSubState());
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

			switch (textMenuItems[curSelected])
			{
				case "Downscroll":
					if (FlxG.save.data.downScroll)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.downScroll)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Middlescroll":
					if (FlxG.save.data.middleScroll)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.middleScroll)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Ghost tapping":
					if (FlxG.save.data.ghostTapping)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.ghostTapping)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Stats display":
					if (FlxG.save.data.statsDisplay)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.statsDisplay)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Song infos display":
					if (FlxG.save.data.songinfosDisplay)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.songinfosDisplay)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Version display":
					if (FlxG.save.data.versionDisplay)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.versionDisplay)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Song position display":
					if (FlxG.save.data.songpositionDisplay)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.songpositionDisplay)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case "Antialiasing":
					if (FlxG.save.data.antiAliasing)
					{
						interact(false, curSelected);
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
					else if (!FlxG.save.data.antiAliasing)
					{
						interact(true, curSelected);
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
				case 'Fullscreen':
					if (!FlxG.fullscreen)
					{
						FlxG.fullscreen = true;
						grpOptions.members[curSelected].color = FlxColor.GREEN;
					}
					else if (FlxG.fullscreen)
					{
						FlxG.fullscreen = false;
						grpOptions.members[curSelected].color = FlxColor.RED;
					}
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}

	function interact(change:Bool = true, selected:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		switch(change)
		{
			case true:
				switch(selected)
				{
					case 0:
						FlxG.save.data.downScroll = true;
					case 1:
						FlxG.save.data.middleScroll = true;
					case 2:
						FlxG.save.data.ghostTapping = true;
					case 3:
						FlxG.save.data.statsDisplay = true;
					case 4:
						FlxG.save.data.songinfosDisplay = true;
					case 5:
						FlxG.save.data.versionDisplay = true;
					case 6:
						FlxG.save.data.songpositionDisplay = true;
					case 7:
						FlxG.save.data.antiAliasing = true;
				}
			case false:
				switch(selected)
				{
					case 0:
						FlxG.save.data.downScroll = false;
					case 1:
						FlxG.save.data.middleScroll = false;
					case 2:
						FlxG.save.data.ghostTapping = false;
					case 3:
						FlxG.save.data.statsDisplay = false;
					case 4:
						FlxG.save.data.songinfosDisplay = false;
					case 5:
						FlxG.save.data.versionDisplay = false;
					case 6:
						FlxG.save.data.songpositionDisplay = false;
					case 7:
						FlxG.save.data.antiAliasing = false;
				}
		}

		FlxG.save.flush();

		MythsListEngineData.dataSave();
	}
}