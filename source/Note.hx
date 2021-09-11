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

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var noteType:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = 'sick';

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteType:Int = 0)
	{
		super();

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

				animation.addByPrefix('purpleScroll', 'arrows-pixels arrowleft');
				animation.addByPrefix('blueScroll', 'arrows-pixels arrowdown');
				animation.addByPrefix('greenScroll', 'arrows-pixels arrowup');
				animation.addByPrefix('redScroll', 'arrows-pixels arrowright');

				animation.addByPrefix('purplehold', 'arrows-pixels holdleft');
				animation.addByPrefix('bluehold', 'arrows-pixels holddown');
				animation.addByPrefix('greenhold', 'arrows-pixels holdup');
				animation.addByPrefix('redhold', 'arrows-pixels holdright');

				animation.addByPrefix('purpleholdend', 'arrows-pixels holdendleft');
				animation.addByPrefix('blueholdend', 'arrows-pixels holdenddown');
				animation.addByPrefix('greenholdend', 'arrows-pixels holdendup');
				animation.addByPrefix('redholdend', 'arrows-pixels holdendright');

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

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();

				if (MythsListEngineData.antiAliasing)
					antialiasing = true;
			}
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 0:
					animation.play('purpleholdend');
				case 1:
					animation.play('blueholdend');
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (MythsListEngineData.downScroll)
				flipY = true;

			if (prevNote.isSustainNote)
			{
				switch(prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

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
