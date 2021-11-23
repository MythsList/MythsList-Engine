package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

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

		antialiasing = (((!isMenuIcon && MythsListEngineData.antiAliasing) || (isMenuIcon && MythsListEngineData.menuAntialiasing)) && daAntialiasing ? true : false);
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
		char = updateIconProperties(char);

		var imagePath:String = checkFile(char);
		var file:Dynamic = Paths.image(imagePath, 'preload');

		loadGraphic(file, true, 150, 150);

		animation.add(char, [0, 1, 2], 0, false, isPlayer);
		animation.play(char);
	}

	function updateIconProperties(char:String = 'face')
	{
		// For characters that don't need antialiasing for their health icons
		var noAntialiasingIcons:Array<String> = [
			'bf-pixel',
			'senpai',
			'senpai-angry',
			'spirit'
		];

		// For characters that don't have an actual health icon
		// Character you chose -> new character
		var charNameSwitching:Array<Dynamic> = [
			['bf-car', 'bf'],
			['bf-christmas', 'bf'],
			['bf-minus', 'bf'],
			['bf-corrupted', 'bf'],
			['mom-car', 'mom'],
			['parents-christmas', 'parents'],
			['monster-christmas', 'monster'],
			['template', 'face']
		];

		if (noAntialiasingIcons.contains(char))
			daAntialiasing = false;

		for (item in charNameSwitching)
		{
			if (Std.is(item[0], String) && item[0] == char)
			{
				char = item[1];
				return char;
			}
		}

		return char;
	}

	function checkFile(char:String = 'face')
	{
		if (OpenFlAssets.exists(Paths.image('healthicons/icon-' + char, 'preload')))
			return 'healthicons/icon-' + char;

		return 'healthicons/icon-face';
	}
}
