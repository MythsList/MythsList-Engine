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

class ResultsScreenSubState extends MusicBeatSubstate
{
	var music:FlxSound;

	public function new(daResults:Array<Int>, score:Int, misses:Int, accuracy:Float, rating:String)
	{
		super();

		music = new FlxSound().loadEmbedded(Paths.music('breakfast', 'shared'), true, true);
		music.volume = 0;
		music.play();

		FlxG.sound.list.add(music);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		bg.color = 0xFF525252;
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var resultsText:FlxText = new FlxText(5, 0, 0, 'RESULTS', 72);
		resultsText.scrollFactor.set();
		resultsText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resultsText.updateHitbox();
		add(resultsText);

		var results:FlxText = new FlxText(5, resultsText.height, FlxG.width, '', 48);
		results.text = 'Sicks: ' + daResults[0] + '\nGoods: ' + daResults[1] + '\nBads: ' + daResults[2] + '\nShits: ' + daResults[3];
		results.scrollFactor.set();
		results.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		results.updateHitbox();
		add(results);

		var levelInfo:FlxText = new FlxText(0, 155, 0, '', 124);
		levelInfo.text = PlayState.SONG.song.toUpperCase();
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 72, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelInfo.updateHitbox();
		levelInfo.screenCenter(X);
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(0, 155 + levelInfo.height, 0, '', 100);
		levelDifficulty.text = CoolUtil.difficultyArray[PlayState.storyDifficulty][0].toUpperCase() + ' DIFFICULTY';
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelDifficulty.updateHitbox();
		levelDifficulty.screenCenter(X);
		add(levelDifficulty);

		var stats:FlxText = new FlxText(0, levelDifficulty.y + levelDifficulty.height + 45, FlxG.width, '', 86);
		stats.text = (PlayState.isStoryMode ? 'Week ' : '') + 'Score: ' + score + '\nMisses: ' + misses + '\nAccuracy: ' + accuracy + '%\nRating: ' + rating;
		stats.scrollFactor.set();
		stats.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		stats.updateHitbox();
		stats.screenCenter(X);
		add(stats);

		var iconP1:HealthIcon = new HealthIcon(PlayState.SONG.player1, true, true);
		iconP1.setGraphicSize(Std.int(iconP1.width * 1.2));
		iconP1.updateHitbox();
		add(iconP1);

		var iconP2:HealthIcon = new HealthIcon(PlayState.SONG.player2, false, true);
		iconP2.setGraphicSize(Std.int(iconP2.width * 1.2));
		iconP2.updateHitbox();
		add(iconP2);

		resultsText.alpha = 0;
		results.alpha = 0;
		levelInfo.alpha = 0;
		levelDifficulty.alpha = 0;
		stats.alpha = 0;
		iconP1.alpha = 0;
		iconP2.alpha = 0;

		iconP1.setPosition(FlxG.width - iconP1.width - 10, FlxG.height - iconP1.height - 15);
		iconP2.setPosition(10, iconP1.y);

		FlxTween.tween(bg, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(resultsText, {alpha: 1, y: 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(levelInfo, {alpha: 1, y: levelInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(results, {alpha: 1, y: results.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
		FlxTween.tween(stats, {alpha: 1, y: stats.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.6});
		FlxTween.tween(iconP1, {alpha: 1, y: FlxG.height - iconP1.height - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.8});
		FlxTween.tween(iconP2, {alpha: 1, y: FlxG.height - iconP2.height - 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.8});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (music.volume < 0.5 && music != null)
			music.volume += 0.01 * elapsed;

		if (controls.ACCEPT)
		{
			music.destroy();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}
	}
}
