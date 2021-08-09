package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import PlayState;

class GameOverState extends FlxTransitionableState
{
	var bfX:Float = 0;
	var bfY:Float = 0;

	public function new(x:Float, y:Float)
	{
		super();

		bfX = x;
		bfY = y;
	}

	override function create()
	{
		var bf:Boyfriend = new Boyfriend(bfX, bfY);
		add(bf);

		bf.playAnim('firstDeath');

		FlxG.camera.follow(bf, LOCKON, 0.001);
		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		super.create();
	}

	private var fading:Bool = false;

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			fading = true;
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}
		
		super.update(elapsed);
	}
}
