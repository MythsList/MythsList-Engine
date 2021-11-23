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

		var thx:FlxText = new FlxText(0, (FlxG.height / 2) - 38, FlxG.width, "THANKS FOR USING MYTHSLIST ENGINE!", 50);
		thx.setFormat("VCR OSD Mono", 50, FlxColor.WHITE, CENTER);
		add(thx);

		var entertxt:FlxText = new FlxText(0, thx.y + thx.height, FlxG.width, "Please press [ENTER] to close the menu.", 38);
		entertxt.setFormat("VCR OSD Mono", 38, FlxColor.WHITE, CENTER);
		add(entertxt);

		var warningtxt:FlxText = new FlxText(0, FlxG.height - (18 + (18 * 6)), FlxG.width, "[WARNING : If you own an outdated version of the engine, please check the gamebanana page to update it]", 18);
		warningtxt.setFormat("VCR OSD Mono", 18, FlxColor.WHITE, CENTER);
		add(warningtxt);

		var notetxt:FlxText = new FlxText(FlxG.width - 5, FlxG.height - 18, 0, "Note: release builds will not have this screen, only debug ones", 12);
		notetxt.scrollFactor.set();
		notetxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		notetxt.x -= notetxt.width;
		add(notetxt);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && !leftState)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}
}
