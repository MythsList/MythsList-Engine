package;

import flixel.FlxSprite;

class Portrait extends FlxSprite
{
	var newchar:String = 'bf';
	var antiAliasing:Bool = true;
	var size:Int = 540;

	public function new(char:String = 'bf', flipped:Bool = false)
	{
		super();

		newchar = char;

		switch(char)
		{
			case 'bf-car' | null:
				newchar = 'bf';
			case 'mom-car':
				newchar = 'mom';
			case 'parents-christmas':
				newchar = 'parents';
		}

		switch(newchar)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit':
				antiAliasing = false;
				size = 100;
			default:
				antiAliasing = MythsListEngineData.antiAliasing;
				size = 540;
		}

		loadGraphic(Paths.image('portraits/portrait-' + newchar, 'shared'), true, size, size);
		
		antialiasing = antiAliasing;

		animation.add(newchar, [0], 0, false, flipped);

		animation.play(newchar);
		scrollFactor.set();
	}
}
