package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;

		switch (PlayState.SONG.song.toLowerCase())
		{	
			case 'senpai':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

			case 'roses':
				hasDialog = true;

				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

			case 'thorns':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

			case 'sl-ao' | 'strange-activity' | 'destruction-program':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-cube');
				box.animation.addByPrefix('normalOpen', 'A Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'A Text Box Appear', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
			{
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();

				add(portraitLeft);

				portraitLeft.visible = false;
	
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();

				add(portraitRight);

				portraitRight.visible = false;
			}
			case 'sl-ao' | 'strange-activity' | 'destruction-program':
			{
				portraitLeft = new FlxSprite(-100, 125);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/cubePortrait');
				portraitLeft.animation.addByPrefix('enter', 'Cube Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();

				add(portraitLeft);

				portraitLeft.visible = false;
	
				portraitRight = new FlxSprite(725, 175);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortraitNoPixel');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.189));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();

				add(portraitRight);

				portraitRight.visible = false;
			}
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();

		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		/*
		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);
		*/

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
			{
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);

				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFFD89494;

				add(dropText);
				
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF3F2021;

				add(swagDialogue);
			}
			case 'sl-ao' | 'strange-activity' | 'destruction-program':
			{
				dropText = new FlxText(242, 482, Std.int(FlxG.width * 0.6), "", 32);

				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFF4b4b4b;

				add(dropText);
				
				swagDialogue = new FlxTypeText(240, 480, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF323232;

				add(swagDialogue);
			}
		}
		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'roses':
			{
				portraitLeft.visible = false;
			}
			case 'thorns':
			{
				portraitLeft.color = FlxColor.BLACK;
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			}
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
