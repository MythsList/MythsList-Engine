package;

import flixel.FlxSprite;

class Portrait extends FlxSprite
{
	var newchar:String = 'bf';

	// Antialiasing and size
	var propertiesArray:Array<Dynamic> = [true, 540];

	var pixelPortraits:Array<String> = ['bf-pixel', 'senpai', 'senpai-angry', 'spirit'];
	var bigPortraits:Array<String> = []; // It is an example array

	public function new(char:String = 'bf', flipped:Bool = false)
	{
		super();

		propertiesArray = [MythsListEngineData.antiAliasing, 540];

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

		updateProperties(newchar);

		loadGraphic(Paths.image('portraits/portrait-' + newchar, 'shared'), true, propertiesArray[1], propertiesArray[1]);
		
		antialiasing = propertiesArray[0];

		animation.add(newchar, [0], 0, false, flipped);

		animation.play(newchar);
		scrollFactor.set();
	}

	function updateProperties(char:String = 'bf')
	{
		if (pixelPortraits.contains(newchar))
			propertiesArray = [false, 100];
		else if (bigPortraits.contains(newchar)) // still an example
			propertiesArray = [true, 1000];
	}
}
