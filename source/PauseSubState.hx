package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PauseSubState extends MusicBeatSubstate
{
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var menuItems:Array<String>;

	var canSelect:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		if (PlayState.isStoryMode)
			menuItems = ['Resume', 'Restart song', 'Exit to story menu', 'Exit to main menu', 'Exit to options menu'];
		else
			menuItems = ['Resume', 'Restart song', 'Exit to freeplay menu', 'Exit to main menu', 'Exit to options menu'];

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast', 'shared'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, '', 42);
		levelInfo.text = PlayState.SONG.song.toUpperCase();
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 42);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + levelInfo.height, 0, '', 32);
		levelDifficulty.text = '(' + CoolUtil.difficultyString() + ')';
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		new FlxTimer().start(0.4, function(tmr:FlxTimer)
		{
			canSelect = true;
		});
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
		
		if (controls.DOWN_P)
			changeSelection(1);

		if ((controls.PAUSE || controls.ACCEPT) && canSelect)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case 'Resume':
					close();
				case 'Restart song':
					FlxG.resetState();
				case 'Exit to main menu':
					FlxG.switchState(new MainMenuState());
				case 'Exit to story menu':
					FlxG.switchState(new StoryMenuState());
				case 'Exit to freeplay menu':
					FlxG.switchState(new FreeplayState());
				case 'Exit to options menu':
					FlxG.switchState(new OptionsSubState());
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}
