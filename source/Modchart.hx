#if desktop
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets as OpenFlAssets;
import Type.ValueType;

using StringTools;

class Modchart
{
    public static var Function_Continue = 0;
    public static var Function_Stop = 1;

    #if windows
    public var lua:State = null;
    #end

    var playstate:PlayState = null;

	var modchartName:String = '';
	var aboutToClose:Bool = false;

    /*
    Sorry shadow mario but I had to.
    */

    public function new(luafile:String)
    {
        #if windows
        lua = LuaL.newstate();

        LuaL.openlibs(lua);
		Lua.init_callbacks(lua);

        var result:Dynamic = LuaL.dofile(lua, luafile);
		var resultString:String = Lua.tostring(lua, result);

        if (result != 0 && resultString != null)
        {
			lime.app.Application.current.window.alert(resultString, 'Error on .LUA file!');
			trace('Error on .LUA file! ' + resultString);

			lua = null;

			return;
		}

		modchartName = luafile;

        var newState:Dynamic = FlxG.state;
		playstate = newState;

        // LUA related
        set('Function_Continue', Function_Continue);
		set('Function_Stop', Function_Stop);
		set('luaDebugMode', false);
		set('luaDeprecatedWarnings', true);

        // Regular stuff
        set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);
        set('cameraX', 0);
		set('cameraY', 0);

        // More regular stuff
        set('curBeat', 0);
		set('curStep', 0);

        set('health', 1);

        set('score', 0);

        set('combo', 0);
		set('misses', 0);
        set('sicks', 0);
        set('goods', 0);
        set('bads', 0);
        set('shits', 0);

		set('noteHits', 0);

        set('fc', true);

		set('accuracy', 0);

        for (i in 0...4)
        {
			set('defPlrStrumX' + i, 0);
			set('defPlrStrumY' + i, 0);
			set('defOppStrumX' + i, 0);
			set('defOppStrumY' + i, 0);
		}

		set('player', PlayState.SONG.player1);
		set('computer', PlayState.SONG.player2);
		set('girlfriend', PlayState.SONG.player3);

        // Song related
        set('crochet', Conductor.crochet);
		set('stepCrochet', Conductor.stepCrochet);

        set('curBPM', Conductor.bpm);
        set('bpm', PlayState.SONG.bpm);
		set('scrollSpeed', PlayState.SONG.speed);

        set('songName', PlayState.SONG.song);
        set('songPosition', Conductor.songPosition);
        set('songLength', FlxG.sound.music.length);

		set('isStoryMode', PlayState.isStoryMode);
		set('difficultyNum', PlayState.storyDifficulty);
		set('weekNum', PlayState.storyWeek);

		set('startedCountdown', false);
        set('startingSong', false);
        set('endingSong', false);

        set('mustHitSection', false);

        // Options related
        set('downScroll', MythsListEngineData.downScroll);
        set('middleScroll', MythsListEngineData.middleScroll);
        set('ghostTapping', MythsListEngineData.ghostTapping);
        set('botPlay', MythsListEngineData.botPlay);

        /*
        FUNCTION STUFF
        */

        // System functions
        Lua_helper.add_callback(lua, 'getProperty', function(variable:String)
        {
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1)
            {
				var daProperty:Dynamic = Reflect.getProperty(playstate, splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
                {
					daProperty = Reflect.getProperty(daProperty, splittedVar[i]);
				}

				return Reflect.getProperty(daProperty, splittedVar[splittedVar.length - 1]);
			}

			return Reflect.getProperty(playstate, variable);
		});

		Lua_helper.add_callback(lua, 'setProperty', function(variable:String, value:Dynamic)
        {
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1)
            {
				var daProperty:Dynamic = Reflect.getProperty(playstate, splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
                {
					daProperty = Reflect.getProperty(daProperty, splittedVar[i]);
				}

				return Reflect.setProperty(daProperty, splittedVar[splittedVar.length - 1], value);
			}

			return Reflect.setProperty(playstate, variable, value);
		});

