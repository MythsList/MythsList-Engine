package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

/*
THIS IS A PLACEHOLDER SCREEN FOR YOUR MODS!
Should be easy to modify it.
*/

class OutdatedSubState extends MusicBeatState
{
	var leftState:Bool = false;

	var versionToUpdate:String = 'V.69.420.52';
	var isOutdated:Bool = false;

	override function create()
	{
		super.create();

		getVersion();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var thx:FlxText = new FlxText(0, FlxG.height / 2, FlxG.width, 'THANKS FOR USING MYTHSLIST ENGINE!', 54);
		thx.setFormat("VCR OSD Mono", 54, FlxColor.WHITE, CENTER);
		thx.y -= thx.height;
		add(thx);

		var moretxt:FlxText = new FlxText(0, thx.y + thx.height, FlxG.width, '', 38);
		moretxt.text = 'Please press [ENTER] to ' + (isOutdated ? 'download the new version of the engine or press [ESC] to close the menu' : 'close the menu');
		moretxt.setFormat("VCR OSD Mono", 38, FlxColor.WHITE, CENTER);
		add(moretxt);

		var notetxt:FlxText = new FlxText(FlxG.width - 5, FlxG.height - 18, 0, 'Note: release builds will not have this screen, only debug ones', 12);
		notetxt.scrollFactor.set();
		notetxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		notetxt.x -= notetxt.width;
		add(notetxt);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, 'MythsList Engine - ' + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		if (isOutdated)
		{
			var repoversionText:FlxText = new FlxText(5, engineversionText.y - 18, 0, 'Repository - ' + versionToUpdate, 12);
			repoversionText.scrollFactor.set();
			repoversionText.setFormat("VCR OSD Mono", 16, FlxColor.YELLOW, LEFT);
			add(repoversionText);
		}
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (controls.ACCEPT)
			{
				if (!isOutdated)
				{
					leftState = true;
					FlxG.switchState(new MainMenuState());
				}
				else
					CoolUtil.openURL('https://github.com/MythsList/MythsList-Engine/releases');
			}

			if (controls.BACK && isOutdated)
			{
				leftState = true;
				FlxG.switchState(new MainMenuState());
			}
		}
		
		super.update(elapsed);
	}

	function getVersion()
	{
		if (!leftState)
		{
			var http = new haxe.Http('https://raw.githubusercontent.com/MythsList/MythsList-Engine/main/engineVersion.txt');
			
			http.onData = function(data:String)
			{
				versionToUpdate = 'V.' + data.split('\n')[0].trim();

				if (versionToUpdate != MythsListEngineData.engineVersion)
					isOutdated = true;
			}
			
			http.onError = function(error)
			{
				trace('error: $error');
			}
			
			http.request();
		}
	}
}
