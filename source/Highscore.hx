package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores[daSong] < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores[daWeek] < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	static function setScore(song:String, score:Int):Void
	{
		if (!MythsListEngineData.botPlay)
		{
			songScores[song] = score;
			FlxG.save.data.songScores = songScores;
			FlxG.save.flush();
		}
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String;
		var difficulty:Array<String> = ['-easy', '', '-hard'];
		
		daSong = song + difficulty[diff];

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong = formatSong(song, diff);

		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores[daSong];
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		var daWeek = formatSong('week' + week, diff);

		if (!songScores.exists(daWeek))
			setScore(daWeek, 0);

		return songScores[daWeek];
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;
	}

	public static function delete():Void
	{
		FlxG.save.data.songScores = null;
		songScores = new Map<String, Int>();

		FlxG.save.flush();
	}
}
