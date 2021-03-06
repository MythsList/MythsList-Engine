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

class WeekselectState extends MusicBeatState
{
	var weeks:Array<WeekMetadata> = [];

	var curSelected:Int = 0;
	public static var curWeek:Int = 0;

	var isDebug:Bool = false;
	private var curPlaying:Bool = false;

	private var grpWeeks:FlxTypedGroup<Alphabet>;
	private var iconArray:FlxTypedGroup<HealthIcon>;

	override function create()
	{
		#if desktop
			DiscordClient.changePresence("In The Week Selection Menu", null);
		#end

		#if debug
			isDebug = true;
		#end

		/*
		THIS IS WHERE YOU ADD YOUR WEEKS IN THAT MENU
		{the week name doesn't matter, change it to whatever you want}

		format : (character name, week name)
		*/

		var weekData:Array<Dynamic> = [
			['gf', 'TUTORIAL'],
			['dad', 'VS DOUBLE D'],
			['spooky', 'SPOOKY MONTH'],
			['pico', 'NG SHOWDOWN'],
			['mom', 'VS DOUBLE M'],
			['parents', 'UNHOLY XMAS'],
			['senpai', 'HATING SIMULATOR']
		];

		for (i in 0...weekData.length)
		{
			if (StoryMenuState.weekUnlocked[i] || isDebug)
				addWeek(i, weekData[i][0], weekData[i][1]);
		}

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue', 'preload'));
		bg.antialiasing = true;
		add(bg);

		grpWeeks = new FlxTypedGroup<Alphabet>();
		add(grpWeeks);

		iconArray = new FlxTypedGroup<HealthIcon>();
		add(iconArray);

		for (i in 0...weeks.length)
		{
			var weekText:Alphabet = new Alphabet(0, (70 * i) + 30, weeks[i].weekName, true, false);
			weekText.isMenuItem = true;
			weekText.targetY = i;
			grpWeeks.add(weekText);

			var icon:HealthIcon = new HealthIcon(weeks[i].songCharacters, false, true);
			icon.ID = i;
			icon.sprTracker = weekText;
			iconArray.add(icon);
		}

		var scoreBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 42, 0xFF000000);
		scoreBG.alpha = 0.25;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		var titleText:FlxText = new FlxText(0, scoreBG.y + 5, 0, 'WEEK SELECTION', 32);
		titleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		add(titleText);

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		changeSelection();

		super.create();
	}

	public function addWeek(weekNum:Int, songCharacters:String, weekName:String)
	{
		if (songCharacters == null)
			songCharacters = 'face';

		if (weekName == null)
			weekName = 'PLACEHOLDER';

		weeks.push(new WeekMetadata(weekNum, songCharacters, weekName));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (controls.UP_P)
			changeSelection(-1);

		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (controls.ACCEPT)
		{
			if (StoryMenuState.weekUnlocked[curSelected] || isDebug)
			{
				FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
			
				curWeek = curSelected;
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = weeks.length - 1;
		else if (curSelected >= weeks.length)
			curSelected = 0;

		var bullShit:Int = 0;

		iconArray.forEach(function(spr:FlxSprite)
		{					
			spr.alpha = (spr.ID == curSelected ? 1 : 0.6);
			spr.animation.curAnim.curFrame = (spr.ID == curSelected ? 2 : 0);
		});

		for (item in grpWeeks.members)
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

class WeekMetadata
{
	public var weekNum:Int = 0;
	public var songCharacters:String = "";
	public var weekName:String = "";

	public function new(weekNum:Int, songCharacters:String, weekName:String)
	{
		this.weekNum = weekNum;
		this.songCharacters = songCharacters;
		this.weekName = weekName;
	}
}