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

class ArrowColorSubState extends MusicBeatSubstate
{
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var noteStrums:FlxTypedGroup<FlxSprite>;
	private var colorValues:FlxTypedGroup<FlxText>;

	var colorArray:Array<Dynamic>;

	var button:Alphabet;

	var arrowSelected:Int = 0;
	var colorValueSelected:Int = 0;

	var buttonSelected:Bool = true;
	var choosingArrow:Bool = false;
	var choosingColor:Bool = false;

	var curRed:Int = 0;
	var curGreen:Int = 0;
	var curBlue:Int = 0;

	var value:Int = 1;

	public function new()
	{
		super();

		#if desktop
			DiscordClient.changePresence("In The Arrow Colors Options Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		menuBG.color = 0xFF71fd89;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		button = new Alphabet(0, 80, 'Use custom arrow colors', true, false);
		button.screenCenter(X);

		if (FlxG.save.data.arrowColors)
			button.color = FlxColor.GREEN;
		else if (!FlxG.save.data.arrowColors)
			button.color = FlxColor.RED;

		add(button);

		updateColorArray();

		playerStrums = new FlxTypedGroup<FlxSprite>();

		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite((FlxG.width / 2) - ((160 * 1.1) * 2), (FlxG.height / 2) - ((160 * 1.1) / 2) + 60);

			babyArrow.frames = Paths.getSparrowAtlas('customNOTE_assets', 'shared');
	
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
			babyArrow.antialiasing = MythsListEngineData.menuAntialiasing;
	
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 1.1));
	
			babyArrow.x += (160 * 1.1) * i;
	
			switch(i)
			{
				case 0:
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
				case 1:
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
				case 2:
					babyArrow.animation.addByPrefix('static', 'arrowUP');
				case 3:
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
			}

			babyArrow.color = FlxColor.WHITE;

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
	
			babyArrow.ID = i;

			playerStrums.add(babyArrow);
	
