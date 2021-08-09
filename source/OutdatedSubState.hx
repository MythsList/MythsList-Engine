package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

/*
THIS IS A PLACEHOLDER SCREEN FOR YOUR MODS!

Should be easy to modify it.
*/

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var thx:FlxText = new FlxText(0, (FlxG.height / 2) - 50, FlxG.width, "THANKS FOR DOWNLOADING AND PLAYING THE MOD!", 50);
		thx.setFormat("VCR OSD Mono", 50, FlxColor.WHITE, CENTER);
		add(thx);

		var notetxt:FlxText = new FlxText(0, (FlxG.height / 2), FlxG.width, "Note : Supported keybinds are only the Current Presets and Arrow Keys.", 28);
		notetxt.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER);
		add(notetxt);

		var entertxt:FlxText = new FlxText(0, (FlxG.height / 2) + 33, FlxG.width, "Please press [ENTER] to close the menu.", 38);
		entertxt.setFormat("VCR OSD Mono", 38, FlxColor.WHITE, CENTER);
		add(entertxt);

		var warningtxt:FlxText = new FlxText(0, FlxG.height - (18 + (18 * 6)), FlxG.width, "[WARNING : If you own an outdated version of the engine or the mod, please check the gamebanana page to update it]", 18);
		warningtxt.setFormat("VCR OSD Mono", 18, FlxColor.WHITE, CENTER);
		add(warningtxt);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		var modversionText:FlxText = new FlxText(5, engineversionText.y - engineversionText.height, 0, MythsListEngineData.modVersion, 12);
		modversionText.scrollFactor.set();
		modversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(modversionText);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
