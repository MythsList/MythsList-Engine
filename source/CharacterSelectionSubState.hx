package;

#if desktop
import Discord.DiscordClient;
#end
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
	// ADD YOUR CHARACTER FIRST IN CHARACTER.HX AND CHARACTERSLIST.TXT!

	/*
	characterLabels contain the character names.
	(has nothing to do with Character.hx and characterlist.txt, it's just for the buttons)

	characters contain your characters, of course.
	(Related to HealthIcon.hx and Character.hx, would recommend putting your character's name in like I did)
	*/

	public static var characterLabels:Array<String> = [
		'Boyfriend',
		'Minus Boyfriend',
		'Beta Boyfriend',
		'Old Boyfriend',
		'Corrupted Boyfriend',
		'Brody Foxx',
		'Template',
		'Rhys'
	];

	public static var characters:Array<String> = [
		'bf',
		'bf-minus',
		'bf-old',
		'bf-veryold',
		'bf-corrupted',
		'brody-foxx',
		'template',
		'rhys'
	];

	private var playerStrums:FlxTypedGroup<FlxSprite>;
	var arrowsEnabled:Bool = false;

	var curIcon:HealthIcon;
	var curIconText:FlxText;

	var curCharacter:Character;

	var curBG:FlxSprite;
	var curBGtext:FlxText;

	var curSelected:Int = 0;

	var grpOptions:FlxTypedGroup<Alphabet>;
	var iconArray:Array<HealthIcon> = [];

	var curPress:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public function new()
	{
		super();

		#if desktop
			DiscordClient.changePresence("In The Character Selection Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		menuBG.color = 0xFF71fd89;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...characterLabels.length)
		{
			var optionText:Alphabet = new Alphabet(0, (70 * i) + 30, characterLabels[i], true, false);
			optionText.x = 50;

			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.xForce = optionText.x;

			if (MythsListEngineData.characterSkin == characters[i])
				optionText.color = FlxColor.GREEN;
			else if (MythsListEngineData.characterSkin != characters[i])
				optionText.color = FlxColor.RED;

			grpOptions.add(optionText);

			var icon:HealthIcon = new HealthIcon(characters[i], false, true);
			icon.sprTracker = optionText;

			iconArray.push(icon);
			add(icon);
		}

		curBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 4), 10 + 26 + 150 + 16, 0xFF000000);
		curBG.alpha = 0.25;
		add(curBG);

		curBG.x = FlxG.width - curBG.width;

		curBGtext = new FlxText(curBG.x + 5, curBG.y + 5, 0, 'Currently Selected :', 26);
		curBGtext.scrollFactor.set();
		curBGtext.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		add(curBGtext);

		var noteText:FlxText = new FlxText(0, 0, 0, 'Press ALT to enable/disable arrows', 26);
		noteText.scrollFactor.set();
		noteText.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(noteText);

		noteText.x = FlxG.width - noteText.width - 5;
		noteText.y = FlxG.height - noteText.height - 5;

		curIcon = new HealthIcon(MythsListEngineData.characterSkin, false, true);
		curIcon.x = curBGtext.x;
		curIcon.y = curBGtext.y + curBGtext.height;
		add(curIcon);

		for (i in 0...characterLabels.length)
		{
			if (MythsListEngineData.characterSkin == characters[i])
				curIconText = new FlxText(0, 0, 0, characterLabels[i], 16);
		}

		curIconText.x = curBGtext.x;
		curIconText.y = curIcon.y + curIcon.height;
		curIconText.scrollFactor.set();
		curIconText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		add(curIconText);

		curCharacter = new Character(curBGtext.x, curBG.y + curBG.height, MythsListEngineData.characterSkin, true, true);
		curCharacter.x = curBGtext.x + (curBG.width / 2) - (curCharacter.frameWidth / 2);
		curCharacter.y = curBG.y + (curBG.height * 2) - (curCharacter.frameHeight / 2);
		curCharacter.scrollFactor.set();
		curCharacter.dance();
		add(curCharacter);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		changeSelection(0);
		generateArrows();
		offsetChange();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var controlArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var controlArrayPress:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var controlArrayRelease:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		if (curCharacter.animation.finished)
			curCharacter.dance();

		if (arrowsEnabled && (controlArrayPress.contains(true) || controlArrayRelease.contains(true)))
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (controlArrayPress[spr.ID] && spr.animation.curAnim.name != 'confirm')
				{
					spr.animation.play('pressed');
					curCharacter.playAnim('sing' + curPress[spr.ID], true);
				}

				if (controlArrayRelease[spr.ID])
					spr.animation.play('static');
			
				if (spr.animation.curAnim.name == 'confirm')
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
			});
		}

		if (arrowsEnabled && controlArray.contains(true))
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (controlArray[spr.ID])
					curCharacter.playAnim('sing' + curPress[spr.ID], true);
			});
		}

		if (FlxG.keys.justPressed.ALT)
		{
			if (!arrowsEnabled)
			{
				arrowsEnabled = true;

				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.alpha = 1;
				});
			}
			else
			{
				arrowsEnabled = false;

				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.alpha = 0.6;
				});
			}
		}

		if (controls.UP_P && !arrowsEnabled)
			changeSelection(-1);

		if (controls.DOWN_P && !arrowsEnabled)
			changeSelection(1);

		if (controls.BACK)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new OptionsSubState());
		}

		if (controls.ACCEPT && !arrowsEnabled)
		{
			interact(curSelected);

			var curItem:Int = 0;

			for (item in grpOptions.members)
			{
				if (MythsListEngineData.characterSkin == characters[curSelected] && curSelected == curItem)
					item.color = FlxColor.GREEN;
				else if (MythsListEngineData.characterSkin != characters[curSelected] && curSelected != curItem)
					item.color = FlxColor.RED;
				else
					item.color = FlxColor.RED;

				curItem += 1;
			}

			remove(curIcon);
			curIcon = new HealthIcon(MythsListEngineData.characterSkin, false, true);
			curIcon.x = curBGtext.x;
			curIcon.y = curBGtext.y + curBGtext.height;
			add(curIcon);

			remove(curIconText);

			for (i in 0...characterLabels.length)
			{
				if (MythsListEngineData.characterSkin == characters[i])
					curIconText = new FlxText(0, 0, 0, characterLabels[i], 16);
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
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = characterLabels.length - 1;
		else if (curSelected >= characterLabels.length)
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

	function interact(selected:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		FlxG.save.data.characterSkin = characters[selected];
		FlxG.save.flush();

		MythsListEngineData.dataSave();

		remove(curCharacter);
		curCharacter = new Character(curBGtext.x, curBG.y + curBG.height, MythsListEngineData.characterSkin, true, true);
		curCharacter.scrollFactor.set();
		curCharacter.dance();
		add(curCharacter);

		curCharacter.x = curBGtext.x + (curBG.width / 2) - (curCharacter.frameWidth / 2);
		curCharacter.y = curBG.y + (curBG.height * 2) - (curCharacter.frameHeight / 2);

		offsetChange();
	}

	function offsetChange()
	{
		switch (MythsListEngineData.characterSkin)
		{
			case 'bf' | 'bf-minus' | 'bf-old' | 'bf-veryold':
				curCharacter.x -= 20;
			case 'brody-foxx':
				curCharacter.x -= 60;
			case 'template':
				curCharacter.x -= 50;
		}
	}

	function generateArrows():Void
	{
		for (i in 0...4)
		{
			var greyArrow:FlxSprite = new FlxSprite(FlxG.width - 20 - ((160 * 0.7) * 4), FlxG.height - 145);

			greyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
			greyArrow.animation.addByPrefix('green', 'arrowUP');
			greyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			greyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			greyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			greyArrow.antialiasing = MythsListEngineData.menuAntialiasing;
			greyArrow.alpha = 0.6;

			greyArrow.setGraphicSize(Std.int(greyArrow.width * 0.7));

			greyArrow.x += Note.swagWidth * i;

			switch(Math.abs(i))
			{
				case 0:
					greyArrow.animation.addByPrefix('static', 'arrowLEFT');
					greyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					greyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					greyArrow.animation.addByPrefix('static', 'arrowDOWN');
					greyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					greyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					greyArrow.animation.addByPrefix('static', 'arrowUP');
					greyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					greyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					greyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					greyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					greyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
			}

			greyArrow.updateHitbox();
			greyArrow.scrollFactor.set();

			greyArrow.ID = i;

			playerStrums.add(greyArrow);

			greyArrow.animation.play('static');

			add(playerStrums);
		}
	}
}