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
import flixel.input.FlxKeyManager;
import flixel.input.FlxInput;
import flixel.math.FlxMath;
import lime.utils.Assets;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class ControlsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = [
		'LEFT KEY',
		'DOWN KEY',
		'UP KEY',
		'RIGHT KEY',
		'RESET KEY',
		'PAUSE KEY'
	];

	var keybindBlacklist:Array<String> = [
		'ESCAPE',
		'ENTER',
		'END',
		'HOME',
		'INSERT',
		'PRINTSCREEN',
		'QUOTE',
		'BACKSPACE',
		'SPACE',
		'TAB',
		'SHIFT',
		'CONTROL',
		'CAPSLOCK',
		'ALT',
		'DELETE',
		'UP',
		'DOWN',
		'LEFT',
		'RIGHT'
	];

	var BG:FlxSprite;

	var curKeybinds:FlxText;
	var curBind:FlxText;

	var curSelected:Int = 0;

	var grpOptions:FlxTypedGroup<Alphabet>;

	public function new()
	{
		super();

		#if desktop
			DiscordClient.changePresence("In The Keybinds Options Menu", null);
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

			grpOptions.add(optionText);
		}

		BG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 4), 250, 0xFF000000);
		BG.x = FlxG.width - BG.width;
		BG.alpha = 0.25;
		add(BG);

		curKeybinds = new FlxText(BG.x + 5, BG.y + 5, 0, 
		'Current keybinds:\n\n'
		+ 'Left key: ' + MythsListEngineData.keyBinds[0] + '\n'
		+ 'Down key: ' + MythsListEngineData.keyBinds[1] + '\n'
		+ 'Up key: ' + MythsListEngineData.keyBinds[2] + '\n'
		+ 'Right key: ' + MythsListEngineData.keyBinds[3] + '\n'
		+ '\nReset key: ' + MythsListEngineData.keyBinds[4] + '\n'
		+ 'Pause key: ' + MythsListEngineData.keyBinds[5],
		16);
		
		add(curKeybinds);

		curBind = new FlxText(0, 0, 0, '_', 200);
		curBind.x = (BG.x + BG.width) - ((BG.width / 2) + (curBind.width / 2));
		curBind.y = (FlxG.height / 2) - (curBind.height / 2) + 100;
		add(curBind);

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

	var selected:Bool = false;
	var keybindSelected:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selected)
		{
			if (controls.UP_P && !keybindSelected)
				changeSelection(-1);

			if (controls.DOWN_P && !keybindSelected)
				changeSelection(1);

			if (controls.BACK)
			{
				selected = true;

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(new OptionsSubState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

				curBind.text = MythsListEngineData.keyBinds[curSelected].toUpperCase();

				if (!keybindSelected)
				{
					curBind.color = FlxColor.YELLOW;

					interact(true);
					keybindSelected = true;
				}
				else
				{
					curBind.color = FlxColor.WHITE;

					interact(false);
					keybindSelected = false;
				}
			}

			if (FlxG.keys.justPressed.ANY && !controls.ACCEPT && keybindSelected)
			{
				curBind.color = FlxColor.YELLOW;

				interact(false, FlxG.keys.getIsDown()[0].ID.toString());
				keybindSelected = false;

				curBind.color = FlxColor.WHITE;
			}
		}

		curKeybinds.text = 'Current keybinds:\n\n'
		+ 'Left key: ' + MythsListEngineData.keyBinds[0] + '\n'
		+ 'Down key: ' + MythsListEngineData.keyBinds[1] + '\n'
		+ 'Up key: ' + MythsListEngineData.keyBinds[2] + '\n'
		+ 'Right key: ' + MythsListEngineData.keyBinds[3] + '\n'
		+ '\nReset key: ' + MythsListEngineData.keyBinds[4] + '\n'
		+ 'Pause key: ' + MythsListEngineData.keyBinds[5];

		curBind.x = (BG.x + BG.width) - ((BG.width / 2) + (curBind.width / 2));
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		var stuff:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = stuff - curSelected;
			stuff ++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}

		curBind.text = MythsListEngineData.keyBinds[curSelected].toUpperCase();
	}

	function interact(interaction:Bool = false, key:String = null)
	{	
		if (interaction) // saves the keybind
		{
			curBind.text = MythsListEngineData.keyBinds[curSelected].toUpperCase();

			controls.setKeyboardScheme(Solo, true);
			MythsListEngineData.dataSave();
		}
		else // currently being changed
		{
			var oldKey:String = MythsListEngineData.keyBinds[curSelected];

			if (key != null && key != oldKey)
			{
				if (!keybindBlacklist.contains(key) && !MythsListEngineData.keyBinds.contains(key))
				{
					curBind.text = key.toUpperCase();

					FlxG.save.data.keyBinds[curSelected] = key;
					FlxG.save.flush();

					interact(true);
				}
			}
			else
			{
				curBind.text = oldKey.toUpperCase();
			}
		}
	}
}