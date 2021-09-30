package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	// song names (in uppercase because why not, doesn't matter)

	public static var weekData:Array<Array<String>> = [
		['TUTORIAL'],
		['BOPEEBO', 'FRESH', 'DADBATTLE'],
		['SPOOKEEZ', 'SOUTH', 'MONSTER'],
		['PICO', 'PHILLY', 'BLAMMED'],
		['SATIN-PANTIES', 'HIGH', 'MILF'],
		['COCOA', 'EGGNOG', 'WINTER-HORRORLAND'],
		['SENPAI', 'ROSES', 'THORNS']
	];

	// left character, middle character and right character

	var weekCharacters:Array<Array<String>> = [
		['', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf', 'gf'],
		['senpai', 'bf', 'gf']
	];

	// doesn't affect gameplay so put whatever you want

	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('WEEKDATA/weekNames', 'preload'));

	// background color, set it to 0x00000000 so it uses the default yellow color

	var weekColors:Array<String> = CoolUtil.coolTextFile(Paths.txt('WEEKDATA/weekColors', 'preload'));


	/*
	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true]; // true values should be the same amount as your weeks (tutorial counts)
	*/

	public static var weekUnlocked:Array<Bool> = [];

	var curDifficulty:Int = 1;
	var curWeek:Int = 0;

	var scoreText:FlxText;
	var txtWeekTitle:FlxText;
	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var BG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFFFFFFF);

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		#if desktop
			DiscordClient.changePresence("In The Story Menu", null);
		#end

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu', 'preload'));
				Conductor.changeBPM(102);
			}
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, 'WEEK HIGHSCORE: 0', 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		var modversionText:FlxText = new FlxText(5, engineversionText.y - engineversionText.height, 0, MythsListEngineData.modVersion, 12);
		modversionText.scrollFactor.set();
		modversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(modversionText);

		var ui_tex = Paths.getSparrowAtlas('mainmenu/campaign_menu_UI_assets', 'preload');

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, BG.y + BG.height + 10, i);
			
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;

			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;

			if (!weekUnlocked[i] && i < weekUnlocked.length)
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
	
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;
			weekCharacterThing.alpha = 1;
	
			switch(weekCharacterThing.character)
			{
				case 'dad' | 'gf' | '':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
			}
	
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.updateHitbox();
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty(0);
		sprDifficulty.updateHitbox();
		difficultySelectors.add(sprDifficulty);

		sprDifficulty.x += 2;

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 3, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.updateHitbox();
		difficultySelectors.add(rightArrow);

		txtTracklist = new FlxText(FlxG.width * 0.05, BG.x + BG.height + 100, 0, 'TRACKS:', 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.setFormat(Paths.font("vcr.ttf"), 32);
		txtTracklist.color = 0xFFFFFFFF;
		txtTracklist.antialiasing = true;

		add(BG);
		add(grpWeekCharacters);
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);

		changeWeek(0);
		updateText();

		super.create();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = 'WEEK HIGHSCORE:' + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack && !selectedWeek)
		{
			if (controls.UP_P)
				changeWeek(-1);
			
			if (controls.DOWN_P)
				changeWeek(1);

			if (controls.LEFT)
				leftArrow.animation.play('press')
			else
				leftArrow.animation.play('idle');

			if (controls.RIGHT)
				rightArrow.animation.play('press');
			else
				rightArrow.animation.play('idle');

			if (controls.LEFT_P)
				changeDifficulty(-1);

			if (controls.RIGHT_P)
				changeDifficulty(1);

			if (controls.BACK)
			{
				movedBack = true;
				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek] || curWeek >= weekUnlocked.length)
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

				grpWeekText.members[curWeek].startFlashing();

				var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + 1) - 150, 'bfConfirm');

				weekCharacterThing.y += 70;
				weekCharacterThing.antialiasing = true;
				weekCharacterThing.alpha = 1;

				weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
				weekCharacterThing.updateHitbox();

				weekCharacterThing.x -= 80;

				grpWeekCharacters.remove(grpWeekCharacters.members[1]);
				grpWeekCharacters.add(weekCharacterThing);

				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek].copy();
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic:Array<String> = ['-easy', '', '-hard'];

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic[curDifficulty], PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
		else
		{
			FlxG.camera.shake(0.02, 0.02);
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = -53;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 0;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = -48;
		}

		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;

			bullShit++;
		}

		if (FlxColor.fromString(weekColors[curWeek]) != 0x00000000 || weekColors[curWeek] != null)
			BG.color = FlxColor.fromString(weekColors[curWeek]);
		else
			BG.color = 0xFFfde871;

		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'));

		updateText();
	}

	function updateText()
	{
		var newMenuChar:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * 1 - 150, weekCharacters[curWeek][0]);

		newMenuChar.y += 70;
		newMenuChar.antialiasing = true;
		newMenuChar.alpha = 1;

		newMenuChar.setGraphicSize(Std.int(newMenuChar.width * 0.5));
		newMenuChar.updateHitbox();

		grpWeekCharacters.remove(grpWeekCharacters.members[0]);
		grpWeekCharacters.add(newMenuChar);

		switch(grpWeekCharacters.members[0].character.toLowerCase())
		{
			case 'parents-christmas':
				grpWeekCharacters.members[0].offset.set(400, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.7));
			case 'senpai':
				grpWeekCharacters.members[0].offset.set(120, -50);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.6));
			case 'mom':
				grpWeekCharacters.members[0].offset.set(100, 230);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			case 'dad':
				grpWeekCharacters.members[0].offset.set(120, 200);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			case 'pico':
				grpWeekCharacters.members[0].flipX = true;
				grpWeekCharacters.members[0].offset.set(120, 50);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			case 'spooky':
				grpWeekCharacters.members[0].offset.set(150, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
		}

		txtTracklist.text = 'TRACKS:\n';

		var stringThing:Array<String> = weekData[curWeek];

		for (i in 0...stringThing.length + 1)
		{
			txtTracklist.text += '\n' + stringThing[i].toUpperCase();
		}

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	public static function updateWeekUnlocked()
	{
		for (i in 0...weekData.length)
		{
			weekUnlocked.push(true);
		}
	}
}