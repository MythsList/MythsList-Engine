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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var hasMusic:Bool = false;
	var isAnimated:Bool = false;

	var songName:String;

	var curCharacter:String = '';
	var curSide:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;
	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:Portrait;
	var leftposX:Float;
	var leftposY:Float;

	var portraitRight:Portrait;
	var rightposX:Float;
	var rightposY:Float;

	var bgFade:FlxSprite;

	public static var fadeStyle:String = 'basic';

	public function new(?dialogueList:Array<String>)
	{
		super();

		songName = PlayState.SONG.song.toLowerCase();

		bgFade = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));

		switch(songName)
		{
			case 'senpai' | 'roses' | 'thorns':
			{
				fadeStyle = 'pixel';

				if (songName == 'senpai' || songName == 'thorns')
				{
					var soundTrack:String = 'Lunchbox';
					hasMusic = true;

					if (songName == 'thorns')
						soundTrack += 'Scary';

					FlxG.sound.playMusic(Paths.music(soundTrack, 'week6'), 0);
				}
				
				if (hasMusic)
					FlxG.sound.music.fadeIn(1, 0, 0.8);

				bgFade.color = 0xFFB3DFd8;
			}
			default:
				fadeStyle = 'basic';

				bgFade.color = 0xFF000000;
		}
		
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		bgFade.screenCenter();
		add(bgFade);

		switch(fadeStyle)
		{
			case 'pixel':
			{
				new FlxTimer().start(0.83, function(tmr:FlxTimer)
				{
					bgFade.alpha += (1 / 5) * 0.7;

					if (bgFade.alpha > 0.7)
						bgFade.alpha = 0.7;
				}, 5);
			}
			case 'basic':
			{
				FlxTween.tween(bgFade, {alpha: 0.7}, 0.8);
			}
		}

		box = new FlxSprite(-20, 45);
		
		var hasDialog:Bool = false;
		
		isAnimated = false;

		switch(songName)
		{
			case 'senpai' | 'roses':
			{
				hasDialog = true;
				isAnimated = true;

				if (songName == 'roses')
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX', 'shared'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			}
			case 'thorns':
			{
				hasDialog = true;
				isAnimated = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil', 'week6');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.y -= 2 * PlayState.daPixelZoom * 0.9;
			}
			default:
			{
				hasDialog = true;
				isAnimated = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil', 'week6');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.y -= 2 * PlayState.daPixelZoom * 0.9;
			}
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		box.updateHitbox();
		box.screenCenter(X);

		// Consider not deleting the default portrait in the files (so bf) or else it won't work.
		// It is just to set up the system

		portraitLeft = updatePortraits('bf', false);
		portraitSetGraphicSize('bf', portraitLeft);
		portraitLeft.visible = false;
		add(portraitLeft);

		portraitRight = updatePortraits('bf', false);
		portraitSetGraphicSize('bf', portraitRight);
		portraitRight.visible = false;
		add(portraitRight);

		switch(songName)
		{
			case 'senpai' | 'roses' | 'thorns':
				leftposX = box.x + 250;
				leftposY = -100;
				rightposX = box.x + box.width - portraitRight.width - 250;
				rightposY = -100;
			default:
				leftposX = box.x + 250;
				leftposY = -100;
				rightposX = box.x + box.width - portraitRight.width - 250;
				rightposY = -100;
		}

		add(box);

		if (isAnimated)
			box.animation.play('normalOpen');

		switch(songName)
		{
			case 'senpai' | 'roses':
			{
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFFD89494;
				
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText', 'shared'), 0.6)];
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF3F2021;

				add(dropText);
				add(swagDialogue);
			}
			case 'thorns':
			{
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = FlxColor.BLACK;
				
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText', 'shared'), 0.6)];
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = FlxColor.WHITE;

				add(dropText);
				add(swagDialogue);
			}
			default:
			{
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0x00FFFFFF;
				
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText', 'shared'), 0.6)];
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFFFFFFFF;

				add(dropText);
				add(swagDialogue);
			}
		}

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (isAnimated && box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
				dialogueOpened = true;
		}
		else
			dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.anyJustPressed([SPACE, ENTER]) && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText', 'shared'), 0.75);

			if (dialogueList[0] != null && dialogueList[1] == null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (hasMusic)
					{
						switch(fadeStyle)
						{
							case 'pixel':
								FlxG.sound.music.fadeOut(2.2, 0);
							case 'basic':
								FlxG.sound.music.fadeOut(1.4, 0);
						}
					}

					switch(fadeStyle)
					{
						case 'pixel':
						{
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								box.alpha -= 1 / 5;
								bgFade.alpha -= 1 / 5 * 0.7;
								portraitLeft.visible = false;
								portraitRight.visible = false;
								swagDialogue.alpha -= 1 / 5;
								dropText.alpha = swagDialogue.alpha;
							}, 5);
						}
						case 'basic':
						{
							FlxTween.tween(box, {alpha: 0}, 0.2);
							FlxTween.tween(bgFade, {alpha: 0}, 0.2);
							FlxTween.tween(portraitLeft, {alpha: 0}, 0.2);
							portraitLeft.visible = false;
							FlxTween.tween(portraitRight, {alpha: 0}, 0.2);
							portraitRight.visible = false;
							FlxTween.tween(swagDialogue, {alpha: 0}, 0.2);
							FlxTween.tween(dropText, {alpha: 0}, 0.2);
						}
					}

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

		remove(portraitLeft);
		remove(portraitRight);

		switch(curSide)
		{
			case 'left':
			{
				portraitLeft = updatePortraits(curCharacter, false);

				portraitSetGraphicSize(curCharacter, portraitLeft);
				portraitLeft.setPosition(leftposX, leftposY);

				add(portraitLeft);
			}
			case 'right':
			{
				portraitRight = updatePortraits(curCharacter, true);

				portraitSetGraphicSize(curCharacter, portraitRight);
				portraitRight.setPosition(rightposX, rightposY);

				add(portraitRight);
			}
			case 'middle':
			{
				var splitPortrait:Array<String> = curCharacter.split('/');
				var portrait1:String = splitPortrait[0];
				var portrait2:String = splitPortrait[1];

				portraitLeft = updatePortraits(portrait1, false);
				portraitRight = updatePortraits(portrait2, true);

				portraitSetGraphicSize(portrait1, portraitLeft);
				portraitLeft.setPosition(leftposX, leftposY);

				portraitSetGraphicSize(portrait2, portraitRight);
				portraitRight.setPosition(rightposX, rightposY);

				add(portraitLeft);
				add(portraitRight);
			}
		}
	}

	function portraitSetGraphicSize(character:String = 'bf', object:Portrait)
	{
		switch(character)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit':
				object.setGraphicSize(Std.int(object.width * PlayState.daPixelZoom * 0.9));
		}

		object.updateHitbox();
		object.scrollFactor.set();
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(':');

		curSide = splitName[0];
		curCharacter = splitName[1];

		dialogueList[0] = splitName[2].trim();
	}

	function updatePortraits(curCharacter:String = 'bf', flipped:Bool = false):Portrait
	{
		var portrait:Portrait = new Portrait(curCharacter, flipped);
		
		return portrait;
	}
}