        Lua_helper.add_callback(lua, 'getPropertyFromGroup', function(obj:String, index:Int, variable:Dynamic)
        {
			if (Std.isOfType(Reflect.getProperty(playstate, obj), FlxTypedGroup))
				return Reflect.getProperty(Reflect.getProperty(playstate, obj).members[index], variable);

			var daArray:Dynamic = Reflect.getProperty(playstate, obj)[index];

			if (daArray != null)
            {
				if (Type.typeof(variable) == ValueType.TInt)
					return daArray[variable];

				var splitterVar:Array<String> = variable.split('.');

				if (splitterVar.length > 1)
				{
					var daProperty:Dynamic = Reflect.getProperty(daArray, splitterVar[0]);

					for (i in 1...splitterVar.length - 1)
					{
						daProperty = Reflect.getProperty(daProperty, splitterVar[i]);
					}

					return Reflect.getProperty(daProperty, splitterVar[splitterVar.length - 1]);
				}

				return Reflect.getProperty(daArray, variable);
			}

			luaTrace("Object #" + index + " from group: " + obj + " doesn't exist!");
			return null;
		});

		Lua_helper.add_callback(lua, 'setPropertyFromGroup', function(obj:String, index:Int, variable:Dynamic, value:Dynamic) 
        {
			if (Std.isOfType(Reflect.getProperty(playstate, obj), FlxTypedGroup))
				return Reflect.setProperty(Reflect.getProperty(playstate, obj).members[index], variable, value);

			var daArray:Dynamic = Reflect.getProperty(playstate, obj)[index];

			if (daArray != null)
            {
				if (Type.typeof(variable) == ValueType.TInt)
					return daArray[variable] = value;

				var splitterVar:Array<String> = variable.split('.');

				if (splitterVar.length > 1)
				{
					var daProperty:Dynamic = Reflect.getProperty(daArray, splitterVar[0]);

					for (i in 1...splitterVar.length - 1)
					{
						daProperty = Reflect.getProperty(daProperty, splitterVar[i]);
					}

					return Reflect.setProperty(daProperty, splitterVar[splitterVar.length - 1], value);
				}

				return Reflect.setProperty(daArray, variable, value);
			}
		});

		Lua_helper.add_callback(lua, 'removeFromGroup', function(obj:String, index:Int, dontdestroy:Bool = false)
        {
			if (Std.isOfType(Reflect.getProperty(playstate, obj), FlxTypedGroup)) 
            {
				var daProperty = Reflect.getProperty(playstate, obj).members[index];

				if (!dontdestroy)
					daProperty.kill();

				Reflect.getProperty(playstate, obj).remove(daProperty, true);

				if (!dontdestroy)
					daProperty.destroy();

				return;
			}

			Reflect.getProperty(playstate, obj).remove(Reflect.getProperty(playstate, obj)[index]);
		});

