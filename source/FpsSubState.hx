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

using StringTools;

/*
UNUSED FILE
*/

class FpsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['FPS Cap'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var EnabledFpsCap:Bool = false;

	var grpOptions:FlxTypedGroup<Alphabet>;

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

		// selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		// add(selector);

		for (i in 0...textMenuItems.length)
		{
			// var optionText:FlxText = new FlxText(0, 20 + (i * 50), 0, textMenuItems[i], 32);

			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptions.add(optionText);
		}

		var versionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "V.1 - DEMO", 12);
		versionText.scrollFactor.set();
		versionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.LEFT_P)
			if (EnabledFpsCap)
			{
				changeFpsCap(-1);
			}

		if (controls.RIGHT_P)
			if (EnabledFpsCap)
			{
				changeFpsCap(1);
			}

		if (controls.BACK)
		{
			FlxG.switchState(new OptionsSubState());
		}

		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "FPS Cap":
					if (EnabledFpsCap)
					{
						EnabledFpsCap = false;
						/*
						for (item in grpOptions.members)
						{
							item[curSelected].color = FlxColor.WHITE;
							item[curSelected].text = "FPS Cap";
						}
						*/
					}
					else if (!EnabledFpsCap)
					{
						EnabledFpsCap = true;
						/*
						for (item in grpOptions.members)
						{
							item[curSelected].color = FlxColor.YELLOW;
						}
						*/
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

	function changeFpsCap(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = 4 - 1;
		if (curSelected >= 4)
			curSelected = 0;

		switch(curSelected)
			{
				case 0:
					FlxG.save.data.fpsCap = 60;
					FlxG.save.flush();
				case 1:
					FlxG.save.data.fpsCap = 120;
					FlxG.save.flush();
				case 2:
					FlxG.save.data.fpsCap = 180;
					FlxG.save.flush();
				case 3:
					FlxG.save.data.fpsCap = 240;
					FlxG.save.flush();
			}
		/*
		for (item in grpOptions.members)
		{
			item[curSelected].text = "FPS Cap" + FlxG.save.data.fpsCap;
		}
		*/
		// FlxG.save.data.fpsCap = Application.current.window.displayMode.refreshRate;
	}
}