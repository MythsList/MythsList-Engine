package;

#if desktop
import Discord.DiscordClient;
#end
import MythsListEngineData;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	private var curSong:String = '';
	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;
	
	private var gfVersion:String = 'gf';
	private var gfSpeed:Int = 1;

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var curPress:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var cpuStrums:FlxTypedGroup<FlxSprite>;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var combo:Int = 0;
	private var misses:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;

	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;

	private var fc:Bool = true;
	private var rating:String = 'S+';

	private var health:Float = 1;
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var songBarBG:FlxSprite;
	private var songBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var endingSong:Bool = false;

	private var charSelectionExists:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	private var camZooming:Bool = false;
	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;
	private var camDialogue:FlxCamera;

	public var dialogue:Array<String> = [];

	// week 3 variable(s)
	public static var trainSound:FlxSound;

	// week 4 variable(s)
	public static var limo:FlxSprite = new FlxSprite();
	public static var fastCar:FlxSprite = new FlxSprite();
	public static var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	// week 6 variable(s)
	public static var bgGirls:BackgroundGirls;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var inCutscene:Bool = false;
	var dialogueBox:DialogueBox;

	var songLength:Float = 0;
	var songPosition:Float = 0;

	var songScore:Int = 0;
	public static var campaignScore:Int = 0;

	var scoreTxt:FlxText;
	var inputsTxt:FlxText;
	var songTxt:FlxText;
	var diffTxt:FlxText;
	var weekTxt:FlxText;
	var botTxt:FlxText;
	var engineversion:FlxText;
	var version:FlxText;

	var colorArray:Array<Dynamic>;

	public static var defaultCamZoom:Float = 1.05;
	public static var daPixelZoom:Float = 6;

	#if desktop
		var storyDifficultyText:String = '';
		var iconRPC:String = '';
		var detailsText:String = '';
		var detailsPausedText:String = '';
	#end

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.mouse.visible = false;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/*
		ADDING DIALOGUES TO A SONG SHOULD BE THE SAME THING,
		ITS JUST THAT YOU DONT HAVE TO CODE HERE NOW!
		*/

		createDialogue(false);

		#if desktop
		storyDifficultyText = ' (' + CoolUtil.difficultyArray[storyDifficulty][0].toUpperCase() + ') ';

		if (isStoryMode)
			detailsText = 'Story : Week - ' + storyWeek;
		else
			detailsText = 'Freeplay :';

		detailsPausedText = '[PAUSED] ' + detailsText;
		
		if (fc)
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC);
		else
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC);
		#end

		colorArray = [
			MythsListEngineData.arrowLeft,
			MythsListEngineData.arrowDown,
			MythsListEngineData.arrowUp,
			MythsListEngineData.arrowRight
		];

		gfVersion = 'gf';
		defaultCamZoom = 1.05;
		curStage = 'stage';

		switch(SONG.song.toLowerCase())
		{
			case 'bopeebo' | 'fresh' | 'dadbattle':
			{
				defaultCamZoom = 0.9;

		        curStage = 'stage';

				if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);
				}
			}
			case 'spookeez' | 'south' | 'monster': 
            {
				defaultCamZoom = 1.05;

				curStage = 'spooky';

				if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);
				}
		    }
		    case 'pico' | 'philly' | 'blammed': 
            {
				defaultCamZoom = 1.05;

				curStage = 'philly';

				if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);

		        	FlxG.sound.list.add(trainSound);
				}
		    }
		    case 'high' | 'satin-panties' | 'milf':
		    {
				defaultCamZoom = 0.9;

				curStage = 'limo';
				gfVersion = 'gf-car';

				if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);

					add(grpLimoDancers);
				}
		    }
		    case 'cocoa' | 'eggnog' | 'winter-horrorland':
		    {
				defaultCamZoom = 0.8;

				curStage = 'mall';
				gfVersion = 'gf-christmas';

				if (SONG.song.toLowerCase() == 'winter-horrorland')
				{
					defaultCamZoom = 1.05;
					curStage += 'Evil';
				}

		        if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);
				}
		    }
		    case 'senpai' | 'roses' | 'thorns':
		    {
				defaultCamZoom = 1.05;

		        curStage = 'school';
				gfVersion = 'gf-pixel';

				if (SONG.song.toLowerCase() == 'thorns')
					curStage += 'Evil';

				if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);

					if (SONG.song.toLowerCase() != 'thorns')
		        		add(bgGirls);
				}
		    }
		    default:
		    {
				defaultCamZoom = 0.9;

		        curStage = 'stage';

		        if (MythsListEngineData.backgroundDisplay)
				{
					var newstage:Stage = new Stage(curStage);
					add(Stage.background);
				}
		    }
        }

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		
		if (dad.hasTrail)
		{
			var evilTrail:FlxTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
			add(evilTrail);
		}

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;

				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'spooky':
				dad.y += 200;
			case 'monster':
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai' | 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		for (i in OptionsSubState.textMenuItems)
		{
			if (i.toLowerCase() == 'character selection')
				charSelectionExists = true;
		}

		if (charSelectionExists)
		{
			switch(SONG.song.toLowerCase())
			{
				// For songs that use a specific BF

				case 'senpai' | 'roses' | 'thorns':
					boyfriend = new Boyfriend(770, 450, SONG.player1);

				// If your song isn't mentioned then it will use the currently selected character

				default:
					if (MythsListEngineData.characterSkin == 'bf' || !CharacterSelectionSubState.icons.contains(MythsListEngineData.characterSkin))
						boyfriend = new Boyfriend(770, 450, SONG.player1);
					else
						boyfriend = new Boyfriend(770, 450, MythsListEngineData.characterSkin);
			}
		}
		else
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		
		if (boyfriend.hasTrail)
		{
			var evilTrail:FlxTrail = new FlxTrail(boyfriend, null, 4, 24, 0.3, 0.069);
			add(evilTrail);
		}

		switch(curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				if (MythsListEngineData.backgroundDisplay)
				{
					resetFastCar();
					add(fastCar);
				}
			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school' | 'schoolEvil':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		if (charSelectionExists)
		{
			switch(boyfriend.curCharacter)
			{
				case 'bf-veryold':
					boyfriend.y += 30;
				case 'brody-foxx':
					boyfriend.y -= 220;
				case 'template':
					boyfriend.y -= 60;
					boyfriend.x -= 10;
				case 'rhys':
					boyfriend.x += 40;
					boyfriend.y -= 380;
			}
		}

		var layerOrder:Array<Dynamic> = [gf, dad, boyfriend];

		if (MythsListEngineData.backgroundDisplay)
		{
			switch(curStage)
			{
				case 'limo':
					layerOrder = [gf, limo, dad, boyfriend];
				default:
					layerOrder = [gf, dad, boyfriend];
			}
		}

		for (item in layerOrder)
		{
			add(item);
		}

		Conductor.songPosition = -5000;

		if (!MythsListEngineData.downScroll)
			strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		else
			strumLine = new FlxSprite(0, 550).makeGraphic(FlxG.width, 10);

		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		if (MythsListEngineData.downScroll)
			strumLine.y = FlxG.height - 150;

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar', 'shared'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		if (MythsListEngineData.downScroll)
		    healthBarBG.y = 50;

		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();

		var player2hpColor:FlxColor = FlxColor.RED;
		var player1hpColor:FlxColor = FlxColor.LIME;

		if (dad.healthBarColor != '0xFF')
			player2hpColor = FlxColor.fromString(dad.healthBarColor);

		if (boyfriend.healthBarColor != '0xFF')
			player1hpColor = FlxColor.fromString(boyfriend.healthBarColor);

		healthBar.createFilledBar(player2hpColor, player1hpColor);

		add(healthBar);

		if (MythsListEngineData.songpositionDisplay)
		{
			songBarBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar', 'shared'));
			songBarBG.screenCenter(X);
			songBarBG.scrollFactor.set();

			if (MythsListEngineData.downScroll)
		    	songBarBG.y = FlxG.height - songBarBG.height - 10;

			add(songBarBG);

			songBar = new FlxBar(songBarBG.x + 4, songBarBG.y + 4, LEFT_TO_RIGHT, Std.int(songBarBG.width - 8), Std.int(songBarBG.height - 8), this, 'songPosition', 0, 1);
			songBar.scrollFactor.set();
			songBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString(dad.healthBarColor));
			add(songBar);
		}

		if (MythsListEngineData.inputsCounter)
		{
			inputsTxt = new FlxText(5, 0, 0,
			'Inputs counter:'
			+ '\nSicks: ' + sicks
			+ '\nGoods: ' + goods
			+ '\nBads: ' + bads
			+ '\nShits: ' + shits
			+ '\n',
			20);

			inputsTxt.screenCenter(Y);
			inputsTxt.y -= 20;
			inputsTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			inputsTxt.scrollFactor.set();
			inputsTxt.updateHitbox();
			add(inputsTxt);
		}

		scoreTxt = new FlxText(0, healthBarBG.y + 50, 0, '', 20);
		scoreTxt.screenCenter(X);

		if (fc)
			scoreTxt.text = "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)";
		else
			scoreTxt.text = "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating;

		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.updateHitbox();
		add(scoreTxt);
		scoreTxt.x = (FlxG.width / 2) - (scoreTxt.width / 2);

		if (!MythsListEngineData.statsDisplay)
			scoreTxt.alpha = 0;

		engineversion = new FlxText(5, FlxG.height - 18, 0, "", 20);
		engineversion.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		engineversion.scrollFactor.set();
		engineversion.updateHitbox();
		add(engineversion);

		songTxt = new FlxText(5, (FlxG.height - 18) - engineversion.height, 0, '', 20);
		songTxt.text = PlayState.SONG.song.toUpperCase() + ' ';
		songTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		songTxt.scrollFactor.set();
		songTxt.updateHitbox();
		add(songTxt);

		diffTxt = new FlxText(0 + songTxt.width, songTxt.y, 0, '', 20);
		diffTxt.text = '(' + CoolUtil.difficultyArray[PlayState.storyDifficulty][0].toUpperCase() + ')';
		diffTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		diffTxt.scrollFactor.set();
		diffTxt.updateHitbox();
		add(diffTxt);

		weekTxt = new FlxText(5, songTxt.y - songTxt.height, 0, '', 20);
		weekTxt.text = 'Week ' + storyWeek;
		weekTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		weekTxt.scrollFactor.set();
		weekTxt.updateHitbox();
		add(weekTxt);

		botTxt = new FlxText(0, 0, 0, "", 28);
		botTxt.text = 'BOT PLAY';
		botTxt.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botTxt.scrollFactor.set();
		botTxt.updateHitbox();
		add(botTxt);

		botTxt.screenCenter(X);

		if (!MythsListEngineData.songinfosDisplay)
		{
			songTxt.alpha = 0;
			diffTxt.alpha = 0;
			weekTxt.alpha = 0;
		}

		version = new FlxText(5, weekTxt.y - weekTxt.height, 0, "", 20);
		version.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		version.scrollFactor.set();
		version.updateHitbox();
		add(version);

		if (MythsListEngineData.downScroll)
		{
		    engineversion.y = 3;
			songTxt.y = engineversion.y + engineversion.height;
			diffTxt.y = songTxt.y;
			weekTxt.y = songTxt.y + songTxt.height;
			version.y = weekTxt.y + weekTxt.height;
			botTxt.y = scoreTxt.y + scoreTxt.height + 100;
		}

		if (MythsListEngineData.middleScroll)
		{
			if (!MythsListEngineData.downScroll)
				botTxt.y = healthBarBG.y - 100;
			else
				botTxt.y = scoreTxt.y + scoreTxt.height + 60;
		}
		else
			botTxt.y = strumLine.y + Note.swagWidth - (Note.swagWidth / 2) - (botTxt.height / 2); // math

		if (!MythsListEngineData.songinfosDisplay)
		{
			if (!MythsListEngineData.downScroll)
				version.y = engineversion.y - engineversion.height;
			else
				version.y = engineversion.y + engineversion.height;
		}

		if (!MythsListEngineData.versionDisplay)
		{
			version.alpha = 0;
			engineversion.alpha = 0;

			if (!MythsListEngineData.downScroll)
			{
				songTxt.y += 16;
				diffTxt.y = songTxt.y;
				weekTxt.y += 16;
			}
			else
			{
				songTxt.y -= 16;
				diffTxt.y = songTxt.y;
				weekTxt.y -= 16;
			}
		}

		if (!MythsListEngineData.botPlay)
			botTxt.alpha = 0;

		iconP1 = new HealthIcon(boyfriend.curCharacter, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(dad.curCharacter, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		diffTxt.cameras = [camHUD];
		weekTxt.cameras = [camHUD];
		botTxt.cameras = [camHUD];
		engineversion.cameras = [camHUD];
		version.cameras = [camHUD];
			
		if (MythsListEngineData.inputsCounter)
			inputsTxt.cameras = [camHUD];

		if (MythsListEngineData.songpositionDisplay)
		{
			songBarBG.cameras = [camHUD];
			songBar.cameras = [camHUD];
		}

		startingSong = true;

		/*
		WARNING :
		Never put a startCutscene function here, check in CoolUtil.hx instead. It is an automatized system,
		but you can still put your startDialogue function here of course!
		*/

		if (isStoryMode)
		{
			switch(curSong.toLowerCase())
			{
				case 'winter-horrorland':
					mallEvilIntro();
				case 'senpai' | 'roses' | 'thorns':
					if (curSong.toLowerCase() == 'roses')
						FlxG.sound.play(Paths.sound('ANGRY', 'shared'));

					if (dialogue != null)
						schoolIntro(dialogueBox);
					else
						startCountdown();
				default:
					if (dialogue != null)
						startDialogue(dialogueBox);
					else
						startCountdown();
			}
		}
		else
		{
			switch(curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function mallEvilIntro():Void
	{
		inCutscene = true;
		camHUD.visible = false;

		var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			remove(blackScreen);

			FlxG.sound.play(Paths.sound('Lights_Turn_On', 'shared'));

			camFollow.y = -2050;
			camFollow.x += 200;

			FlxG.camera.focusOn(camFollow.getPosition());
			FlxG.camera.zoom = 1.5;

			new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				camHUD.visible = true;

				remove(blackScreen);

				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						startCountdown();
					}
				});
			});
		});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		camHUD.alpha = 0;
		
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy', 'week6');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter(XY);
		senpaiEvil.x += 180;

		if (gfVersion != '' || gfVersion != null)
			camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
		else
			camFollow.setPosition(FlxG.width / 2, FlxG.height / 2);
		
		FlxG.camera.focusOn(camFollow.getPosition());

		switch(SONG.song.toLowerCase())
		{
			case 'roses' | 'thorns':
			{
				remove(black);

				if (SONG.song.toLowerCase() == 'thorns')
					add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
				tmr.reset(0.3);
			else
			{
				if (SONG.song.toLowerCase() == 'thorns')
				{
					add(senpaiEvil);
					senpaiEvil.alpha = 0;

					new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
					{
						senpaiEvil.alpha += 0.15;

						if (senpaiEvil.alpha < 1)
							swagTimer.reset();
						else
						{
							senpaiEvil.animation.play('idle');

							FlxG.sound.play(Paths.sound('Senpai_Dies', 'shared'), 1, false, null, true, function()
							{
								remove(senpaiEvil);
								remove(red);

								FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
								{
									add(dialogueBox);
								}, true);
							});

							new FlxTimer().start(3.2, function(deadTime:FlxTimer)
							{
								FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
							});
						}
					});
				}
				else
					add(dialogueBox);

				remove(black);
			}
		});
	}

	function startDialogue(?dialogueBox:DialogueBox):Void
	{
		if (dialogueBox != null)
		{
			remove(dialogueBox);

			inCutscene = true;
			camHUD.alpha = 0;

			if (gfVersion != '' || gfVersion != null)
				camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
			else
				camFollow.setPosition(FlxG.width / 2, FlxG.height / 2);

			FlxG.camera.focusOn(camFollow.getPosition());

			add(dialogueBox);
		}
	}

	function createDialogue(isEndDialogue:Bool = false):Void
	{
		var file:String = Paths.txt('SONGS/' + SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'Dialogue' + (isEndDialogue ? '-end' : ''));

		try{
			dialogue = CoolUtil.coolTextFile(file);
		}
		catch(ex:Any){
			dialogue = null;
		}

		if (dialogue != null)
		{
			dialogueBox = new DialogueBox(dialogue);
			dialogueBox.scrollFactor.set();
			dialogueBox.finishThing = (isEndDialogue ? checkEndCutscene : startCountdown);
			dialogueBox.cameras = [camDialogue];
		}
	}

	public function startCutscene(path:String):Void
	{
		var video:MP4Handler = new MP4Handler();

		inCutscene = true;
		camHUD.alpha = 0;

		video.playMP4(Paths.video(path));

		video.finishCallback = function()
		{
			if (isStoryMode)
				endStorymode(true);
			else
				endFreeplay();
		}
	}

	var startTimer:FlxTimer;

	function startCountdown():Void
	{
		inCutscene = false;

		FlxTween.tween(camHUD, {alpha: 1}, 0.85);

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;

		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();

			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();

			switch(curStage)
			{
				case 'school' | 'schoolEvil':
				{
					introAssets.set(curStage, [
						'weeb/pixelUI/ready-pixel',
						'weeb/pixelUI/set-pixel',
						'weeb/pixelUI/date-pixel'
					]);
				}
				default:
				{
					introAssets.set('default', [
						'ready',
						'set', 
						'go'
					]);
				}
			}

			var introAlts:Array<String> = introAssets['default'];
			var altSuffix:String = '';
			var altLibrary:String = 'shared';

			if (introAssets.exists(curStage))
				introAlts = introAssets[curStage];

			if (curStage.startsWith('school'))
			{
				altSuffix = '-pixel';
				altLibrary = 'week6';
			}

			switch (swagCounter)
			{
				case 0:
				{
					FlxG.sound.play(Paths.sound('intro3' + altSuffix, 'shared'), 0.6);
				}
				case 1:
				{
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0], altLibrary));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);

					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});

					FlxG.sound.play(Paths.sound('intro2' + altSuffix, 'shared'), 0.6);
				}
				case 2:
				{
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1], altLibrary));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);

					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});

					FlxG.sound.play(Paths.sound('intro1' + altSuffix, 'shared'), 0.6);
				}
				case 3:
				{
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2], altLibrary));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);

					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});

					FlxG.sound.play(Paths.sound('introGo' + altSuffix, 'shared'), 0.6);
				}
			}
			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		songLength = FlxG.sound.music.length;

		if (MythsListEngineData.songpositionDisplay)
		{
			remove(songBarBG);
			remove(songBar);

			songBarBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar', 'shared'));
			songBarBG.screenCenter(X);
			songBarBG.scrollFactor.set();

			if (MythsListEngineData.downScroll)
		    	songBarBG.y = FlxG.height - songBarBG.height - 10;

			add(songBarBG);

			songBar = new FlxBar(songBarBG.x + 4, songBarBG.y + 4, LEFT_TO_RIGHT, Std.int(songBarBG.width - 8), Std.int(songBarBG.height - 8), this, 'songPosition', 0, songLength - 100);
			songBar.numDivisions = 1000;
			songBar.scrollFactor.set();
			songBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString(dad.healthBarColor));
			add(songBar);

			songBarBG.cameras = [camHUD];
			songBar.cameras = [camHUD];
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		if (fc)
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC);
		else
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC);
		#end
	}

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;

		Conductor.changeBPM(songData.bpm);
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;
		noteData = songData.notes;

		var daBeats:Int = 0;

		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteType:Int = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				var oldNote:Note;

				if (daStrumTime < 0)
					daStrumTime = 0;

				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;

				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daNoteType);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				if (MythsListEngineData.arrowColors && daNoteType == 0)
					swagNote.color = FlxColor.fromRGB(colorArray[daNoteData][0], colorArray[daNoteData][1], colorArray[daNoteData][2]);

				var susLength:Float = swagNote.sustainLength / Conductor.stepCrochet;

				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daNoteType);
					sustainNote.scrollFactor.set();

					if (MythsListEngineData.arrowColors && daNoteType == 0)
						sustainNote.color = FlxColor.fromRGB(colorArray[daNoteData][0], colorArray[daNoteData][1], colorArray[daNoteData][2]);

					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
						sustainNote.x += FlxG.width / 2;
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
					swagNote.x += FlxG.width / 2;
			}
			daBeats += 1;
		}
		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}

	function updateAccuracy()
	{
		totalPlayed += 1;

		accuracy = Math.max(0, (totalNotesHit / totalPlayed * 100));
		accuracyDefault = Math.max(0, (totalNotesHitDefault / totalPlayed * 100));

		// trace(totalNotesHit + " / " + totalPlayed + " * 100 = " + accuracy + "%");

		if (misses <= 0)
			fc = true;
		else
			fc = false;

		updateRating();
	}

	function updateRating()
	{
		if (accuracy >= 98)
			rating = 'S+';
		else if (accuracy >= 92 && accuracy < 98)
			rating = 'S';
		else if (accuracy >= 80 && accuracy < 92)
			rating = 'A';
		else if (accuracy >= 75 && accuracy < 80)
			rating = 'B';
		else if (accuracy >= 70 && accuracy < 75)
			rating = 'C';
		else if (accuracy >= 60 && accuracy < 70)
			rating = 'D';
		else if (accuracy >= 50 && accuracy < 60)
			rating = 'E';
		else
			rating = 'F';
	}

	static function sortByShit(obj1:Note, obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, obj1.strumTime, obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch(curStage)
			{
				case 'school' | 'schoolEvil':
					var imagePath:String = (MythsListEngineData.arrowColors ? 'weeb/pixelUI/customarrows-pixels' : 'weeb/pixelUI/arrows-pixels');

					babyArrow.frames = Paths.getSparrowAtlas(imagePath, 'week6');

					babyArrow.animation.addByPrefix('purple', 'arrows-pixels greyleft');
					babyArrow.animation.addByPrefix('blue', 'arrows-pixels greydown');
					babyArrow.animation.addByPrefix('green', 'arrows-pixels greyup');
					babyArrow.animation.addByPrefix('red', 'arrows-pixels greyright');

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					babyArrow.x += Note.swagWidth * i;

					switch(i)
					{
						case 0:
							babyArrow.animation.addByPrefix('static', 'arrows-pixels greyleft');
							babyArrow.animation.addByPrefix('pressed', 'arrows-pixels pressleft', 12, false);
							babyArrow.animation.addByPrefix('confirm', 'arrows-pixels confirmleft', 24, false);
						case 1:
							babyArrow.animation.addByPrefix('static', 'arrows-pixels greydown');
							babyArrow.animation.addByPrefix('pressed', 'arrows-pixels pressdown', 12, false);
							babyArrow.animation.addByPrefix('confirm', 'arrows-pixels confirmdown', 24, false);
						case 2:
							babyArrow.animation.addByPrefix('static', 'arrows-pixels greyup');
							babyArrow.animation.addByPrefix('pressed', 'arrows-pixels pressup', 12, false);
							babyArrow.animation.addByPrefix('confirm', 'arrows-pixels confirmup', 12, false);
						case 3:
							babyArrow.animation.addByPrefix('static', 'arrows-pixels greyright');
							babyArrow.animation.addByPrefix('pressed', 'arrows-pixels pressright', 12, false);
							babyArrow.animation.addByPrefix('confirm', 'arrows-pixels confirmright', 24, false);
					}

				default:
					var imagePath:String = (MythsListEngineData.arrowColors ? 'customNOTE_assets' : 'NOTE_assets');	

					babyArrow.frames = Paths.getSparrowAtlas(imagePath, 'shared');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = MythsListEngineData.antiAliasing;

					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					babyArrow.x += Note.swagWidth * i;

					switch(i)
					{
						case 0:
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch(player)
			{
				case 0:
					cpuStrums.add(babyArrow);

					if (MythsListEngineData.middleScroll)
						babyArrow.visible = false;
				case 1:
					playerStrums.add(babyArrow);

					if (MythsListEngineData.middleScroll)
						babyArrow.x += (((FlxG.width / 2) * -0.42) - 46);
			}

			babyArrow.animation.play('static');
			babyArrow.color = FlxColor.WHITE;

			babyArrow.x += 96;
			babyArrow.x += ((FlxG.width / 2) * player);

			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets();
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			paused = false;

			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;

			#if desktop
			if (startTimer.finished)
			{
				if (fc)
					DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC, true, songLength - Conductor.songPosition);
				else
					DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
				DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText, iconRPC);
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
				DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText, iconRPC, true, songLength - Conductor.songPosition);
			else
				DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText, iconRPC);
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (fc)
				DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC);
			else
				DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC);	
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;

		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;

	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num:Float = number;

		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);

		return num;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MythsListEngineData.backgroundDisplay)
		{
			switch(curStage)
			{
				case 'philly':
				{
					if (trainMoving)
					{
						trainFrameTiming += elapsed;

						if (trainFrameTiming >= 1 / 24)
						{
							updateTrainPos();
							trainFrameTiming = 0;
						}
					}

					Stage.background.members[2].alpha -= ((Conductor.crochet / 1000) * FlxG.elapsed) * 1.2;
				}
			}
		}

		weekTxt.text = 'Week ' + storyWeek;

		if (MythsListEngineData.inputsCounter)
		{
			inputsTxt.text =
			'Sicks: ' + sicks
			+ '\nGoods: ' + goods
			+ '\nBads: ' + bads
			+ '\nShits: ' + shits
			+ '\n';

			inputsTxt.screenCenter(Y);
			inputsTxt.y -= 20;
		}

		if (MythsListEngineData.statsDisplay)
		{
			if (fc)
				scoreTxt.text = "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)";
			else
				scoreTxt.text = "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating;

			scoreTxt.updateHitbox();
			scoreTxt.x = (FlxG.width / 2) - (scoreTxt.width / 2);
		}

		songTxt.text = PlayState.SONG.song.toUpperCase() + ' ';
		diffTxt.text = '(' + CoolUtil.difficultyArray[PlayState.storyDifficulty][0].toUpperCase() + ')';

		engineversion.text = "MythsList Engine - " + MythsListEngineData.engineVersion;
		version.text = MythsListEngineData.modVersion;

		var pauseControlArray:Array<Bool> = [controls.PAUSE, controls.ACCEPT];

		if (pauseControlArray.contains(true) && startedCountdown && canPause && !paused)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if(FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			if (fc)
				DiscordClient.changePresence(detailsPausedText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC);
			else
				DiscordClient.changePresence(detailsPausedText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC);
			#end
		}

		#if debug
			if (FlxG.keys.justPressed.SEVEN && !endingSong)
				FlxG.switchState(new ChartingState());
		#end

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.25 / ((SONG.bpm / 0.65) / 60))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.25 / ((SONG.bpm / 0.65) / 60))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent <= 20)
		{
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent >= 80)
		{
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		if (controls.RESET && !inCutscene && !startingSong && !endingSong)
			health = 0;

		#if debug
			if (FlxG.keys.justPressed.EIGHT && !endingSong)
				FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		#if debug
			if (FlxG.keys.justPressed.NINE && !endingSong)
			{
				if (charSelectionExists)
				{
					switch(MythsListEngineData.characterSkin)
					{
						case 'bf':
							FlxG.switchState(new AnimationDebug(SONG.player1));
						default:
							FlxG.switchState(new AnimationDebug(MythsListEngineData.characterSkin));
					}
				}
				else
					FlxG.switchState(new AnimationDebug(SONG.player1));
			}
		#end

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.fullscreen = !FlxG.fullscreen;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;

				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			songPosition = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		var curNote = PlayState.SONG.notes[Std.int(curStep / 16)];

		if (generatedMusic && curNote != null)
		{
			if (camFollow.x != dad.getMidpoint().x + 150 && !curNote.mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

				switch(dad.curCharacter)
				{
					case 'spooky':
						camFollow.y = boyfriend.getMidpoint().y - 140;
					case 'pico':
						camFollow.y = boyfriend.getMidpoint().y - 160;
					case 'mom':
					{
						if (dad.curCharacter != 'mom-car')
							camFollow.y = dad.getMidpoint().y;

						vocals.volume = 1;
					}
					case 'senpai' | 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 90;
				}

				switch(SONG.song.toLowerCase())
				{
					case 'tutorial':
						tweenCamIn();
				}
			}

			if (curNote.mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch(curStage)
				{
					case 'spooky':
						camFollow.y = boyfriend.getMidpoint().y - 140;
					case 'philly':
						camFollow.y = boyfriend.getMidpoint().y - 160;
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school' | 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				switch(SONG.song.toLowerCase())
				{
					case 'tutorial':
						FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}	
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("curBeat", curBeat);
		FlxG.watch.addQuick("curStep", curStep);

		switch(curSong.toLowerCase())
		{
			case 'fresh':
			{
				switch(curBeat)
				{
					case 16 | 80:
						camZooming = (curBeat == 16 ? true : false);
						gfSpeed = 2;
					case 48 | 112:
						gfSpeed = 1;
				}
			}
			case 'bopeebo':
			{
				switch(curBeat)
				{
					case 128 | 129 | 130:
						vocals.volume = 0;
				}
			}
		}

		if (health <= 0)
		{
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			//DEATH ACHIEVEMENT

			FlxG.save.data.deathAmount ++;
			FlxG.save.flush();

			MythsListEngineData.dataSave();
			AchievementsUnlock.deathAchievement();

			//DEATH ACHIEVEMENT

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, boyfriend.curCharacter));
			
			#if desktop
			DiscordClient.changePresence("[GAME OVER] " + detailsText, SONG.song + storyDifficultyText, iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if ((!MythsListEngineData.downScroll && daNote.y > FlxG.height) || (MythsListEngineData.downScroll && daNote.y < -FlxG.height))
				{
				    daNote.active = false;
				    daNote.visible = false;
				}
				else
				{
					daNote.active = true;
					daNote.visible = true;
				}

				if (MythsListEngineData.middleScroll && daNote.x <= (FlxG.width / 4))
					daNote.alpha = 0;
				else
					daNote.alpha = 1;

				if (MythsListEngineData.downScroll)
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
					else
						daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));

				    if (daNote.isSustainNote)
				    {
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
							daNote.y += ((daNote.prevNote.height / 1.05) * (0.37 * 1.6)) + (0.1 * SONG.speed) + 4;

						if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
						{
								var swagRect:FlxRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
								swagRect.y /= daNote.scale.y;
								swagRect.height -= swagRect.y;
	
								daNote.clipRect = swagRect;
						}
				   }
				}
				else
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
					else
						daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));

					if (daNote.isSustainNote)
					{
				   		if (daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2 && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				    	{
					   		var swagRect:FlxRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					   		swagRect.y /= daNote.scale.y;
				       		swagRect.height -= swagRect.y;

					   		daNote.clipRect = swagRect;
				    	}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					var altAnim:String = '';

					if (SONG.song.toLowerCase() != 'tutorial')
						camZooming = true;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					var singData:Int = Std.int(Math.abs(daNote.noteData));

					dad.playAnim('sing' + curPress[singData] + altAnim, true);

					cpuStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);

							if (MythsListEngineData.arrowColors)
								spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
						}

						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
						else
							spr.centerOffsets();
					});

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.active = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (daNote.mustPress && !MythsListEngineData.botPlay && ((daNote.y < -daNote.height && !MythsListEngineData.downScroll) || (daNote.y > FlxG.height + daNote.height && MythsListEngineData.downScroll)))
				{
					if (!daNote.wasGoodHit || daNote.tooLate)
					{
						if (!endingSong)
						{
							if (!daNote.isSustainNote)
							{
								combo = 0;
								misses++;
							}
							
							health -= 0.075;
						}

						vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();

					updateAccuracy();
				}
			});
		}

		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.curAnim.name == 'confirm' && spr.animation.finished)
			{
				spr.animation.play('static', true);
				spr.centerOffsets();
				spr.color = FlxColor.WHITE;
			}
		});

		if (MythsListEngineData.botPlay)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.curAnim.name == 'confirm' && spr.animation.finished)
				{
					spr.animation.play('static', true);
					spr.centerOffsets();
					spr.color = FlxColor.WHITE;
				}
			});

			if ((boyfriend.animation.curAnim.curFrame >= 14 || boyfriend.animation.finished) && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && health > 0)
				boyfriend.playAnim('idle');
		}

		if (!inCutscene && !startingSong && !endingSong)
			keyShit();
	}

	function endSong():Void
	{
		canPause = false;
		endingSong = true;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		Highscore.saveScore(SONG.song, songScore, storyDifficulty);
		
		// DATA

		// Did you think you will be awarded for beating a song with some help?
		if (!MythsListEngineData.botPlay)
		{
			FlxG.save.data.playAmount ++;

			if (fc)
				FlxG.save.data.fcAmount ++;
		
			if (MythsListEngineData.downScroll)
				FlxG.save.data.playDownscroll = true;
			else
				FlxG.save.data.playUpscroll = true;

			if (MythsListEngineData.middleScroll)
			{
				FlxG.save.data.playMiddlescroll = true;

				if (MythsListEngineData.downScroll)
					FlxG.save.data.playDownMiddlescroll = true;
				else
					FlxG.save.data.playUpMiddlescroll = true;
			}

			FlxG.save.flush();

			MythsListEngineData.dataSave();

			AchievementsUnlock.fcAchievement();
			AchievementsUnlock.playAchievement();
			AchievementsUnlock.scrollAchievement();
		}

		// DATA

		var freeplaySongsWithDialogue:Array<String> = [
			// 'tutorial'
		];

		createDialogue(true);

		if (dialogue != null)
		{
			if (isStoryMode || (!isStoryMode && freeplaySongsWithDialogue.contains(SONG.song.toLowerCase())))
				startDialogue(dialogueBox);
			else
				checkEndCutscene();
		}
		else
			checkEndCutscene();
	}

	function checkEndCutscene()
	{
		var curCutscene:String = null;
		var hasCutscene:Bool = false;
		var freeplayCutscene:Bool = false;

		for (item in CoolUtil.endCutsceneArray)
		{
			if (item[0] == SONG.song.toLowerCase())
			{
				curCutscene = item[1];
				hasCutscene = true;

				if (item[2] == true)
					freeplayCutscene = true;
			}
		}

		if (isStoryMode)
		{
			if (hasCutscene && curCutscene != null)
				startCutscene(curCutscene);
			else
				endStorymode(hasCutscene);
		}
		else
		{
			if (hasCutscene && freeplayCutscene && curCutscene != null)
				startCutscene(curCutscene);
			else
				endFreeplay();
		}
	}

	function endStorymode(hadCutscene:Bool = false)
	{
		campaignScore += Math.round(songScore);

		storyPlaylist.remove(storyPlaylist[0]);

		if (storyPlaylist.length <= 0)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu', 'preload'));

			if (!hadCutscene)
			{
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}

			FlxG.switchState(new StoryMenuState());

			StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

			Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

			FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
			FlxG.save.flush();
		}
		else
		{
			var difficulty:String = CoolUtil.difficultyArray[storyDifficulty][1];

			switch(SONG.song.toLowerCase())
			{
				case 'eggnog':
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();

					add(blackShit);

					camHUD.visible = false;
		
					FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'));
				}
			}

			if (!hadCutscene)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
			}

			prevCamFollow = camFollow;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
			FlxG.sound.music.stop();

			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function endFreeplay()
	{
		FlxG.switchState(new FreeplayState());
	}

	private function popUpScore(daNote:Note):Void
	{
		vocals.volume = 1;

		var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();

		var daRating:String = 'sick';

		if (!MythsListEngineData.botPlay)
		{
			if (noteDiff > Conductor.safeZoneOffset * 0.85)
			{
				daRating = 'shit';
				totalNotesHit += 0.2;
				songScore += 0;
				shits++;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.65)
			{
				daRating = 'bad';
				totalNotesHit += 0.45;
				songScore += 50;
				bads++;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.45)
			{
				daRating = 'good';
				totalNotesHit += 0.75;
				songScore += 200;
				goods++;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0)
			{
				daRating = 'sick';
				totalNotesHit += 1;
				songScore += 350;
				sicks++;
			}
		}
		else
		{
			daRating = 'sick';
			totalNotesHit += 1;
			songScore += 350;
			sicks++;
		}

		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		var newLibrary:String = 'shared';
		var newLibrary2:String = 'preload';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
			newLibrary = 'week6';
			newLibrary2 = 'week6';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, newLibrary));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		add(rating);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, newLibrary));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = MythsListEngineData.antiAliasing;

			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = MythsListEngineData.antiAliasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];
		var comboSplit:Array<String> = (combo + '').split('');						  

		if (comboSplit.length == 1)
		{
			seperatedScore.push(0);
			seperatedScore.push(0);
		}
		else if (comboSplit.length == 2)
			seperatedScore.push(0);

		for(i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;

		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2, newLibrary2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				numScore.antialiasing = MythsListEngineData.antiAliasing;
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				numScore.antialiasing = false;
			}

			numScore.updateHitbox();
			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}

		coolText.text = Std.string(seperatedScore);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		var controlArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var controlArrayPress:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var controlArrayRelease:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		if (MythsListEngineData.botPlay)
		{
			controlArray = [false, false, false, false];
			controlArrayPress = [false, false, false, false];
			controlArrayRelease = [false, false, false, false];
		}

		if ((controlArrayPress.contains(true) || MythsListEngineData.botPlay) && generatedMusic && !endingSong)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];
			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote:Note = possibleNotes[0];

				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArrayPress[coolNote.noteData] || MythsListEngineData.botPlay)
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;

								for (shit in 0...ignoreList.length)
								{
									if (controlArrayPress[ignoreList[shit]])
										inIgnoreList = true;
								}

								if (!inIgnoreList)
									badNoteCheck(coolNote);
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArrayPress, daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArrayPress, daNote);
						}
					}
				}
				else
				{
					noteCheck(controlArrayPress, daNote);
				}
			}
			else
			{
				badNoteCheck(null);
			}
		}
		
		if ((controlArray.contains(true) || MythsListEngineData.botPlay) && generatedMusic && !endingSong)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
						goodNoteHit(daNote);
					else if (!daNote.canBeHit && daNote.tooLate)
						daNote.kill();
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!controlArray.contains(true) || MythsListEngineData.botPlay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && health > 0)
				boyfriend.playAnim('idle');
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (controlArrayPress[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animation.play('pressed');

				if (MythsListEngineData.arrowColors)
					spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
			}

			if (controlArrayRelease[spr.ID])
			{
				spr.animation.play('static');
				spr.color = FlxColor.WHITE;
			}
			
			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 0, noteType:Int = 0):Void
	{
		if (!MythsListEngineData.botPlay && health > 0)
		{
			if (combo >= 5 && gf.animOffsets.exists('sad'))
				gf.playAnim('sad');

			switch(noteType)
			{
				case 0:
				{
					combo = 0;
					misses++;
					health -= 0.02;
					songScore -= 10;

					FlxG.sound.play(Paths.soundRandom('missnote', 1, 3, 'shared'), FlxG.random.float(0.1, 0.2));

					boyfriend.playAnim('sing' + curPress[direction] + 'miss', true);

					updateAccuracy();
				}
			}
		}
	}

	function badNoteCheck(daNote:Note):Void
	{
		var controlArrayPress:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];

		if (!MythsListEngineData.ghostTapping && !MythsListEngineData.botPlay)
		{
			if (daNote == null)
			{
				if (controlArrayPress[0])
					noteMiss(0);
				if (controlArrayPress[1])
					noteMiss(1);
				if (controlArrayPress[2])
					noteMiss(2);
				if (controlArrayPress[3])
					noteMiss(3);
			}
			else
			{
				noteMiss(daNote.noteData, daNote.noteType);
			}
		}
	}

	function noteCheck(controlArray:Array<Bool>, note:Note):Void
	{
		if (!endingSong)
		{
			if (controlArray[note.noteData] || MythsListEngineData.botPlay)
				goodNoteHit(note);
			else
				badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit && health > 0)
		{
			if (!note.isSustainNote)
			{
				combo++;
				popUpScore(note);
			}

			switch(note.noteType)
			{
				case 0:
				{
					if (note.noteData >= 0)
						health += 0.023;
					else
						health += 0.004;
				}
			}

			boyfriend.playAnim('sing' + curPress[note.noteData], true);

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (note.noteData == spr.ID)
				{
					spr.animation.play('confirm', true);

					if (MythsListEngineData.arrowColors)
						spr.color = FlxColor.fromRGB(colorArray[spr.ID][0], colorArray[spr.ID][1], colorArray[spr.ID][2]);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			if (!note.isSustainNote)
				updateAccuracy();
			else
			{
				totalNotesHit += 1;
				updateAccuracy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1, 'shared'), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFinishing:Bool = false;

	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;

		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			Stage.background.members[4].x -= 400;

			if (Stage.background.members[4].x < -2000 && !trainFinishing)
			{
				Stage.background.members[4].x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (Stage.background.members[4].x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		Stage.background.members[4].x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2, 'shared'));
		Stage.background.members[0].playAnim('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (boyfriend.animOffsets.exists('scared') && health > 0)
			boyfriend.playAnim('scared', true);

		gf.playAnim('scared', true);

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if (gf.danced)
				gf.playAnim('danceRight');
			else
				gf.playAnim('danceLeft');
		});
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		#if desktop
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		if (fc)
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC, true, songLength - Conductor.songPosition);
		else
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC, true, songLength - Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(FlxSort.byY, (MythsListEngineData.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));

		var note = SONG.notes[Math.floor(curStep / 16)];

		if (note != null)
		{
			if (note.changeBPM)
			{
				Conductor.changeBPM(note.bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (dad.animation.curAnim.name.startsWith('sing') && dad.curCharacter != 'gf')
			{
				if (dad.animation.finished)
					dad.dance();
			}
			else
				dad.dance();
		}
		
		wiggleShit.update(Conductor.crochet);

		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curBeat % gfSpeed == 0)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (!boyfriend.animation.curAnim.name.startsWith('sing') && health > 0)
			boyfriend.playAnim('idle');

		// MID-SONG EVENTS I GUESS

		switch(curSong.toLowerCase())
		{
			case 'tutorial':
			{
				if (curBeat % 16 == 15 && curBeat > 16 && curBeat < 48 && boyfriend.animOffsets.exists('hey') && dad.animOffsets.exists('cheer') && health > 0)
				{
					boyfriend.playAnim('hey', true);
					dad.playAnim('cheer', true);
				}
			}
			case 'bopeebo':
			{
				if (curBeat % 8 == 7 && boyfriend.animOffsets.exists('hey') && health > 0)
					boyfriend.playAnim('hey', true);
				else if ((curBeat == 47 || curBeat == 111) && boyfriend.animOffsets.exists('hey') && health > 0)
				{
					new FlxTimer().start(0.3, function(tmr:FlxTimer)
					{
						boyfriend.playAnim('hey', true);
					});
				}
			}
		}

		if (MythsListEngineData.backgroundDisplay)
		{
			switch(curStage)
			{
				case 'school':
					bgGirls.dance();
				case 'mall':
					Stage.background.members[1].playAnim('Upper Crowd Bob', true);
					Stage.background.members[4].playAnim('Bottom Level Boppers', true);
					Stage.background.members[6].playAnim('santa idle in fear', true);
				case 'limo':
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});

					if (FlxG.random.bool(10) && fastCarCanDrive)
						fastCarDrive();
				case 'philly':
					if (!trainMoving)
						trainCooldown += 1;

					if (curBeat % 4 == 0)
					{
						Stage.background.members[2].visible = false;

						var curLight:Int = FlxG.random.int(0, 4);
						Stage.background.members[2].visible = true;
						Stage.background.members[2].alpha = 1;

						var lightcolorArray:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];

						Stage.background.members[2].color = lightcolorArray[curLight];
					}

					if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				case 'spooky':
					if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
						lightningStrikeShit();
			}
		}
	}
}