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

	public static var swagWidth:Float = 112;

	public static var PURP_NOTE:Int = 0;
	public static var BLUE_NOTE:Int = 1;
	public static var GREEN_NOTE:Int = 2;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteType:Int = 0)
	{
		super();

		var daStage:String = PlayState.curStage;

		var arrowColorArray:Array<String> = ['purple', 'blue', 'green', 'red'];

		var arrowPath:String = 'NOTE_assets';
		var arrowLibrary:String = 'shared';

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		y -= 2000;

		if (MythsListEngineData.middleScroll)
			x += ((FlxG.width / 2) * -0.42) + 50;
		else
			x += 96;

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.noteType = noteType;

		switch(daStage)
		{
			case 'school' | 'schoolEvil':
			{
				switch(noteType)
				{
					case 0:
						arrowPath = (MythsListEngineData.arrowColors ? 'weeb/pixelUI/customarrows-pixels' : 'weeb/pixelUI/arrows-pixels');
						arrowLibrary = 'week6';
				}

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				animation.addByPrefix(arrowColorArray[0] + 'Scroll', 'arrows-pixels arrowleft');
				animation.addByPrefix(arrowColorArray[1] + 'Scroll', 'arrows-pixels arrowdown');
				animation.addByPrefix(arrowColorArray[2] + 'Scroll', 'arrows-pixels arrowup');
				animation.addByPrefix(arrowColorArray[3] + 'Scroll', 'arrows-pixels arrowright');

				animation.addByPrefix(arrowColorArray[0] + 'holdend', 'arrows-pixels holdendleft');
				animation.addByPrefix(arrowColorArray[1] + 'holdend', 'arrows-pixels holdenddown');
				animation.addByPrefix(arrowColorArray[2] + 'holdend', 'arrows-pixels holdendup');
				animation.addByPrefix(arrowColorArray[3] + 'holdend', 'arrows-pixels holdendright');

				animation.addByPrefix(arrowColorArray[0] + 'hold', 'arrows-pixels holdleft');
				animation.addByPrefix(arrowColorArray[1] + 'hold', 'arrows-pixels holddown');
				animation.addByPrefix(arrowColorArray[2] + 'hold', 'arrows-pixels holdup');
				animation.addByPrefix(arrowColorArray[3] + 'hold', 'arrows-pixels holdright');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			}
			default:
			{
				switch(noteType)
				{
					case 0:
						arrowPath = (MythsListEngineData.arrowColors ? 'customNOTE_assets' : 'NOTE_assets');
						arrowLibrary = 'shared';
				}

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				animation.addByPrefix(arrowColorArray[0] + 'Scroll', 'purple0');
				animation.addByPrefix(arrowColorArray[1] + 'Scroll', 'blue0');
				animation.addByPrefix(arrowColorArray[2] + 'Scroll', 'green0');
				animation.addByPrefix(arrowColorArray[3] + 'Scroll', 'red0');

				animation.addByPrefix(arrowColorArray[0] + 'holdend', 'purple hold end');
				animation.addByPrefix(arrowColorArray[1] + 'holdend', 'blue hold end');
				animation.addByPrefix(arrowColorArray[2] + 'holdend', 'green hold end');
				animation.addByPrefix(arrowColorArray[3] + 'holdend', 'red hold end');

				animation.addByPrefix(arrowColorArray[0] + 'hold', 'purple hold piece');
				animation.addByPrefix(arrowColorArray[1] + 'hold', 'blue hold piece');
				animation.addByPrefix(arrowColorArray[2] + 'hold', 'green hold piece');
				animation.addByPrefix(arrowColorArray[3] + 'hold', 'red hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				
				antialiasing = MythsListEngineData.antiAliasing;
			}
		}

		x += swagWidth * noteData;

		animation.play(arrowColorArray[noteData] + 'Scroll');

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play(arrowColorArray[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (MythsListEngineData.downScroll)
				flipY = true;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(arrowColorArray[prevNote.noteData] + 'hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;

				prevNote.updateHitbox();
			}
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
					{
						if (!botplayMiss)
							canBeHit = true;
						else
							canBeHit = false;
					}
				}
				else
					canBeHit = false;
			}
			else
			{
				if (!MythsListEngineData.botPlay && strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else if (MythsListEngineData.botPlay && strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition)
				{
					if (!botplayMiss)
						canBeHit = true;
					else
						canBeHit = false;
				}
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
