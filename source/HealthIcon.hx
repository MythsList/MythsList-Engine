package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	var newchar:String;
	var daAntialiasing:Bool = true;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		newchar = char;

		switch(char)
		{
			case 'bf-car' | 'bf-christmas' | 'bf-minus' | null:
				newchar = 'bf';
			case 'bf-pixel':
				daAntialiasing = false;
			case 'mom-car':
				newchar = 'mom';
			case 'parents-christmas':
				newchar = 'parents';
			case 'monster-christmas':
				newchar = 'monster';
			case 'template':
				newchar = 'face';
			case 'senpai' | 'senpai-angry' | 'spirit':
				daAntialiasing = false;
		}

		loadGraphic(Paths.image('healthicons/icon-' + newchar, 'preload'), true, 150, 150);

		if (MythsListEngineData.antiAliasing && daAntialiasing)
			antialiasing = true;
		else
			antialiasing = false;

		animation.add(newchar, [0, 1, 2], 0, false, isPlayer);

		animation.play(newchar);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
