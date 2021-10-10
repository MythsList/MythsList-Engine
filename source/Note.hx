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

	public var noteData:Int = 0;
	public var noteType:Int = 0;

	public var prevNote:Note;

	public static var swagWidth:Float = 112;

	public static var PURP_NOTE:Int = 0;
	public static var BLUE_NOTE:Int = 1;
	public static var GREEN_NOTE:Int = 2;
	public static var RED_NOTE:Int = 3;

	public var rating:String = 'sick';

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteType:Int = 0)
	{
		super();

		var colorArray:Array<String> = ['purple', 'blue', 'green', 'red'];

		var daStage:String = PlayState.curStage;

		var arrowPath:String = 'NOTE_assets';
		var arrowLibrary:String = 'shared';

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		y -= 2000;

		if (MythsListEngineData.middleScroll)
			x += (((FlxG.width / 2) * -0.42) + 50);
		else
			x += 96;

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.noteType = noteType;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
			{
				switch(noteType)
				{
					case 0:
						arrowPath = 'weeb/pixelUI/arrows-pixels';
						arrowLibrary = 'week6';
				}

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				animation.addByPrefix(colorArray[0] + 'Scroll', 'arrows-pixels arrowleft');
				animation.addByPrefix(colorArray[1] + 'Scroll', 'arrows-pixels arrowdown');
				animation.addByPrefix(colorArray[2] + 'Scroll', 'arrows-pixels arrowup');
				animation.addByPrefix(colorArray[3] + 'Scroll', 'arrows-pixels arrowright');

				animation.addByPrefix(colorArray[0] + 'holdend', 'arrows-pixels holdendleft');
				animation.addByPrefix(colorArray[1] + 'holdend', 'arrows-pixels holdenddown');
				animation.addByPrefix(colorArray[2] + 'holdend', 'arrows-pixels holdendup');
				animation.addByPrefix(colorArray[3] + 'holdend', 'arrows-pixels holdendright');

				animation.addByPrefix(colorArray[0] + 'hold', 'arrows-pixels holdleft');
				animation.addByPrefix(colorArray[1] + 'hold', 'arrows-pixels holddown');
				animation.addByPrefix(colorArray[2] + 'hold', 'arrows-pixels holdup');
				animation.addByPrefix(colorArray[3] + 'hold', 'arrows-pixels holdright');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			}
			default:
			{
				switch(noteType)
				{
					case 0:
						arrowPath = 'NOTE_assets';
						arrowLibrary = 'shared';
				}

				frames = Paths.getSparrowAtlas(arrowPath, arrowLibrary);

				animation.addByPrefix(colorArray[0] + 'Scroll', 'purple0');
				animation.addByPrefix(colorArray[1] + 'Scroll', 'blue0');
				animation.addByPrefix(colorArray[2] + 'Scroll', 'green0');
				animation.addByPrefix(colorArray[3] + 'Scroll', 'red0');

				animation.addByPrefix(colorArray[0] + 'holdend', 'purple hold end');
				animation.addByPrefix(colorArray[1] + 'holdend', 'blue hold end');
				animation.addByPrefix(colorArray[2] + 'holdend', 'green hold end');
				animation.addByPrefix(colorArray[3] + 'holdend', 'red hold end');

				animation.addByPrefix(colorArray[0] + 'hold', 'purple hold piece');
				animation.addByPrefix(colorArray[1] + 'hold', 'blue hold piece');
				animation.addByPrefix(colorArray[2] + 'hold', 'green hold piece');
				animation.addByPrefix(colorArray[3] + 'hold', 'red hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				
				antialiasing = MythsListEngineData.antiAliasing;
			}
		}

		x += swagWidth * noteData;

		animation.play(colorArray[noteData] + 'Scroll');

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play(colorArray[noteData] + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (MythsListEngineData.downScroll)
				flipY = true;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(colorArray[prevNote.noteData] + 'hold');

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
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate && !wasGoodHit)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
