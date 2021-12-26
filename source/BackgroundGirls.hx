package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundGirls extends FlxSprite
{
	public function new(x:Float, y:Float, altAnimations:Bool = false)
	{
		super(x, y);

		var animationStr:String = (altAnimations ? 'BG fangirls dissuaded' : 'BG girls group');

		frames = Paths.getSparrowAtlas('weeb/bgFreaks', 'week6');

		animation.addByIndices('danceLeft', animationStr, CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', animationStr, CoolUtil.numberArray(30, 15), "", 24, false);

		scrollFactor.set(0.9, 0.9);
		antialiasing = false;
		setGraphicSize(Std.int(width * 6));
		updateHitbox();

		animation.play('danceLeft');
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
