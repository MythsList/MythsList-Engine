package;

import flixel.FlxSprite;

class Portrait extends FlxSprite
{
	var newchar:String;
	var antiAliasing:Bool;

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
			default:
				antiAliasing = true;
		}

		// Yeah portraits are not very HD, it was just to test the week 6 portraits which are small portraits
		// Might be changed in V.1.0.2

		loadGraphic(Paths.image('portraits/portrait-' + newchar, 'shared'), true, 100, 100);
		antialiasing = antiAliasing;

		animation.add(newchar, [0], 0, false, flipped);

		animation.play(newchar);
		scrollFactor.set();
	}
}
