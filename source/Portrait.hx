package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

class Portrait extends FlxSprite
{
	// Default settings (antialiasing, size)
	var propertiesArray:Array<Dynamic> = [MythsListEngineData.antiAliasing, 540];

	// Portraits with specific settings
	var pixelPortraits:Array<String> = ['bf-pixel', 'senpai', 'senpai-angry', 'spirit'];
	var bigPortraits:Array<String> = []; // It is an example array

	public var isAnimated:Bool = false;
	private var char:String = 'bf';

	public function new(char:String = 'bf', flipped:Bool = false)
	{
		super();

		generatePortrait(char);

		flipX = flipped;
		antialiasing = propertiesArray[0];
		scrollFactor.set();
	}

	function generatePortrait(char:String = 'bf')
	{
		isAnimated = false;
		propertiesArray = updateProperties(char);

		var imagePath:String = checkFile(char);

		if (OpenFlAssets.exists(Paths.getPath('images/portraits/portrait-' + char + '.xml', TEXT, 'shared')))
			isAnimated = true;

		if (!isAnimated)
		{
			loadGraphic(Paths.image(imagePath, 'shared'), true, propertiesArray[1], propertiesArray[1]);
			animation.add(char, [0], 0, false);
			animation.play(char);
		}
		else
		{
			frames = Paths.getSparrowAtlas(imagePath, 'shared');
			animation.addByPrefix('idle', 'idle', 24, true);
			animation.addByPrefix('talking', 'talking', 24, true);
			animation.play('idle');
		}
	}

	function updateProperties(char:String = 'bf'):Array<Dynamic>
	{
		// Changing basic properties
		if (pixelPortraits.contains(char))
			return [false, 100];
		else if (bigPortraits.contains(char)) // still an example
			return [true, 1000];

		return [MythsListEngineData.antiAliasing, 540];
	}

	function checkFile(char:String = 'bf')
	{
		if (OpenFlAssets.exists(Paths.image('portraits/portrait-' + char, 'shared')))
			return 'portraits/portrait-' + char;
	
		return 'portraits/portrait-bf';
	}
}
