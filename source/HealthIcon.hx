package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var isAnimated:Bool = false;
	public var isPlayer:Bool = false;

	private var char:String = 'face';
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
		isAnimated = false;
		char = updateIconProperties(char);

		var imagePath:String = checkFile(char);

		if (OpenFlAssets.exists(Paths.getPath('images/healthicons/icon-' + char + '.xml', TEXT, 'preload')))
			isAnimated = true;

		if (!isAnimated)
		{
			loadGraphic(Paths.image(imagePath, 'preload'), true, 150, 150);
			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
		}
		else
		{
			frames = Paths.getSparrowAtlas(imagePath, 'preload');
			animation.addByPrefix('neutral', 'neutral', 24, false);
			animation.addByPrefix('losing', 'losing', 24, false);
			animation.addByPrefix('winning', 'winning', 24, false);
			animation.play('neutral');
		}
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

	public function updateIconState(animatedIcon:Bool = false, playerIcon:Bool = false)
	{
		if (!animatedIcon)
		{
			if (PlayState.healthBar.percent <= 20)
				animation.curAnim.curFrame = (playerIcon ? 1 : 2);
			else if (PlayState.healthBar.percent >= 80)
				animation.curAnim.curFrame = (playerIcon ? 2 : 1);
			else
				animation.curAnim.curFrame = 0;
		}
		else
		{
			if (PlayState.healthBar.percent <= 20)
				animation.play((playerIcon ? 'losing' : 'winning'));
			else if (PlayState.healthBar.percent >= 80)
				animation.play((playerIcon ? 'winning' : 'losing'));
			else
				animation.play('neutral');
		}
	}
}
