package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;

	var diffText:FlxText;
	var leftArrow:FlxText;
	var rightArrow:FlxText;

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var curWeekfp:Int = WeekselectState.curWeek;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));

		/*
		THIS IS WHERE YOU ADD YOUR SONGS IN THAT MENU
		{source guide on gamebanana should be useful for that}

		format : (song names, week number, character names)

		You can also change the background's color with 'bg.color = hex color code,
		it will defaults to white if you didn't add a line to change the color
		*/

		bg.color = 0xFFFFFFFF;

		switch (curWeekfp)
		{
			case 0:
				if (StoryMenuState.weekUnlocked[0] || isDebug)
					addWeek(['TUTORIAL'], 0, ['gf']);

				bg.color = 0xFF7f003b;
			case 1:
				if (StoryMenuState.weekUnlocked[1] || isDebug)
					addWeek(['BOPEEBO', 'FRESH', 'DADBATTLE'], 1, ['dad']);

				bg.color = 0xFFaf66ce;
			case 2:
				if (StoryMenuState.weekUnlocked[2] || isDebug)
					addWeek(['SPOOKEEZ', 'SOUTH', 'MONSTER'], 2, ['spooky', 'spooky', 'monster']);

				bg.color = 0xFFd56a00;
			case 3:
				if (StoryMenuState.weekUnlocked[3] || isDebug)
					addWeek(['PICO', 'PHILLY', 'BLAMMED'], 3, ['pico']);

				bg.color = 0xFFb7d855;
			case 4:
				if (StoryMenuState.weekUnlocked[4] || isDebug)
					addWeek(['SATIN-PANTIES', 'HIGH', 'MILF'], 4, ['mom']);

				bg.color = 0xFFd8558e;
			case 5: 
				if (StoryMenuState.weekUnlocked[5] || isDebug)
					addWeek(['COCOA', 'EGGNOG', 'WINTER-HORRORLAND'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

				bg.color = 0xFFf3ff6e;
			case 6: 
				if (StoryMenuState.weekUnlocked[6] || isDebug)
					addWeek(['SENPAI', 'ROSES', 'THORNS'], 6, ['senpai', 'senpai-angry', 'spirit']);

				bg.color = 0xFFffaa6f;
		}

		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		var scoreBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 0.25), 70, 0xFF000000);
		scoreBG.alpha = 0.25;
		scoreBG.screenCenter(X);
		add(scoreBG);

		scoreText = new FlxText(scoreBG.x + 5, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		add(scoreText);

		leftArrow = new FlxText(scoreBG.x + 5, scoreText.y + 35, 0, "<", 24);
		leftArrow.font = scoreText.font;
		add(leftArrow);

		diffText = new FlxText(leftArrow.width + leftArrow.x + 5, leftArrow.y, 0, "NORMAL", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(diffText);

		rightArrow = new FlxText(diffText.width + diffText.x + 5, diffText.y, 0, ">", 24);
		rightArrow.font = scoreText.font;
		add(rightArrow);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		var modversionText:FlxText = new FlxText(5, engineversionText.y - engineversionText.height, 0, MythsListEngineData.modVersion, 12);
		modversionText.scrollFactor.set();
		modversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(modversionText);

		changeSelection(0);
		changeDiff(0);

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['face'];

		var num:Int = 0;
		
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "HIGHSCORE:" + lerpScore;

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.LEFT_P)
			changeDiff(-1);

		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
			FlxG.switchState(new WeekselectState());

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			LoadingState.loadAndSwitchState(new PlayState(), false);
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = 'EASY';
				diffText.color = 0xFF00FF00;
			case 1:
				diffText.text = 'NORMAL';
				diffText.color = 0xFFFFFF00;
			case 2:
				diffText.text = 'HARD';
				diffText.color = 0xFFFF0000;
		}

		diffText.x = leftArrow.width + leftArrow.x + 5;
		diffText.y = leftArrow.y;

		rightArrow.x = diffText.width + diffText.x + 5;
		rightArrow.y = diffText.y;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}