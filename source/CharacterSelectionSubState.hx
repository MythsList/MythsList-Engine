package;

import Controls;
import Controls.Control;
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

class CharacterSelectionSubState extends MusicBeatSubstate
{
	// ADD YOUR SKIN FIRST IN CHARACTER.HX AND CHARACTERLIST.TXT!

	/*
	textMenuItems contain the character names.
	(has nothing to do with Character.hx and characterlist.txt, it's just for the button names)

	Icons contain the health icons of your characters.
	(Related to HealthIcon.hx and Character.hx, would recommend putting your character's name in like I did)
	*/

	var textMenuItems:Array<String> = [
		'Boyfriend',
		'Minus Boyfriend',
		'Beta Boyfriend',
		'Old Boyfriend',
		'Brody Foxx',
		'Template'
	];

	var Icons:Array<String> = [
		'bf',
		'bf-minus',
		'bf-old',
		'bf-veryold',
		'brody-foxx',
		'template'
	];

	var selector:FlxSprite;

	var curIcon:HealthIcon;
	var curIconText:FlxText;
	var curBGtext:FlxText;

	var curSelected:Int = 0;

	var grpOptions:FlxTypedGroup<Alphabet>;
	var iconArray:Array<HealthIcon> = [];

	public function new()
	{
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
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

			if (MythsListEngineData.characterSkin == Icons[i])
				optionText.color = FlxColor.GREEN;
			else if (MythsListEngineData.characterSkin != Icons[i])
				optionText.color = FlxColor.RED;

			grpOptions.add(optionText);

			var icon:HealthIcon = new HealthIcon(Icons[i]);
			icon.sprTracker = optionText;

			iconArray.push(icon);
			add(icon);
		}

		var curBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 4), 10 + 26 + 150 + 16, 0xFF000000);
		curBG.alpha = 0.25;
		add(curBG);

		curBG.x = FlxG.width - curBG.width;

		curBGtext = new FlxText(curBG.x + 5, curBG.y + 5, 0, "Currently Selected :", 26);
		curBGtext.scrollFactor.set();
		curBGtext.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		add(curBGtext);

		curIcon = new HealthIcon(MythsListEngineData.characterSkin);
		curIcon.x = curBGtext.x;
		curIcon.y = curBGtext.y + curBGtext.height;
		add(curIcon);

		// ADD YOUR CHARACTER NAME IN A NEW CASE AND REPLACE THE NUMBER IN 'textMenuItems[0]' BY WHATS AFTER THE LAST NUMBER

		switch(MythsListEngineData.characterSkin)
		{
			case 'bf':
				curIconText = new FlxText(0, 0, 0, textMenuItems[0], 16);
			case 'bf-minus':
				curIconText = new FlxText(0, 0, 0, textMenuItems[1], 16);
			case 'bf-old':
				curIconText = new FlxText(0, 0, 0, textMenuItems[2], 16);
			case 'bf-veryold':
				curIconText = new FlxText(0, 0, 0, textMenuItems[3], 16);
			case 'brody-foxx':
				curIconText = new FlxText(0, 0, 0, textMenuItems[4], 16);
			case 'template':
				curIconText = new FlxText(0, 0, 0, textMenuItems[5], 16);
		}

		curIconText.x = curBGtext.x;
		curIconText.y = curIcon.y + curIcon.height;
		curIconText.scrollFactor.set();
		curIconText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		add(curIconText);

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
			interact(curSelected);

			var curItem:Int = 0;

			for (item in grpOptions.members)
			{
				if (MythsListEngineData.characterSkin == Icons[curSelected] && curSelected == curItem)
					item.color = FlxColor.GREEN;
				else if (MythsListEngineData.characterSkin != Icons[curSelected] && curSelected != curItem)
					item.color = FlxColor.RED;
				else
					item.color = FlxColor.RED;

				curItem += 1;
			}

			remove(curIcon);
			curIcon = new HealthIcon(MythsListEngineData.characterSkin);
			curIcon.x = curBGtext.x;
			curIcon.y = curBGtext.y + curBGtext.height;
			add(curIcon);

			remove(curIconText);

			switch(MythsListEngineData.characterSkin)
			{
				case 'bf':
					curIconText = new FlxText(0, 0, 0, textMenuItems[0], 16);
				case 'bf-minus':
					curIconText = new FlxText(0, 0, 0, textMenuItems[1], 16);
				case 'bf-old':
					curIconText = new FlxText(0, 0, 0, textMenuItems[2], 16);
				case 'bf-veryold':
					curIconText = new FlxText(0, 0, 0, textMenuItems[3], 16);
				case 'brody-foxx':
					curIconText = new FlxText(0, 0, 0, textMenuItems[4], 16);
				case 'template':
					curIconText = new FlxText(0, 0, 0, textMenuItems[5], 16);
			}

			curIconText.x = curBGtext.x;
			curIconText.y = curIcon.y + curIcon.height;
			curIconText.scrollFactor.set();
			curIconText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);

			add(curIconText);
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

	function interact(selected:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		FlxG.save.data.characterSkin = Icons[selected];
		FlxG.save.flush();

		MythsListEngineData.dataSave();
	}
}