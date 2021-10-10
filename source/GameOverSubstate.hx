package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = '';
	var altLibrary:String = '';

	var daBf:String = 'bf';

	public function new(x:Float, y:Float, character:String)
	{
		super();

		daBf = character;

		if (daBf == 'bf-pixel')
			daBf += '-dead';

		switch(daBf)
		{
			case 'bf-pixel-dead':
				stageSuffix = '-pixel';
				altLibrary = 'week6';
			case 'bf':
				altLibrary = 'shared';
			default:
				daBf = 'bf';
				altLibrary = 'shared';
		}

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix, 'shared'));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			remove(camFollow);
			remove(bf);

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath')
		{
			if (bf.animation.curAnim.curFrame == 12)
				FlxG.camera.follow(camFollow, LOCKON, 0.01);

			if (bf.animation.curAnim.finished)
				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix, altLibrary));
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix, altLibrary));

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					remove(camFollow);
					remove(bf);

					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			});
		}
	}
}