			babyArrow.animation.play('static');
		}

		add(playerStrums);

		noteStrums = new FlxTypedGroup<FlxSprite>();

		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite((FlxG.width / 2) - ((160 * 0.7) * 2), (FlxG.height / 2) - (160 * 1.1) - ((160 * 0.7) / 2) + 80);
	
			babyArrow.frames = Paths.getSparrowAtlas('customNOTE_assets', 'shared');
		
			babyArrow.antialiasing = MythsListEngineData.menuAntialiasing;
		
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
			babyArrow.x += (160 * 0.7) * i;
		
			switch(i)
			{
				case 0:
					babyArrow.animation.addByPrefix('idle', 'purple0');
				case 1:
					babyArrow.animation.addByPrefix('idle', 'blue0');
				case 2:
					babyArrow.animation.addByPrefix('idle', 'green0');
				case 3:
					babyArrow.animation.addByPrefix('idle', 'red0');
			}
	
			babyArrow.color = FlxColor.fromRGB(colorArray[i][0], colorArray[i][1], colorArray[i][2]);
	
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();
		
			babyArrow.ID = i;
	
			noteStrums.add(babyArrow);
		
			babyArrow.animation.play('idle');
		}

		add(noteStrums);

		colorValues = new FlxTypedGroup<FlxText>();

		curRed = colorArray[arrowSelected][0];
		curGreen = colorArray[arrowSelected][1];
		curBlue = colorArray[arrowSelected][2];

		var textArray:Array<String> = ['R:' + Std.string(curRed), 'G:' + Std.string(curGreen), 'B:' + Std.string(curBlue)];

		for (i in 0...3)
		{
			var colorText:FlxText = new FlxText(((FlxG.width / 4) * i) + (FlxG.width / 4), FlxG.height - 60, 0, textArray[i], 64);

			colorText.y -= colorText.height * 1.5;
			colorText.x -= 194 / 2;
			colorText.scrollFactor.set();
			colorText.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			colorText.ID = i;

			colorValues.add(colorText);
		}

		add(colorValues);

		var noteText:FlxText = new FlxText(0, FlxG.height - 40 - 16, 0, 'Press ENTER to save the color', 40);
		noteText.scrollFactor.set();
		noteText.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noteText.screenCenter(X);
		add(noteText);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		button.alpha = (buttonSelected ? 1 : 0.6);

		playerStrums.forEach(function(spr:FlxSprite)
		{					
			spr.alpha = (choosingArrow ? 1 : 0.6);

			if (spr.ID == arrowSelected)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});

		colorValues.forEach(function(spr:FlxText)
		{					
			spr.alpha = (choosingColor ? 1 : 0.6);
		});

		noteStrums.forEach(function(spr:FlxSprite)
		{					
			spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
		});

		if (FlxG.keys.pressed.SHIFT)
			value = 10;
		else
			value = 1;

		if (controls.UP_P)
		{
			if (!choosingColor)
			{
				FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);
				buttonSelected = !buttonSelected;
				choosingArrow = !choosingArrow;
				updateColorArray();
			}
			else
			{
				interactColorValue(-value);
				updateColorArray();
			}
		}

		if (controls.DOWN_P)
		{
			if (!choosingColor)
			{
				FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);
				buttonSelected = !buttonSelected;
				choosingArrow = !choosingArrow;
				updateColorArray();
			}
			else
			{
				interactColorValue(value);
				updateColorArray();
			}
		}

		if (controls.LEFT_P)
		{
			if (choosingColor)
				changeColorValue(-1);
			else if (choosingArrow)
				changeArrow(-1);
		}

		if (controls.RIGHT_P)
		{
			if (choosingColor)
				changeColorValue(1);
			else if (choosingArrow)
				changeArrow(1);
		}

		if (controls.BACK)
		{
			if (!choosingColor)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(new OptionsSubState());
			}
			else
			{
				FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

				updateColorArray();

				curRed = colorArray[arrowSelected][0];
				curGreen = colorArray[arrowSelected][1];
				curBlue = colorArray[arrowSelected][2];

				var textArray:Array<String> = ['R:' + Std.string(curRed), 'G:' + Std.string(curGreen), 'B:' + Std.string(curBlue)];

				for (i in 0...3)
				{
					colorValues.members[i].text = textArray[i];
					colorValues.members[i].color = FlxColor.WHITE;
				}

				noteStrums.forEach(function(spr:FlxSprite)
				{					
					spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
				});

				choosingColor = false;
				choosingArrow = true;
				buttonSelected = false;
			}
		}

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

			if (buttonSelected)
			{
				if (FlxG.save.data.arrowColors)
				{
					interact(false);
					button.color = FlxColor.RED;
				}
				else if (!FlxG.save.data.arrowColors)
				{
					interact(true);
					button.color = FlxColor.GREEN;
				}
			}
			else if (choosingArrow)
			{
				updateColorArray();

				colorValueSelected = 0;
				
				curRed = colorArray[arrowSelected][0];
				curGreen = colorArray[arrowSelected][1];
				curBlue = colorArray[arrowSelected][2];

				var textArray:Array<String> = ['R:' + Std.string(curRed), 'G:' + Std.string(curGreen), 'B:' + Std.string(curBlue)];

				for (i in 0...3)
				{
					colorValues.members[i].text = textArray[i];
					colorValues.members[i].color = (colorValueSelected == i ? FlxColor.YELLOW : FlxColor.WHITE);
				}

				choosingArrow = false;
				choosingColor = true;
			}
			else if (choosingColor)
			{
				updateColorArray();

				switch(arrowSelected)
				{
					case 0:
						FlxG.save.data.arrowLeft = [curRed, curGreen, curBlue];
					case 1:
						FlxG.save.data.arrowDown = [curRed, curGreen, curBlue];
					case 2:
						FlxG.save.data.arrowUp = [curRed, curGreen, curBlue];
					case 3:
						FlxG.save.data.arrowRight = [curRed, curGreen, curBlue];
				}

				FlxG.save.flush();

				MythsListEngineData.dataSave();

				updateColorArray();

				noteStrums.forEach(function(spr:FlxSprite)
				{					
					spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
				});
			}
		}
	}

	function changeArrow(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		arrowSelected += change;

		if (arrowSelected < 0)
			arrowSelected = playerStrums.length - 1;
		else if (arrowSelected >= playerStrums.length)
			arrowSelected = 0;

		updateColorArray();

		curRed = colorArray[arrowSelected][0];
		curGreen= colorArray[arrowSelected][1];
		curBlue = colorArray[arrowSelected][2];

		var textArray:Array<String> = ['R:' + Std.string(curRed), 'G:' + Std.string(curGreen), 'B:' + Std.string(curBlue)];

		for (i in 0...3)
		{
				colorValues.members[i].text = textArray[i];
		}
	}

	function changeColorValue(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		colorValueSelected += change;

		if (colorValueSelected < 0)
			colorValueSelected = colorValues.length - 1;
		else if (colorValueSelected >= colorValues.length)
			colorValueSelected = 0;

		colorValues.forEach(function(spr:FlxText)
		{
			if (spr.ID == colorValueSelected)
				spr.color = FlxColor.YELLOW;
			else
				spr.color = FlxColor.WHITE;
		});
	}

	function interact(change:Bool = true)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		FlxG.save.data.arrowColors = change;
		FlxG.save.flush();

		MythsListEngineData.dataSave();
	}

	function interactColorValue(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		switch(colorValueSelected)
		{
			case 0:
				curRed += change;

				if (curRed < 0)
					curRed = 255;
				else if (curRed > 255)
					curRed = 0;

				colorValues.members[colorValueSelected].text = 'R:' + Std.string(curRed);
			case 1:
				curGreen += change;

				if (curGreen < 0)
					curGreen = 255;
				else if (curGreen > 255)
					curGreen = 0;

				colorValues.members[colorValueSelected].text = 'G:' + Std.string(curGreen);
			case 2:
				curBlue += change;

				if (curBlue < 0)
					curBlue = 255;
				else if (curBlue > 255)
					curBlue = 0;

				colorValues.members[colorValueSelected].text = 'B:' + Std.string(curBlue);
		}
	}

	function updateColorArray()
	{
		colorArray = [
			MythsListEngineData.arrowLeft,
			MythsListEngineData.arrowDown,
			MythsListEngineData.arrowUp,
			MythsListEngineData.arrowRight
		];
	}
}