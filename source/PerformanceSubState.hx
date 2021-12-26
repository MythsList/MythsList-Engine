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
	var optionItems:Array<Dynamic> = [
		['Background display', 'Creates the background'],
		['Antialiasing', 'Adds antialiasing to all in-game assets'],
		['Menu antialiasing', 'Adds antialiasing to all menu assets (does not affect backgrounds)']
	];

	var dataStuff:Array<Bool> = [];

	var curSelected:Int = 0;

	var optionDesc:FlxText;
	var optionStatus:FlxText;
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

		for (i in 0...optionItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, optionItems[i][0], true, false);
			optionText.screenCenter(X);

			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.xForce = optionText.x;

			getDataList();

			optionText.color = (dataStuff[i] ? FlxColor.GREEN : FlxColor.RED);

			grpOptions.add(optionText);
		}

		var background:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 24, 0xFF000000);
		background.scrollFactor.set();
		background.alpha = 0.6;
		add(background);

		var backgroundtwo:FlxSprite = new FlxSprite(0, FlxG.height - 24).makeGraphic(FlxG.width, 24, 0xFF000000);
		backgroundtwo.scrollFactor.set();
		backgroundtwo.alpha = 0.6;
		add(backgroundtwo);

		optionDesc = new FlxText(5, background.y + background.height - 22, 0, 'PlaceHolder', 20);
		optionDesc.scrollFactor.set();
		optionDesc.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT);
		add(optionDesc);

		optionStatus = new FlxText(0, backgroundtwo.y + 2, 0, 'PlaceHolder', 20);
		optionStatus.x = FlxG.width - optionStatus.width - 5;
		optionStatus.scrollFactor.set();
		optionStatus.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT);
		add(optionStatus);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

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

			var dataCheck:Bool = dataStuff[curSelected];

			interact(!dataCheck, curSelected);
			grpOptions.members[curSelected].color = (dataCheck ? FlxColor.RED : FlxColor.GREEN);

			getDataList();

			optionStatus.text = 'Currently ' + (dataStuff[curSelected] ? 'ON' : 'OFF');
			optionStatus.x = FlxG.width - optionStatus.width - 5;
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		getDataList();

		curSelected += change;

		if (curSelected < 0)
			curSelected = optionItems.length - 1;
		else if (curSelected >= optionItems.length)
			curSelected = 0;

		optionDesc.text = optionItems[curSelected][1];

		optionStatus.text = 'Currently ' + (dataStuff[curSelected] ? 'ON' : 'OFF');
		optionStatus.x = FlxG.width - optionStatus.width - 5;

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
			case 2:
				FlxG.save.data.menuAntialiasing = change;
		}

		FlxG.save.flush();

		MythsListEngineData.dataSave();
	}

	function getDataList()
	{
		dataStuff = [
			FlxG.save.data.backgroundDisplay,
			FlxG.save.data.antiAliasing,
			FlxG.save.data.menuAntialiasing
		];
	}
}