package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var char:String = 'face';

	private var isPlayer:Bool = false;
	private var isMenuIcon:Bool = false;
	private var daAntialiasing:Bool = true;

	public function new(char:String = 'face', isPlayer:Bool = false, isMenuIcon:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;
		this.isMenuIcon = isMenuIcon;

		generateIcon(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	function generateIcon(char:String = 'face')
	{
		char = changeCharName(char);

		var file:Dynamic;

		try{
			file = Paths.image('healthicons/icon-' + char, 'preload');
		}
		catch(ex:Any){
			file = Paths.image('healthicons/icon-face', 'preload');
		}

		loadGraphic(file, true, 150, 150);

		if ((MythsListEngineData.antiAliasing || isMenuIcon) && daAntialiasing)
			antialiasing = true;
		else
			antialiasing = false;

		animation.add(char, [0, 1, 2], 0, false, isPlayer);
		animation.play(char);
	}

	function changeCharName(char:String = 'face')
	{
		var noAntialiasingIcons:Array<String> = [
			'bf-pixel',
			'senpai',
			'senpai-angry',
			'spirit'
		];

		switch(char)
		{
			case 'bf-car' | 'bf-christmas' | 'bf-minus' | 'bf-corrupted':
				char = 'bf';
			case 'gf-car' | 'gf-christmas' | 'gf-pixel':
				char = 'gf';
			case 'mom-car':
				char = 'mom';
			case 'parents-christmas':
				char = 'parents';
			case 'monster-christmas':
				char = 'monster';
			case 'template':
				char = 'face';
		}

		if (noAntialiasingIcons.contains(char))
			daAntialiasing = false;

		return char;
	}
}
