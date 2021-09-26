package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String;
	
	private var looped:Bool = true;
	private var animated:Bool = true;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;

		switch(character)
		{
			case 'bfConfirm':
				character = 'confirmbf';
				looped = false;
			case '' | null:
				character = 'dad';
				animated = false;
				visible = false;
			default:
				visible = true;
		}

		//Still wip...

		//frames = Paths.getSparrowAtlas('menucharacters/' + character, 'preload');

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters', 'preload');

		if (animated)
		{
			animation.addByPrefix(character, character, 24, looped);
			animation.play(character);
		}

		updateHitbox();
	}
}
