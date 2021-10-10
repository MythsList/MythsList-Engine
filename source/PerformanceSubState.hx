package;

#if desktop
import Discord.DiscordClient;
#end
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

class PerformanceSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [
		'Background display',
		'Antialiasing'
	];

	var dataStuff:Array<Bool> = [];

	var curSelected:Int = 0;

	var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		super();

		#if desktop
			DiscordClient.changePresence("In The Performance Options Menu", null);
		#end

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

			getDataList();

			if (dataStuff[i])
				optionText.color = FlxColor.GREEN;
			else if (!dataStuff[i])
				optionText.color = FlxColor.RED;

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
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

			getDataList();

			if (dataStuff[curSelected])
			{
				interact(false, curSelected);
				grpOptions.members[curSelected].color = FlxColor.RED;
			}
			else if (!dataStuff[curSelected])
			{
				interact(true, curSelected);
				grpOptions.members[curSelected].color = FlxColor.GREEN;
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		else if (curSelected >= textMenuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	function interact(change:Bool = true, selected:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		switch(selected)
		{
			case 0:
				FlxG.save.data.backgroundDisplay = change;
			case 1:
				FlxG.save.data.antiAliasing = change;
		}

		FlxG.save.flush();

		MythsListEngineData.dataSave();
	}

	function getDataList()
	{
		dataStuff = [
			FlxG.save.data.backgroundDisplay,
			FlxG.save.data.antiAliasing
		];
	}
}