package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class StageSprite extends FlxSprite
{
	var animations:Array<String> = null;

	public function new(imagePath:String = null, imageLibrary:String = 'shared', x:Float = 0, y:Float = 0, scrollX:Float = 1, scrollY:Float = 1, animations:Array<String> = null, looped:Bool = false)
	{
		super(x, y);

		this.animations = animations;

		if (animations == null)
		{
			if (imagePath != null)
				loadGraphic(Paths.image(imagePath, imageLibrary));

			active = false;
		}
		else
		{
			frames = Paths.getSparrowAtlas(imagePath, imageLibrary);

			for (i in 0...animations.length)
			{
				animation.addByPrefix(animations[i], animations[i], 24, looped);
			}
		}

		scrollFactor.set(scrollX, scrollY);
		antialiasing = MythsListEngineData.antiAliasing;
	}

	public function newGraphicSize(multiplier:Float = 1)
	{
		setGraphicSize(Std.int(width * multiplier));
		updateHitbox();
	}

	public function playAnim(anim:String = 'idle', ?forcePlay:Bool = false)
	{
		if (animations != null && animations.contains(anim))
		{
			for (item in animations)
			{
				if (anim == item)
					animation.play(anim, forcePlay);
			}
		}
	}
}