package;

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
	var achievementsCategoryOne:Array<String> = ['fc', 'fc', 'fc', 'fc', 'fc'];
	var framesCategoryOne:Array<String> = ['bronze', 'silver', 'gold', 'diamond', 'ruby'];
	var grpIconsOne:FlxTypedGroup<FlxSprite>;
	var grpFramesOne:FlxTypedGroup<FlxSprite>;

	var achievementsCategoryTwo:Array<String> = ['play', 'play', 'play', 'play', 'play'];
	var framesCategoryTwo:Array<String> = ['bronze', 'silver', 'gold', 'diamond', 'ruby'];
	var grpIconsTwo:FlxTypedGroup<FlxSprite>;
	var grpFramesTwo:FlxTypedGroup<FlxSprite>;

	var achievementsCategoryThree:Array<String> = ['death', 'death', 'death', 'death', 'death'];
	var framesCategoryThree:Array<String> = ['bronze', 'silver', 'gold', 'diamond', 'ruby'];
	var grpIconsThree:FlxTypedGroup<FlxSprite>;
	var grpFramesThree:FlxTypedGroup<FlxSprite>;

	var achievementsCategoryFour:Array<String> = ['upscroll', 'downscroll', 'middlescroll'];
	var framesCategoryFour:Array<String> = ['bronze', 'bronze', 'silver'];
	var grpIconsFour:FlxTypedGroup<FlxSprite>;
	var grpFramesFour:FlxTypedGroup<FlxSprite>;

	var curselectBG:FlxSprite;

	var curIconName:String;

	var curSelected:Int = 0;
	var curDesc:Int = 0;

	var curCatSelected:Int = 1;
	var curCategory:String = 'One';

	var descList = CoolUtil.coolTextFile(Paths.txt('achievementDescriptions'));

	var curtext:FlxText;
	var curName:FlxText;
	var curProgress:FlxText;

	var achievementInfos:Array<String>;

	/*
	I DO NOT RECOMMEND ADDING YOUR OWN ACHIEVEMENTS UNLESS YOU KNOW WHAT YOU ARE DOING
	FOR THE MOMENT THIS CODE ISNT MEANT TO BE CHANGED BECAUSE THE CODE IS BAD LOL
	*/

	public function new()
	{
		super();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFF71fd89;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		curselectBG = new FlxSprite(0, 0).makeGraphic(75, 75, 0xFFFFFFFF);
		curselectBG.alpha = 0.8;
		add(curselectBG);
		
		// Ugly code, cry about it

		grpIconsOne = new FlxTypedGroup<FlxSprite>();
		add(grpIconsOne);
		grpFramesOne = new FlxTypedGroup<FlxSprite>();
		add(grpFramesOne);

		grpIconsTwo = new FlxTypedGroup<FlxSprite>();
		add(grpIconsTwo);
		grpFramesTwo = new FlxTypedGroup<FlxSprite>();
		add(grpFramesTwo);

		grpIconsThree = new FlxTypedGroup<FlxSprite>();
		add(grpIconsThree);
		grpFramesThree = new FlxTypedGroup<FlxSprite>();
		add(grpFramesThree);

		grpIconsFour = new FlxTypedGroup<FlxSprite>();
		add(grpIconsFour);
		grpFramesFour = new FlxTypedGroup<FlxSprite>();
		add(grpFramesFour);

		for (i in 0...achievementsCategoryOne.length)
		{
			var achievementIcon:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('achievementassets/icons/icon-' + achievementsCategoryOne[i]), false, 50, 50);
			achievementIcon.antialiasing = true;
			achievementIcon.updateHitbox();
			grpIconsOne.add(achievementIcon);

			if (i == 0)
				achievementIcon.x = 100;
			else if (i > 0)
				achievementIcon.x = grpIconsOne.members[0].x + (100 * i);

			var achievementFrame:FlxSprite = new FlxSprite((achievementIcon.getGraphicMidpoint().x) - 64/2, (achievementIcon.getGraphicMidpoint().y) - 64/2).loadGraphic(Paths.image('achievementassets/frames/frame-' + framesCategoryOne[i]), false, 65, 65);
			achievementFrame.antialiasing = true;
			achievementFrame.updateHitbox();
			grpFramesOne.add(achievementFrame);

			if (MythsListEngineData.dataCategoryOne[i])
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

		for (i in 0...achievementsCategoryTwo.length)
		{
			var achievementIcon:FlxSprite = new FlxSprite(0, 200).loadGraphic(Paths.image('achievementassets/icons/icon-' + achievementsCategoryTwo[i]), false, 50, 50);
			achievementIcon.antialiasing = true;
			achievementIcon.updateHitbox();
			grpIconsTwo.add(achievementIcon);

			if (i == 0)
				achievementIcon.x = 100;
			else if (i > 0)
				achievementIcon.x = grpIconsTwo.members[0].x + (100 * i);

			var achievementFrame:FlxSprite = new FlxSprite((achievementIcon.getGraphicMidpoint().x) - 64/2, (achievementIcon.getGraphicMidpoint().y) - 64/2).loadGraphic(Paths.image('achievementassets/frames/frame-' + framesCategoryTwo[i]), false, 65, 65);
			achievementFrame.antialiasing = true;
			achievementFrame.updateHitbox();
			grpFramesTwo.add(achievementFrame);

			if (MythsListEngineData.dataCategoryTwo[i])
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

		for (i in 0...achievementsCategoryThree.length)
		{
			var achievementIcon:FlxSprite = new FlxSprite(0, 300).loadGraphic(Paths.image('achievementassets/icons/icon-' + achievementsCategoryThree[i]), false, 50, 50);
			achievementIcon.antialiasing = true;
			achievementIcon.updateHitbox();
			grpIconsThree.add(achievementIcon);
	
			if (i == 0)
				achievementIcon.x = 100;
			else if (i > 0)
				achievementIcon.x = grpIconsThree.members[0].x + (100 * i);
	
			var achievementFrame:FlxSprite = new FlxSprite((achievementIcon.getGraphicMidpoint().x) - 64/2, (achievementIcon.getGraphicMidpoint().y) - 64/2).loadGraphic(Paths.image('achievementassets/frames/frame-' + framesCategoryThree[i]), false, 65, 65);
			achievementFrame.antialiasing = true;
			achievementFrame.updateHitbox();
			grpFramesThree.add(achievementFrame);

			if (MythsListEngineData.dataCategoryThree[i])
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

		for (i in 0...achievementsCategoryFour.length)
		{
			var achievementIcon:FlxSprite = new FlxSprite(0, 400).loadGraphic(Paths.image('achievementassets/icons/icon-' + achievementsCategoryFour[i]), false, 50, 50);
			achievementIcon.antialiasing = true;
			achievementIcon.updateHitbox();
			grpIconsFour.add(achievementIcon);
		
			if (i == 0)
				achievementIcon.x = 100;
			else if (i > 0)
				achievementIcon.x = grpIconsFour.members[0].x + (100 * i);
		
			var achievementFrame:FlxSprite = new FlxSprite((achievementIcon.getGraphicMidpoint().x) - 64/2, (achievementIcon.getGraphicMidpoint().y) - 64/2).loadGraphic(Paths.image('achievementassets/frames/frame-' + framesCategoryFour[i]), false, 65, 65);
			achievementFrame.antialiasing = true;
			achievementFrame.updateHitbox();
			grpFramesFour.add(achievementFrame);
	
			if (MythsListEngineData.dataCategoryFour[i])
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

		var curBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 2), 150, 0xFF000000);
		curBG.alpha = 0.25;
		add(curBG);

		curBG.x = FlxG.width - curBG.width;

		achievementInfos = descList[curDesc].split('|');

		curName = new FlxText(curBG.x + 5, curBG.y + 5, 0, achievementInfos[0], 26);
		curName.scrollFactor.set();
		curName.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curName.antialiasing = true;
		add(curName);

		curtext = new FlxText(curBG.x + 5, (curBG.height / 2) - 13, 0, achievementInfos[1], 26);
		curtext.scrollFactor.set();
		curtext.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curtext.antialiasing = true;
		add(curtext);

		curProgress = new FlxText(curtext.x, (curBG.y + curBG.height) - curtext.height - 5, 0, "PlaceHolder", 26);
		curProgress.scrollFactor.set();
		curProgress.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT);
		curProgress.antialiasing = true;
		add(curProgress);

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
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (reset)
			curSelected = 0;

		curSelected += change;

		switch(curCategory)
		{
			case 'One':
			{
				if (curSelected < 0)
					curSelected = achievementsCategoryOne.length - 1;
				if (curSelected >= achievementsCategoryOne.length)
					curSelected = 0;

				curDesc = curSelected;
				curIconName = achievementsCategoryOne[curSelected];

				for (i in 0...achievementsCategoryOne.length)
				{
					if (i == curSelected)
					{
						curselectBG.x = (grpIconsOne.members[i].getGraphicMidpoint().x) - 74/2;
						curselectBG.y = (grpIconsOne.members[i].getGraphicMidpoint().y) - 74/2;
				
						achievementInfos = descList[curDesc].split('|');

						curName.text = achievementInfos[0];
						curtext.text = achievementInfos[1];
					}
				}
			}
			case 'Two':
			{
				if (curSelected < 0)
					curSelected = achievementsCategoryTwo.length - 1;
				if (curSelected >= achievementsCategoryTwo.length)
					curSelected = 0;

				curDesc = curSelected + achievementsCategoryOne.length;
				curIconName = achievementsCategoryTwo[curSelected];

				for (i in 0...achievementsCategoryTwo.length)
				{
					if (i == curSelected)
					{
						curselectBG.x = (grpIconsTwo.members[i].getGraphicMidpoint().x) - 74/2;
						curselectBG.y = (grpIconsTwo.members[i].getGraphicMidpoint().y) - 74/2;
				
						achievementInfos = descList[curDesc].split('|');

						curName.text = achievementInfos[0];
						curtext.text = achievementInfos[1];
					}
				}
			}
			case 'Three':
			{
				if (curSelected < 0)
					curSelected = achievementsCategoryThree.length - 1;
				if (curSelected >= achievementsCategoryThree.length)
					curSelected = 0;

				curDesc = curSelected + (achievementsCategoryOne.length + achievementsCategoryTwo.length);
				curIconName = achievementsCategoryThree[curSelected];

				for (i in 0...achievementsCategoryThree.length)
				{
					if (i == curSelected)
					{
						curselectBG.x = (grpIconsThree.members[i].getGraphicMidpoint().x) - 74/2;
						curselectBG.y = (grpIconsThree.members[i].getGraphicMidpoint().y) - 74/2;
				
						achievementInfos = descList[curDesc].split('|');

						curName.text = achievementInfos[0];
						curtext.text = achievementInfos[1];
					}
				}
			}
			case 'Four':
			{
				if (curSelected < 0)
					curSelected = achievementsCategoryFour.length - 1;
				if (curSelected >= achievementsCategoryFour.length)
					curSelected = 0;

				curDesc = curSelected + (achievementsCategoryOne.length + achievementsCategoryTwo.length + achievementsCategoryThree.length);
				curIconName = achievementsCategoryFour[curSelected];

				for (i in 0...achievementsCategoryFour.length)
				{
					if (i == curSelected)
					{
						curselectBG.x = (grpIconsFour.members[i].getGraphicMidpoint().x) - 74/2;
						curselectBG.y = (grpIconsFour.members[i].getGraphicMidpoint().y) - 74/2;
				
						achievementInfos = descList[curDesc].split('|');

						curName.text = achievementInfos[0];
						curtext.text = achievementInfos[1];
					}
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
		}
	}

	function changeCategory(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curCatSelected += change;

		if (curCatSelected < 1)
			curCatSelected = 4;
		if (curCatSelected > 4)
			curCatSelected = 1;

		switch(curCatSelected)
		{
			case 1:
				curCategory = 'One';
			case 2:
				curCategory = 'Two';
			case 3:
				curCategory = 'Three';
			case 4:
				curCategory = 'Four';
		}

		changeSelection(0, true);
	}
}