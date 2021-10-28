package;

import flixel.FlxG;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores[daSong] < score)
				setSongScore(daSong, score);
		}
		else
			setSongScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 0, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores[daWeek] < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	static function setSongScore(song:String, score:Int):Void
	{
		if (!MythsListEngineData.botPlay)
		{
			songScores[song] = score;
			FlxG.save.data.songScores = songScores;
			FlxG.save.flush();
		}
	}

	static function setWeekScore(week:String, score:Int):Void
	{
		if (!MythsListEngineData.botPlay)
		{
			weekScores[week] = score;
			FlxG.save.data.weekScores = weekScores;
			FlxG.save.flush();
		}
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var difficulty:Array<String> = ['-easy', '', '-hard'];
		var daSong:String = song + difficulty[diff];

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong = formatSong(song, diff);

		if (!songScores.exists(daSong))
			setSongScore(daSong, 0);

		return songScores[daSong];
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		var daWeek = formatSong('week' + week, diff);

		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores[daWeek];
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;

		if (FlxG.save.data.weekScores != null)
			weekScores = FlxG.save.data.weekScores;
	}

	public static function delete():Void
	{
		FlxG.save.data.songScores = null;
		FlxG.save.data.weekScores = null;

		FlxG.save.flush();

		load();
	}
}
