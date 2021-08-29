package;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import io.newgrounds.components.ScoreBoardComponent.Period;
import io.newgrounds.objects.Medal;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.ScoreBoard;
import io.newgrounds.objects.events.Response;
import io.newgrounds.objects.events.Result.GetCurrentVersionResult;
import io.newgrounds.objects.events.Result.GetVersionResult;
import lime.app.Application;
import openfl.display.Stage;

using StringTools;

class NGio
{
	public static var isLoggedIn:Bool = false;
	public static var scoreboardsLoaded:Bool = false;

	public static var scoreboardArray:Array<Score> = [];

	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();
	public static var ngScoresLoaded(default, null):FlxSignal = new FlxSignal();

	public static var GAME_VER:String = "";
	public static var GAME_VER_NUMS:String = '';
	public static var gotOnlineVer:Bool = false;

	public static function noLogin(api:String)
	{
		trace('INIT NOLOGIN');
		GAME_VER = "v" + Application.current.meta.get('version');

		NG.create(api);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			var call = NG.core.calls.app.getCurrentVersion(GAME_VER).addDataHandler(function(response:Response<GetCurrentVersionResult>)
			{
				if (response.result != null)
				{
					GAME_VER = response.result.data.currentVersion;
					GAME_VER_NUMS = GAME_VER.split(" ")[0].trim();
					trace('CURRENT NG VERSION: ' + GAME_VER);
					trace('CURRENT NG VERSION: ' + GAME_VER_NUMS);
					gotOnlineVer = true;
				}
		});
			call.send();
		});
	}

	public function new(api:String, encKey:String, ?sessionId:String)
	{
		trace("connecting to newgrounds");

		NG.createAndCheckSession(api, sessionId);

		NG.core.verbose = true;
		NG.core.initEncryption(encKey);

		trace(NG.core.attemptingLogin);

		if (NG.core.attemptingLogin)
		{
			trace("attempting login");
			NG.core.onLogin.add(onNGLogin);
		}
		else
		{
			NG.core.requestLogin(onNGLogin);
		}
	}

	function onNGLogin():Void
	{
		trace('logged in! user:${NG.core.user.name}');
		isLoggedIn = true;
		FlxG.save.data.sessionId = NG.core.sessionId;
		// FlxG.save.flush();
		// Load medals then call onNGMedalFetch()
		NG.core.requestMedals(onNGMedalFetch);

		// Load Scoreboards hten call onNGBoardsFetch()
		NG.core.requestScoreBoards(onNGBoardsFetch);

		ngDataLoaded.dispatch();
	}

	// --- MEDALS
	function onNGMedalFetch():Void
	{

	}

	// --- SCOREBOARDS
	function onNGBoardsFetch():Void
	{
		trace("shoulda got score by NOW!");
	}

	inline static public function postScore(score:Int = 0, song:String)
	{
		if (isLoggedIn)
		{
			for (id in NG.core.scoreBoards.keys())
			{
				var board = NG.core.scoreBoards.get(id);

				if (song == board.name)
				{
					board.postScore(score, "Uhh meow?");
				}
			}
		}
	}

	function onNGScoresFetch():Void
	{
		scoreboardsLoaded = true;

		ngScoresLoaded.dispatch();
	}

	inline static public function logEvent(event:String)
	{
		NG.core.calls.event.logEvent(event).send();
		trace('should have logged: ' + event);
	}

	inline static public function unlockMedal(id:Int)
	{
		if (isLoggedIn)
		{
			var medal = NG.core.medals.get(id);
			if (!medal.unlocked)
				medal.sendUnlock();
		}
	}
}