		Lua_helper.add_callback(lua, 'getPropertyFromClass', function(classVar:String, variable:String)
        {
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1) 
            {
				var daProperty:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
                {
					daProperty = Reflect.getProperty(daProperty, splittedVar[i]);
				}

				return Reflect.getProperty(daProperty, splittedVar[splittedVar.length - 1]);
			}

			return Reflect.getProperty(Type.resolveClass(classVar), variable);
		});

		Lua_helper.add_callback(lua, 'setPropertyFromClass', function(classVar:String, variable:String, value:Dynamic)
        {
			var splittedVar:Array<String> = variable.split('.');

			if (splittedVar.length > 1)
            {
				var daProperty:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), splittedVar[0]);

				for (i in 1...splittedVar.length - 1)
                {
					daProperty = Reflect.getProperty(daProperty, splittedVar[i]);
				}

				return Reflect.setProperty(daProperty, splittedVar[splittedVar.length - 1], value);
			}

			return Reflect.setProperty(Type.resolveClass(classVar), variable, value);
		});

		// Regular functions
		Lua_helper.add_callback(lua, 'addHealth', function(value:Float = 0)
		{
			playstate.health += value;
		});
	
		Lua_helper.add_callback(lua, 'setHealth', function(value:Float = 0)
		{
			playstate.health = value;
		});

		Lua_helper.add_callback(lua, 'addHealthFromPercent', function(value:Float = 0)
		{
			playstate.health += (value / 100);
		});

		Lua_helper.add_callback(lua, 'setHealthFromPercent', function(value:Float = 0)
		{
			playstate.health = (value / 100);
		});

		Lua_helper.add_callback(lua, 'addScore', function(value:Int = 0)
		{
			playstate.songScore += value;
		});

		Lua_helper.add_callback(lua, 'setScore', function(value:Int = 0)
		{
			playstate.songScore = value;
		});

		Lua_helper.add_callback(lua, 'addCombo', function(value:Int = 0)
		{
			playstate.combo += value;
		});
	
		Lua_helper.add_callback(lua, 'setCombo', function(value:Int = 0)
		{
			playstate.combo = value;
		});

		Lua_helper.add_callback(lua, 'addMisses', function(value:Int = 0)
		{
			playstate.misses += value;
		});

		Lua_helper.add_callback(lua, 'setMisses', function(value:Int = 0)
		{
			playstate.misses = value;
		});

		Lua_helper.add_callback(lua, 'addInputs', function(value:Int = 0, type:String = 'sick')
		{
			switch(type.toLowerCase())
			{
				case 'sick' | 'sicks':
					playstate.sicks += value;
				case 'good' | 'goods':
					playstate.goods += value;
				case 'bad' | 'bads':
					playstate.bads += value;
				case 'shit' | 'shits':
					playstate.shits += value;
				case 'notehit' | 'notehits' | 'hit' | 'hits':
					playstate.totalNotesHit += value;
			}
		});

		Lua_helper.add_callback(lua, 'setInputs', function(value:Int = 0, type:String = 'sick')
		{
			switch(type.toLowerCase())
			{
				case 'sick' | 'sicks':
					playstate.sicks = value;
				case 'good' | 'goods':
					playstate.goods = value;
				case 'bad' | 'bads':
					playstate.bads = value;
				case 'shit' | 'shits':
					playstate.shits = value;
				case 'notehit' | 'notehits' | 'hit' | 'hits':
					playstate.totalNotesHit = value;
			}
		});

		Lua_helper.add_callback(lua, 'updateAccuracy', function()
		{
			playstate.updateAccuracy();
		});

		Lua_helper.add_callback(lua, 'getColorFromHex', function(hex:String = '0xFF000000'):FlxColor
		{
			if(!hex.startsWith('0x'))
				hex = '0x' + hex;

			return FlxColor.fromString(hex);
		});

		Lua_helper.add_callback(lua, 'getColorFromRgb', function(r:Int = 0, g:Int = 0, b:Int = 0):FlxColor
		{
			return FlxColor.fromRGB(r, g, b);
		});

		Lua_helper.add_callback(lua, 'getCamFromString', function(cam:String = 'game'):FlxCamera
		{
			var curCamera:FlxCamera = playstate.camGame;

			switch(cam.toLowerCase())
			{
				case 'camhud' | 'hud':
					curCamera = playstate.camHUD;
				case 'camgame' | 'game':
					curCamera = playstate.camGame;
			}

			return curCamera;
		});

		Lua_helper.add_callback(lua, 'getStrumlinePos', function(axis:String = 'X'):Float
		{
			var curPos:Float = 0;

			switch(axis.toUpperCase())
			{
				case 'X':
					curPos = playstate.strumLine.x;
				case 'Y':
					curPos = playstate.strumLine.y;
			}

			return curPos;
		});

		Lua_helper.add_callback(lua, 'getAmountOfStrums', function(player:String = 'player'):Int
		{
			var curAmount:Int = 0;

			switch(player.toLowerCase())
			{
				case 'plr' | 'player' | 'player1':
					curAmount = playstate.playerStrums.length;
				case 'cpu' | 'computer' | 'player2':
					curAmount = playstate.cpuStrums.length;
				case 'both':
					curAmount = playstate.strumLineNotes.length;
			}

			return curAmount;
		});

		Lua_helper.add_callback(lua, 'keyJustPressed', function(controlName:String):Bool
		{
			var key:Bool = false;

			switch(controlName.toLowerCase())
			{
				case 'left': key = playstate.getControl('LEFT_P');
				case 'down': key = playstate.getControl('DOWN_P');
				case 'up': key = playstate.getControl('UP_P');
				case 'right': key = playstate.getControl('RIGHT_P');
			}

			return key;
		});

		Lua_helper.add_callback(lua, 'keyPressed', function(controlName:String):Bool
		{
			var key:Bool = false;

			switch(controlName.toLowerCase())
			{
				case 'left': key = playstate.getControl('LEFT');
				case 'down': key = playstate.getControl('DOWN');
				case 'up': key = playstate.getControl('UP');
				case 'right': key = playstate.getControl('RIGHT');
			}

			return key;
		});

		Lua_helper.add_callback(lua, 'keyReleased', function(controlName:String):Bool
		{
			var key:Bool = false;

			switch(controlName.toLowerCase())
			{
				case 'left': key = playstate.getControl('LEFT_R');
				case 'down': key = playstate.getControl('DOWN_R');
				case 'up': key = playstate.getControl('UP_R');
				case 'right': key = playstate.getControl('RIGHT_R');
			}

			return key;
		});

		Lua_helper.add_callback(lua, 'playSound', function(path:String = null, volume:Float = 1, ?library:String = 'shared')
		{
			if (path != null && OpenFlAssets.exists(Paths.sound(path, library)))
				FlxG.sound.play(Paths.sound(path, library), volume);
		});

		Lua_helper.add_callback(lua, 'playMusic', function(path:String = null, volume:Float = 1, looped:Bool = false, ?library:String = 'shared')
		{
			if (path != null && OpenFlAssets.exists(Paths.music(path, library)))
				FlxG.sound.playMusic(Paths.music(path, library), volume, looped);
		});

		Lua_helper.add_callback(lua, 'getSongPos', function(round:Bool = false):Float
		{
			if (!round)
				return Conductor.songPosition;
			else
				return Math.round(Conductor.songPosition);
		});

		Lua_helper.add_callback(lua, 'getCharacterPos', function(character:String = 'bf', axis:String = 'X'):Float
		{
			var curCharacter:Character = null;
			var curPos:Float = 0;

			switch(character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					curCharacter = playstate.dad;
				case 'gf' | 'girlfriend' | 'player3':
					curCharacter = playstate.gf;
				case 'bf' | 'boyfriend' | 'player1':
					curCharacter = playstate.boyfriend;
			}

			if (curCharacter != null)
			{
				switch(axis.toUpperCase())
				{
					case 'X':
						curPos = curCharacter.x;
					case 'Y':
						curPos = curCharacter.y;
				}
			}

			return curPos;
		});

		Lua_helper.add_callback(lua, 'setCharacterPos', function(character:String = 'bf', axis:String = 'X', value:Float = 0)
		{
			var curCharacter:Character = null;

			switch(character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					curCharacter = playstate.dad;
				case 'gf' | 'girlfriend' | 'player3':
					curCharacter = playstate.gf;
				case 'bf' | 'boyfriend' | 'player1':
					curCharacter = playstate.boyfriend;
			}

			if (curCharacter != null)
			{
				switch(axis.toUpperCase())
				{
					case 'X':
						curCharacter.x = value;
					case 'Y':
						curCharacter.y = value;
				}
			}
		});

		Lua_helper.add_callback(lua, 'addCharacterPos', function(character:String = 'bf', axis:String = 'X', value:Float = 0)
		{
			var curCharacter:Character = null;
	
			switch(character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					curCharacter = playstate.dad;
				case 'gf' | 'girlfriend' | 'player3':
					curCharacter = playstate.gf;
				case 'bf' | 'boyfriend' | 'player1':
					curCharacter = playstate.boyfriend;
			}
	
			if (curCharacter != null)
			{
				switch(axis.toUpperCase())
				{
					case 'X':
						curCharacter.x += value;
					case 'Y':
						curCharacter.y += value;
				}
			}
		});

		Lua_helper.add_callback(lua, 'characterPlayAnim', function(character:String = 'bf', animation:String = 'idle', ?forced:Bool = false)
		{
			switch(character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					if(playstate.dad.animOffsets.exists(animation))
						playstate.dad.playAnim(animation, forced);
				case 'gf' | 'girlfriend' | 'player3':
					if(playstate.gf.animOffsets.exists(animation))
						playstate.gf.playAnim(animation, forced);
				case 'bf' | 'boyfriend' | 'player1':
					if(playstate.boyfriend.animOffsets.exists(animation))
						playstate.boyfriend.playAnim(animation, forced);
			}
		});

		Lua_helper.add_callback(lua, 'characterDance', function(character:String = 'bf')
		{
			switch(character.toLowerCase())
			{
				case 'dad' | 'opponent' | 'player2':
					playstate.dad.dance();
				case 'gf' | 'girlfriend' | 'player3':
					playstate.gf.dance();
				case 'bf' | 'boyfriend' | 'player1':
					playstate.boyfriend.dance();
			}
		});

		Lua_helper.add_callback(lua, 'cameraShake', function(cam:String = 'game', intensity:Float = 0.1, duration:Float = 1)
		{
			getCamFromString(cam).shake(intensity, duration);
		});

		Lua_helper.add_callback(lua, 'cameraFlashFromHex', function(cam:String = 'game', color:String = '0xFF000000', duration:Float = 1)
		{
			if(!color.startsWith('0x'))
				color = '0x' + color;

			getCamFromString(cam).flash(FlxColor.fromString(color), duration);
		});

		Lua_helper.add_callback(lua, 'cameraFlashFromRgb', function(cam:String = 'game', r:Int = 0, g:Int = 0, b:Int = 0, duration:Float = 1)
		{
			getCamFromString(cam).flash(FlxColor.fromRGB(r, g, b), duration);
		});

		Lua_helper.add_callback(lua, 'songEnd', function()
		{
			playstate.skipAchievements = true;
			playstate.endSong();
		});

		Lua_helper.add_callback(lua, 'debugPrint', function(text:String = 'placeholder')
		{
			#if debug
			luaTrace(text, true, false);
			#end
		});

		Lua_helper.add_callback(lua, 'releasePrint', function(text:String = 'placeholder')
		{
			#if !debug
			luaTrace(text, true, false);
			#end
		});

		Lua_helper.add_callback(lua, 'print', function(text:String = 'placeholder')
		{
			luaTrace(text, true, false);
		});

		Lua_helper.add_callback(lua, 'close', function(printMsg:Bool = true)
		{
			if (!aboutToClose)
			{
				if (printMsg)
					luaTrace('Stopping .LUA script in 100ms: ' + modchartName);

				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					stop();
				});
			}

			aboutToClose = true;
		});

		call('onCreate', []);
        #end
    }

	public function getCamFromString(cam:String = 'game'):FlxCamera
	{
		var curCamera:FlxCamera = playstate.camGame;

		switch(cam.toLowerCase())
		{
			case 'camhud' | 'hud':
				curCamera = playstate.camHUD;
			case 'camgame' | 'game':
				curCamera = playstate.camGame;
		}

		return curCamera;
	}

	public function luaTrace(text:String = 'placeholder', ignoreCheck:Bool = false, deprecated:Bool = false)
	{
		#if windows
		if (ignoreCheck || getBool('luaDebugMode'))
		{
			if (deprecated && !getBool('luaDeprecatedWarnings'))
				return;

			var tracedText:String = (deprecated ? 'Deprecated message: ' : '') + text;
			trace(tracedText);
		}
		#end
	}

	public function call(event:String, args:Array<Dynamic>):Dynamic
	{
		#if windows
		if (lua == null)
			return Function_Continue;

		Lua.getglobal(lua, event);

		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}

		var result:Null<Int> = Lua.pcall(lua, args.length, 1, 0);

		if (result != null && resultIsAllowed(lua, result))
		{
			if (Lua.type(lua, -1) == Lua.LUA_TSTRING)
			{
				var error:String = Lua.tostring(lua, -1);

				Lua.pop(lua, 1);

				if (error == 'attempt to call a nil value')
					return Function_Continue;
			}

			var conv:Dynamic = Convert.fromLua(lua, result);

			return conv;
		}
		#end

		return Function_Continue;
	}

	#if windows
	function resultIsAllowed(daLua:State, daResult:Null<Int>)
	{
		switch(Lua.type(daLua, daResult))
		{
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}

		return false;
	}
	#end

	#if windows
	public function getBool(variable:String)
	{
		var result:String = null;

		Lua.getglobal(lua, variable);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if (result == null)
			return false;

		return (result == 'true');
	}
	#end

	public function set(variable:String, data:Dynamic)
	{
		#if windows
		if (lua == null)
			return;

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
		#end
	}

	public function stop()
	{
		#if windows
		if(lua == null)
			return;

		playstate.removeModchart(this);
		Lua.close(lua);
		lua = null;
		#end
	}
}
