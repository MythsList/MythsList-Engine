package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var sustainLength:Float = 0;
	public var noteScore:Float = 1;

	public var mustPress:Bool = false;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var isSustainNote:Bool = false;

	// bot play stuff so special notes that you have to miss don't get hit by the bot
	public var botplayMiss:Bool = false;

	// player 2 stuff so special notes that you want the opponent to miss don't get hit
	public var playertwoMiss:Bool = false;

	public var noteData:Int = 0;
	public var noteType:Int = 0;

	public var prevNote:Note;

	// ultimate sustain note fix (number should always be positive so the code can make it negative for upscroll)
	public static var sustainOffset:Float = 125;

	public static var swagWidth:Float = 112;

	public static var PURP_NOTE:Int = 0;
	public static var BLUE_NOTE:Int = 1;
	public static var GREEN_NOTE:Int = 2;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteType:Int = 0)
	{
		super();

		var arrowColorArray:Array<String> = ['purple', 'blue', 'green', 'red'];

		var arrowPath:String = 'NOTE_assets';
		var arrowLibrary:String = 'shared';

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		y -= 2000;
		x += (MythsListEngineData.middleScroll ? -218.8 : 96);

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.noteType = noteType;

		switch(PlayState.curStage)
		{
			case 'school' | 'schoolEvil':
			{
				switch(noteType)
				{
					case 0:
						arrowPath = (MythsListEngineData.arrowColors ? 'weeb/pixelUI/customarrows-pixels' : 'weeb/pixelUI/arrows-pixels');
						arrowLibrary = 'week6';
						sustainOffset = 135;
				}

				// lazy to redo the xml for this one so new variable
				var suffixArray:Array<String> = ['left', 'down', 'up', 'right'];

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				for (i in 0...4)
				{
					animation.addByPrefix(arrowColorArray[i] + 'Scroll', 'arrows-pixels arrow' + suffixArray[i]);
					animation.addByPrefix(arrowColorArray[i] + 'holdend', 'arrows-pixels holdend' + suffixArray[i]);
					animation.addByPrefix(arrowColorArray[i] + 'hold', 'arrows-pixels hold' + suffixArray[i]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

				antialiasing = false;
			}
			default:
			{
				switch(noteType)
				{
					case 0:
						arrowPath = (MythsListEngineData.arrowColors ? 'customNOTE_assets' : 'NOTE_assets');
						arrowLibrary = 'shared';
						sustainOffset = 125;
				}

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				for (i in 0...4)
				{
					animation.addByPrefix(arrowColorArray[i] + 'Scroll', arrowColorArray[i] + '0');
					animation.addByPrefix(arrowColorArray[i] + 'holdend', arrowColorArray[i] + ' hold end');
					animation.addByPrefix(arrowColorArray[i] + 'hold', arrowColorArray[i] + ' hold trail');
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				
				antialiasing = MythsListEngineData.antiAliasing;
			}
		}

		x += swagWidth * (noteData % 4);

		animation.play(arrowColorArray[noteData % 4] + 'Scroll');

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;

			x += width / 2;

			animation.play(arrowColorArray[noteData % 4] + 'holdend');
			updateHitbox();

			x -= width / 2;

			flipY = (MythsListEngineData.downScroll ? true : false);

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(arrowColorArray[prevNote.noteData % 4] + 'hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}

			alpha = 0.6;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				{
					if (!MythsListEngineData.botPlay)
						canBeHit = true;
					else
						canBeHit = (!botplayMiss ? true : false);
				}
				else
					canBeHit = false;
			}
			else
			{
				if (!MythsListEngineData.botPlay && strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else if (MythsListEngineData.botPlay && strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition)
					canBeHit = (!botplayMiss ? true : false);
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (!playertwoMiss)
			{
				if (!isSustainNote)
				{
					if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition)
						wasGoodHit = true;
				}
				else
				{
					if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						wasGoodHit = true;
				}
			}
		}

		if (tooLate && !wasGoodHit)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
