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

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var leftArrow:FlxText;
	var rightArrow:FlxText;

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var curWeekfp:Int = WeekselectState.curWeek;

	var isDebug:Bool = false;
	private var curPlaying:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var iconArray:FlxTypedGroup<HealthIcon>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Freeplay Menu", null);
		#end

		#if debug
			isDebug = true;
		#end

		MythsListEngineData.dataSave();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		bg.antialiasing = true;
		bg.color = 0xFFFFFFFF;
		add(bg);

		/*
		THIS IS WHERE YOU ADD YOUR SONGS IN THAT MENU
		{source guide on gamebanana should be useful for that}

		format : (song names, character names, background color)

		You can also change the background's color with 'bg.color = hex color code,
		it will defaults to white if you didn't add a line to change the color
		*/

		var songData:Array<Dynamic> = [
			[['TUTORIAL'], ['gf'], 0xFF7f003b],
			[['BOPEEBO', 'FRESH', 'DADBATTLE'], ['dad'], 0xFFaf66ce],
			[['SPOOKEEZ', 'SOUTH', 'MONSTER'], ['spooky', 'spooky', 'monster'], 0xFFd56a00],
			[['PICO', 'PHILLY', 'BLAMMED'], ['pico'], 0xFFb7d855],
			[['SATIN-PANTIES', 'HIGH', 'MILF'], ['mom'], 0xFFd8558e],
			[['COCOA', 'EGGNOG', 'WINTER-HORRORLAND'], ['parents', 'parents', 'monster'], 0xFFf3ff6e],
			[['SENPAI', 'ROSES', 'THORNS'], ['senpai', 'senpai-angry', 'spirit'], 0xFFffaa6f]
		];

		for (i in 0...songData.length)
		{
			if (curWeekfp == i)
			{
				if (StoryMenuState.weekUnlocked[i] || isDebug)
				{
					addWeek(songData[i][0], i, songData[i][1]);

					if (songData[i][2] != null)
						bg.color = songData[i][2];
				}
			}
		}

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		iconArray = new FlxTypedGroup<HealthIcon>();
		add(iconArray);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter, false, true);
			icon.ID = i;
			icon.sprTracker = songText;
			iconArray.add(icon);
		}

		scoreBG = new FlxSprite(0, 0).makeGraphic(2, 70, 0xFF000000);
		scoreBG.alpha = 0.25;
		scoreBG.screenCenter(X);
		add(scoreBG);

		scoreText = new FlxText(scoreBG.x + 5, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		add(scoreText);

		leftArrow = new FlxText(scoreBG.x + 5, scoreText.y + 35, 0, "<", 24);
		leftArrow.font = scoreText.font;
		leftArrow.antialiasing = MythsListEngineData.menuAntialiasing;
		add(leftArrow);

		diffText = new FlxText(leftArrow.width + leftArrow.x + 5, leftArrow.y, 0, "NORMAL", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		diffText.antialiasing = MythsListEngineData.menuAntialiasing;
		add(diffText);

		rightArrow = new FlxText(diffText.width + diffText.x + 5, diffText.y, 0, ">", 24);
		rightArrow.font = scoreText.font;
		rightArrow.antialiasing = MythsListEngineData.menuAntialiasing;
		add(rightArrow);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

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
		if (songs == null)
			songs = ['TUTORIAL'];

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

	var selected:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = 'HIGHSCORE:' + lerpScore;
		updateObjects();

		if (!selected)
		{
			if (controls.UP_P)
				changeSelection(-1);

			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.LEFT_P)
				changeDiff(-1);

			if (controls.RIGHT_P)
				changeDiff(1);

			if (controls.BACK)
			{
				selected = true;
				FlxG.switchState(new WeekselectState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));

				selected = true;

				var curCutscene:String = null;
				var hasCutscene:Bool = false;

				for (item in CoolUtil.startCutsceneArray)
				{
					if (item[0] == songs[curSelected].songName.toLowerCase() && item[3] == true)
					{
						curCutscene = item[1];
						hasCutscene = true;
					}
				}

				if (hasCutscene && curCutscene != null)
					startCutscene(curCutscene);
				else
					startSong();
			}
		}
	}

	function startSong()
	{
		var songName:String = songs[curSelected].songName.toLowerCase();
		var formattedSong:String = Highscore.formatSong(songName, curDifficulty);

		PlayState.SONG = Song.loadFromJson(formattedSong, songName);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		PlayState.storyWeek = songs[curSelected].week;
		LoadingState.loadAndSwitchState(new PlayState(), false);
	}

	function startCutscene(path:String):Void
	{
		var video:MP4Handler = new MP4Handler();

		video.playMP4(Paths.video(path));

		video.finishCallback = function()
		{
			startSong();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyArray.length - 1;
		else if (curDifficulty >= CoolUtil.difficultyArray.length)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName.toLowerCase(), curDifficulty);
		#end

		diffText.text = CoolUtil.difficultyArray[curDifficulty][0].toUpperCase();
		diffText.color = CoolUtil.difficultyArray[curDifficulty][2];

		updateObjects();
	}

	function changeSelection(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		else if (curSelected >= songs.length)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName.toLowerCase(), curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		iconArray.forEach(function(spr:FlxSprite)
		{					
			spr.alpha = (spr.ID == curSelected ? 1 : 0.6);
			spr.animation.curAnim.curFrame = (spr.ID == curSelected ? 2 : 0);
		});

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	function updateObjects()
	{
		scoreBG.scale.x = (scoreText.width + 12) / 2;
		scoreBG.updateHitbox();
		scoreBG.screenCenter(X);
		scoreText.x = scoreBG.x + 6;
		leftArrow.x = scoreText.x;
		diffText.x = leftArrow.x + leftArrow.width + 6;
		rightArrow.x = diffText.x + diffText.width + 6;
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