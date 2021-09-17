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

	var curCharacter:String = '';
	var curSide:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:Portrait;
	var portraitRight:Portrait;

	var bgFade:FlxSprite;
	public static var fadeStyle:String = 'basic';

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
			{
				fadeStyle = 'pixel';

				if (PlayState.SONG.song.toLowerCase() == 'senpai')
					FlxG.sound.playMusic(Paths.music('Lunchbox', 'week6'), 0);
				else if (PlayState.SONG.song.toLowerCase() == 'thorns')
					FlxG.sound.playMusic(Paths.music('LunchboxScary', 'week6'), 0);
				
				if (PlayState.SONG.song.toLowerCase() != 'roses')
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

		switch (fadeStyle)
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

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses':
			{
				hasDialog = true;

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX', 'shared'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			}
			case 'thorns':
			{
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil', 'week6');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.y -= 2 * PlayState.daPixelZoom * 0.9;
			}
			default:
			{
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil', 'week6');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.y -= 2 * PlayState.daPixelZoom * 0.9;
			}
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
			{
				portraitLeft = new Portrait(PlayState.SONG.player2, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();

				portraitLeft.x = box.x + 250;
				portraitLeft.y = -100;

				add(portraitLeft);

				portraitLeft.visible = false;
	
				portraitRight = new Portrait('bf-pixel', true);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();

				portraitRight.x = box.x + box.width - portraitRight.width - 250;
				portraitRight.y = -100;

				add(portraitRight);

				portraitRight.visible = false;
			}
			default:
			{
				portraitLeft = new Portrait('bf', false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();

				portraitLeft.x = box.x + 250;
				portraitLeft.y = -100;

				add(portraitLeft);

				portraitLeft.visible = false;
	
				portraitRight = new Portrait('bf', true);
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();

				portraitRight.x = box.x + box.width - portraitRight.width - 250;
				portraitRight.y = -100;

				add(portraitRight);

				portraitRight.visible = false;
			}
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();

		add(box);

		box.screenCenter(X);

		portraitLeft.y = box.y;
		portraitRight.y = box.y;

		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
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
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'thorns':
			{
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			}
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
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

		if (FlxG.keys.justPressed.ENTER && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText', 'shared'), 0.75);

			if (dialogueList[0] != null && dialogueList[1] == null)
			{
				if (!isEnding)
				{
					isEnding = true;

					switch(PlayState.SONG.song.toLowerCase())
					{
						case 'senpai' | 'thorns':
							FlxG.sound.music.fadeOut(2.2, 0);
					}

					switch (fadeStyle)
					{
						case 'pixel':
						{
							new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								box.alpha -= 1 / 5;
								bgFade.alpha -= 1 / 5 * 0.7;
								portraitLeft.visible = false;
								portraitLeft.alpha = 0;
								portraitRight.visible = false;
								portraitRight.alpha = 0;
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
				portraitLeft.alpha = 1;
				portraitRight.alpha = 0;
				switch(curCharacter)
				{
					case 'bf-pixel':
						portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					case 'senpai' | 'senpai-angry' | 'spirit':
						portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				}
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.y = -100;
				portraitLeft.x = box.x + 250;
				add(portraitLeft);
			}
			case 'right':
			{
				portraitRight = updatePortraits(curCharacter, true);
				portraitRight.alpha = 1;
				portraitLeft.alpha = 0;
				switch(curCharacter)
				{
					case 'bf-pixel':
						portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
					case 'senpai' | 'senpai-angry' | 'spirit':
						portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				}
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.y = -100;
				portraitRight.x = box.x + box.width - portraitRight.width - 250;
				add(portraitRight);
			}
			case 'middle':
			{
				var splitPortrait:Array<String> = curCharacter.split('/');
				var portrait1:String = splitPortrait[0];
				var portrait2:String = splitPortrait[1];

				portraitLeft = updatePortraits(portrait1, false);
				portraitRight = updatePortraits(portrait2, true);

				portraitRight.alpha = 1;
				portraitLeft.alpha = 1;

				switch(portrait1)
				{
					case 'bf-pixel':
						portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
					case 'senpai' | 'senpai-angry' | 'spirit':
						portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				}
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.y = -100;
				portraitLeft.x = box.x + 250;

				switch(portrait2)
				{
					case 'bf-pixel':
						portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
					case 'senpai' | 'senpai-angry' | 'spirit':
						portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				}
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				portraitRight.y = -100;
				portraitRight.x = box.x + box.width - portraitRight.width - 250;

				add(portraitLeft);
				add(portraitRight);
			}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(':');

		curSide = splitName[0];
		curCharacter = splitName[1];

		dialogueList[0] = splitName[2].trim();
	}

	function updatePortraits(curCharacter:String = 'bf', flipped:Bool = false)
	{
		var portrait:Portrait;

		portrait = new Portrait(curCharacter, flipped);

		return portrait;
	}
}