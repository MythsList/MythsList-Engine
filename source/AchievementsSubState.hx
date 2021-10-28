package;

#if desktop
import Discord.DiscordClient;
#end
import Controls;
import Controls.Control;
import flixel.FlxG;
import MythsListEngineData;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flash.text.TextField;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import lime.utils.Assets;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class AchievementsSubState extends MusicBeatSubstate
{
	/*
	WARNING :
	To make your achievement work, you have to change the data format in MythsListEngineData.hx to
	make it match the arrays below then, add how you should be able to unlock it like i did in PlayState.hx.
	I know, it's complicated. It needs some coding knowledge.
	*/

	var achievements:Array<Array<String>> = [
		['fc', 'fc', 'fc', 'fc', 'fc'],
		['play', 'play', 'play', 'play', 'play'],
		['death', 'death', 'death', 'death', 'death'],
		['upscroll', 'downscroll', 'middlescroll', 'upmiddlescroll', 'downmiddlescroll']
	];

	var frames:Array<Array<String>> = [
		['bronze', 'silver', 'gold', 'diamond', 'ruby'],
		['bronze', 'silver', 'gold', 'diamond', 'ruby'],
		['bronze', 'silver', 'gold', 'diamond', 'ruby'],
		['bronze', 'bronze', 'silver', 'gold', 'gold']
	];

	var grpIcons:FlxTypedGroup<FlxSprite>;
	var grpFrames:FlxTypedGroup<FlxSprite>;

	var curselectBG:FlxSprite;

	var curSelected:Int = 0;
	var curCategory:Int = 0;

	var curName:FlxText;
	var curGoal:FlxText;
	var curProgress:FlxText;

	var descList:Array<String>;

	public function new()
	{
		super();

		#if desktop
			DiscordClient.changePresence("In The Achievements Menu", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat', 'preload'));
		menuBG.color = 0xFF71fd89;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		curselectBG = new FlxSprite(0, 0).makeGraphic(75, 75, 0xFFFFFFFF);
		curselectBG.alpha = 0.8;
		add(curselectBG);

		grpIcons = new FlxTypedGroup<FlxSprite>();
		add(grpIcons);
		grpFrames = new FlxTypedGroup<FlxSprite>();
		add(grpFrames);

		for (i in 0...achievements.length)
		{
			for (p in 0...achievements[i].length)
			{
				var achievementIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('achievementassets/icons/icon-' + achievements[i][p], 'preload'), false, 50, 50);
				achievementIcon.antialiasing = true;
				achievementIcon.updateHitbox();
				grpIcons.add(achievementIcon);

				if (i == 0)
					achievementIcon.y = 100;
				else if (i > 0)
					achievementIcon.y = 100 + (100 * i);
		
				if (p == 0)
					achievementIcon.x = 100;
				else if (p > 0)
					achievementIcon.x = 100 + (100 * p);
		
				var achievementFrame:FlxSprite = new FlxSprite((achievementIcon.getGraphicMidpoint().x) - 64/2, (achievementIcon.getGraphicMidpoint().y) - 64/2).loadGraphic(Paths.image('achievementassets/frames/frame-' + frames[i][p], 'preload'), false, 65, 65);
				achievementFrame.antialiasing = true;
				achievementFrame.updateHitbox();
				grpFrames.add(achievementFrame);
	
				if (MythsListEngineData.dataAchievements[i][p])
				{
					achievementIcon.alpha = 1;
					achievementFrame.alpha = 1;
				}
				else
				{
					achievementIcon.alpha = 0.6;
					achievementFrame.alpha = 0.6;
				}	
			}
		}

		var curBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 2), FlxG.height, 0xFF000000);
		curBG.alpha = 0.25;
		add(curBG);
		curBG.x = FlxG.width - curBG.width;

		curName = new FlxText(curBG.x + 5, curBG.y + 5, FlxG.width / 2 - 10, 'PlaceHolder Name', 26);
		curName.scrollFactor.set();
		curName.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curName.antialiasing = true;
		add(curName);

		curGoal = new FlxText(curName.x, curName.y + (26 * 3), FlxG.width / 2 - 10, 'PlaceHolder Goal', 26);
		curGoal.scrollFactor.set();
		curGoal.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curGoal.antialiasing = true;
		add(curGoal);

		curProgress = new FlxText(curName.x, curGoal.y + (26 * 3), FlxG.width / 2 - 10, 'PlaceHolder Progress', 26);
		curProgress.scrollFactor.set();
		curProgress.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curProgress.antialiasing = true;
		add(curProgress);

		var noteText:FlxText = new FlxText(0, 0, 0, 'Note : If your achievements are not showing, this is due to V.1.0.9 changing the code entirely', 12);
		noteText.scrollFactor.set();
		noteText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(noteText);
		noteText.x = FlxG.width - noteText.width - 5;
		noteText.y = FlxG.height - noteText.height - 3;

		var engineversionText:FlxText = new FlxText(5, FlxG.height - 18, 0, "MythsList Engine - " + MythsListEngineData.engineVersion, 12);
		engineversionText.scrollFactor.set();
		engineversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(engineversionText);

		var modversionText:FlxText = new FlxText(5, engineversionText.y - engineversionText.height, 0, MythsListEngineData.modVersion, 12);
		modversionText.scrollFactor.set();
		modversionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT);
		add(modversionText);

		changeCategory(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.LEFT_P)
			changeSelection(-1);
		if (controls.RIGHT_P)
			changeSelection(1);

		if (controls.UP_P)
			changeCategory(-1);
		if (controls.DOWN_P)
			changeCategory(1);

		if (controls.BACK)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new OptionsSubState());
		}
	}

	function changeSelection(change:Int = 0, reset:Bool = false)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		if (reset)
			curSelected = 0;

		curSelected += change;

		if (curSelected < 0)
			curSelected = achievements[curCategory].length - 1;
		else if (curSelected >= achievements[curCategory].length)
			curSelected = 0;

		var curIconName:String = achievements[curCategory][curSelected];

		for (p in 0...achievements.length)
		{
			for (i in 0...achievements[curCategory].length)
			{
				if (i == curSelected)
				{
					var posY:Int = 0;

					if (curCategory == 0)
						posY = i;
					else
						posY = i + (5 * curCategory); //The number should be replaced by the highest amount of achievements in an array

					curselectBG.x = (grpIcons.members[i].getGraphicMidpoint().x) - 74/2;
					curselectBG.y = (grpIcons.members[posY].getGraphicMidpoint().y) - 74/2;

					descList = CoolUtil.coolTextFile(Paths.txt('ACHIEVEMENTDATA/achievementDescriptions' + (curCategory + 1)));
		
					var achievementInfos:Array<String> = descList[i].split('|');

					curName.text = achievementInfos[0];
					curGoal.text = achievementInfos[1];
				}
			}
		}

		switch(curIconName)
		{
			case 'fc':
				curProgress.text = "Amount of songs you've FC'd: " + MythsListEngineData.fcAmount;
			case 'play':
				curProgress.text = "Amount of songs you've played: " + MythsListEngineData.playAmount;
			case 'death':
				curProgress.text = "Amount of times you've died: " + MythsListEngineData.deathAmount;
			case 'upscroll':
				curProgress.text = "Played with upscroll: " + MythsListEngineData.playUpscroll;
			case 'downscroll':
				curProgress.text = "Played with downscroll: " + MythsListEngineData.playDownscroll;
			case 'middlescroll':
				curProgress.text = "Played with middlescroll: " + MythsListEngineData.playMiddlescroll;
			case 'upmiddlescroll':
				curProgress.text = "Played with upscroll and middlescroll: " + MythsListEngineData.playUpMiddlescroll;
			case 'downmiddlescroll':
				curProgress.text = "Played with downscroll and middlescroll: " + MythsListEngineData.playDownMiddlescroll;
		}

		curGoal.y = curName.y + curName.height + 26;
		curProgress.y = curGoal.y + curGoal.height + 26;
	}

	function changeCategory(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curCategory += change;

		if (curCategory < 0)
			curCategory = achievements.length - 1;
		else if (curCategory >= achievements.length)
			curCategory = 0;

		changeSelection(0, true);
	}
}