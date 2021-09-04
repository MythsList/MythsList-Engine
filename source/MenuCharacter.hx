package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String;
	
	var looped:Bool;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;

		switch(character)
		{
			case 'bfConfirm':
				looped = false;
			default:
				looped = true;
		}

		/*
		var tex = Paths.getSparrowAtlas('menucharacters/' + character, 'preload');
		frames = tex;

		animation.addByPrefix(character, character, 24, looped);
		*/

		var tex = Paths.getSparrowAtlas('campaign_menu_UI_characters', 'preload');
		frames = tex;

		animation.addByPrefix('bf', "BF idle dance white", 24);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, looped);
		animation.addByPrefix('gf', "GF Dancing Beat WHITE", 24);
		animation.addByPrefix('dad', "Dad idle dance BLACK LINE", 24);
		animation.addByPrefix('spooky', "spooky dance idle BLACK LINES", 24);
		animation.addByPrefix('pico', "Pico Idle Dance", 24);
		animation.addByPrefix('mom', "Mom Idle BLACK LINES", 24);
		animation.addByPrefix('parents-christmas', "Parent Christmas Idle", 24);
		animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24);

		// WIP SHIT, not coming now

		animation.play(character);
		updateHitbox();
	}
}
