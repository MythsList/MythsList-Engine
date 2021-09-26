package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	var newchar:String;
	var daAntialiasing:Bool = true;

	public function new(char:String = 'bf', isPlayer:Bool = false, isMenuIcon:Bool = false)
	{
		super();

		newchar = char;

		switch(char)
		{
			case 'bf-car' | 'bf-christmas' | 'bf-minus' | 'bf-corrupted' | null:
				newchar = 'bf';
			case 'gf-car' | 'gf-christmas' | 'gf-pixel':
				newchar = 'gf';
			case 'mom-car':
				newchar = 'mom';
			case 'parents-christmas':
				newchar = 'parents';
			case 'monster-christmas':
				newchar = 'monster';
			case 'template':
				newchar = 'face';
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit':
				daAntialiasing = false;
		}

		loadGraphic(Paths.image('healthicons/icon-' + newchar, 'preload'), true, 150, 150);

		if ((MythsListEngineData.antiAliasing && daAntialiasing) || (daAntialiasing && isMenuIcon))
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
