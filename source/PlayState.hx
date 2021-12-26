package;

#if desktop
import Discord.DiscordClient;
#end
import MythsListEngineData;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import Modchart;
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
import openfl.utils.Assets as OpenFlAssets;

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
	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public static var dadX:Float = 100;
	public static var dadY:Float = 100;
	public static var bfX:Float = 770;
	public static var bfY:Float = 450;
	public static var gfX:Float = 400;
	public static var gfY:Float = 130;

	private var gfSpeed:Int = 1;

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var curPress:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var cpuStrums:FlxTypedGroup<FlxSprite>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var combo:Int = 0;
	public var misses:Int = 0;
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	public var accuracy:Float = 0.00;
	public var totalNotesHit:Float = 0;
	public var totalPlayed:Int = 0;

	public var fc:Bool = true;
	public var rating:String = 'S+';

	public var health:Float = 1;
	private var healthBarBG:FlxSprite;
	public static var healthBar:FlxBar;

	private var songBarBG:FlxSprite;
	public var songBar:FlxBar;
	public var songBarText:FlxText;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;
	public var endingSong:Bool = false;

	private var charSelectionExists:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	public var camZooming:Bool = false;
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
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
	public var inCutscene:Bool = false;
	var dialogueBox:DialogueBox;

	public var songLength:Float = 0;
	public var songPosition:Float = 0;

	public var songScore:Int = 0;
	public static var campaignScore:Int = 0;

	public var scoreTxt:FlxText;
	public var inputsTxt:FlxText;
	public var songTxt:FlxText;
	public var diffTxt:FlxText;
	public var weekTxt:FlxText;
	public var botTxt:FlxText;
	public var engineversion:FlxText;

	public var colorArray:Array<Dynamic>;

	public static var defaultCamZoom:Float = 1.05;
	public static var daPixelZoom:Float = 6;

	#if desktop
		var storyDifficultyText:String = '';
		var iconRPC:String = '';
		var detailsText:String = '';
		var detailsPausedText:String = '';
	#end

	private var modchartArray:Array<Modchart> = [];

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

		if (SONG == null) SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		createDialogue(false);

		#if desktop
		storyDifficultyText = ' (' + CoolUtil.difficultyArray[storyDifficulty][0].toUpperCase() + ') ';
		detailsText = (isStoryMode ? 'Story: Week - ' + storyWeek : 'Freeplay: ');
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

		dadX = 100;
		dadY = 100;
		bfX = 770;
		bfY = 450;
		gfX = 400;
		gfY = 130;

		// STAGE

		curStage = (SONG.stage != null ? SONG.stage : 'stage');
		defaultCamZoom = 1.05;

		if (MythsListEngineData.backgroundDisplay && curStage != null)
		{
			var daStage:Stage = new Stage(curStage);
			add(Stage.background);

			defaultCamZoom = Stage.camZoom;
		}

		// GIRLFRIEND

		if (SONG.player3 != 'none')
		{
			gf = new Character(gfX, gfY, (SONG.player3 != null ? SONG.player3 : 'gf'));
			gf.updateCharacterCoordinate('gf');
			gf.scrollFactor.set(0.95, 0.95);
			makeTrail(gf);
		}

		// DAD

		dad = new Character(dadX, dadY, SONG.player2);
		dad.updateCharacterCoordinate('dad');
		makeTrail(dad);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch(SONG.player2)
		{
			case 'gf':
				if (gf != null) gf.visible = false;

				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
			case 'senpai' | 'senpai-angry':
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'spirit':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		// BOYFRIEND

		for (i in OptionsSubState.textMenuItems)
		{
			if (i.toLowerCase() == 'character selection')
				charSelectionExists = true;
		}

		if (charSelectionExists)
		{
			switch(SONG.song.toLowerCase())
			{
				// Forces a Boyfriend skin on certain songs

				case 'senpai' | 'roses' | 'thorns':
					boyfriend = new Boyfriend(bfX, bfY, SONG.player1);

				// Doesn't force a Boyfriend skin

				default:
					if (MythsListEngineData.characterSkin == 'bf' || !CharacterSelectionSubState.characters.contains(MythsListEngineData.characterSkin))
						boyfriend = new Boyfriend(bfX, bfY, SONG.player1);
					else
						boyfriend = new Boyfriend(bfX, bfY, MythsListEngineData.characterSkin);
			}
		}
		else
			boyfriend = new Boyfriend(bfX, bfY, SONG.player1);
		
		boyfriend.updateCharacterCoordinate('bf');
		makeTrail(boyfriend);

		// CHARACTER POSITIONING

		switch(curStage)
		{
			case 'limo':
				boyfriend.setCharacterCoordinate('bf', 260, -220, true);

				if (MythsListEngineData.backgroundDisplay)
				{
					resetFastCar();
					add(fastCar);
				}
			case 'mall':
				boyfriend.setCharacterCoordinate('bf', 200, null, true);
			case 'mallEvil':
				boyfriend.setCharacterCoordinate('bf', 320, null, true);
				dad.setCharacterCoordinate('dad', null, -80, true);
			case 'school' | 'schoolEvil':
				boyfriend.setCharacterCoordinate('bf', 200, 220, true);
				if (gf != null) gf.setCharacterCoordinate('gf', 180, 300, true);
		}

		// LAYERING

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
			if (item != null) add(item);
		}

		//

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, (!MythsListEngineData.downScroll ? 50 : 550)).makeGraphic(FlxG.width, 10);
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

		if (MythsListEngineData.downScroll)
		{
		    engineversion.y = 3;
			songTxt.y = engineversion.y + engineversion.height;
			diffTxt.y = songTxt.y;
			weekTxt.y = songTxt.y + songTxt.height;
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

		if (!MythsListEngineData.versionDisplay)
		{
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
			
		if (MythsListEngineData.inputsCounter)
			inputsTxt.cameras = [camHUD];

		boyfriend.setCharacterPosition('bf');
		dad.setCharacterPosition('dad');
		if (gf != null) gf.setCharacterPosition('gf');

		startingSong = true;
		setOnLuas('startingSong', startingSong);

		var modchartFile:String = 'SONGS/' + PlayState.SONG.song.toLowerCase() + '/modchart';

		if (OpenFlAssets.exists(Paths.lua(modchartFile, 'preload')))
		{
			modchartFile = Paths.lua(modchartFile, 'preload');
			modchartArray.push(new Modchart(modchartFile));
		}

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

		if (gf != null)
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

			if (gf != null)
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

		dialogue = (OpenFlAssets.exists(file) ? CoolUtil.coolTextFile(file) : null);

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

		if (startedCountdown)
		{
			callOnLuas('startCountdown', []);
			return;
		}

		var ret:Dynamic = callOnLuas('startCountdown', []);

		if (ret != Modchart.Function_Stop)
		{
			generateStaticArrows(0);
			generateStaticArrows(1);

			for (i in 0...playerStrums.length)
			{
				setOnLuas('defPlrStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defPlrStrumY' + i, playerStrums.members[i].y);
			}

			for (i in 0...cpuStrums.length)
			{
				setOnLuas('defOppStrumX' + i, cpuStrums.members[i].x);
				setOnLuas('defOppStrumY' + i, cpuStrums.members[i].y);
			}

			talking = false;
			startedCountdown = true;
			
			setOnLuas('startedCountdown', startedCountdown);

			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;

			var swagCounter:Int = 0;

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null) gf.dance();
				dad.dance();
				boyfriend.dance();

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
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;
		setOnLuas('startingSong', startingSong);

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		songLength = FlxG.sound.music.length;
		setOnLuas('songLength', songLength);

		var player2hpColor:FlxColor = FlxColor.RED;

		if (dad.healthBarColor != '0xFF')
			player2hpColor = FlxColor.fromString(dad.healthBarColor);

		if (MythsListEngineData.songpositionDisplay)
		{
			songBarBG = new FlxSprite(0, 10).loadGraphic(Paths.image('songposBar', 'shared'));
			songBarBG.alpha = 0;
			songBarBG.screenCenter(X);
			songBarBG.scrollFactor.set();

			if (MythsListEngineData.downScroll)
		    	songBarBG.y = FlxG.height - songBarBG.height - 8;

			add(songBarBG);

			songBar = new FlxBar(songBarBG.x + 4, songBarBG.y + 4, LEFT_TO_RIGHT, Std.int(songBarBG.width - 8), Std.int(songBarBG.height - 8), this, 'songPosition', 0, songLength - 100);
			songBar.numDivisions = 1000;
			songBar.alpha = 0;
			songBar.scrollFactor.set();
			songBar.createFilledBar(FlxColor.GRAY, player2hpColor);
			add(songBar);

			songBarText = new FlxText(0, songBarBG.y - 4, 0, '0:00', 28);
			songBarText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songBarText.x = songBar.x + (songBar.width / 2) - (songBarText.width / 2);
			songBarText.alpha = 0;
			songBarText.scrollFactor.set();
			add(songBarText);

			songBarBG.cameras = [camHUD];
			songBar.cameras = [camHUD];
			songBarText.cameras = [camHUD];

			updateTime();

			FlxTween.tween(songBarBG, {alpha: 1}, 0.85);
			FlxTween.tween(songBar, {alpha: 1}, 0.85);
			FlxTween.tween(songBarText, {alpha: 1}, 0.85);
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		if (fc)
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC);
		else
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC);
		#end

		callOnLuas('startSong', []);
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
				swagNote.scrollFactor.set();

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

	public function updateAccuracy()
	{
		totalPlayed ++;

		fc = (misses <= 0 ? true : false);
		accuracy = Math.max(0, (totalNotesHit / totalPlayed * 100));

		setOnLuas('fc', fc);
		setOnLuas('accuracy', accuracy);

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

					var colorArray:Array<String> = ['purple', 'blue', 'green', 'red'];
					var dirArray:Array<String> = ['left', 'down', 'up', 'right'];

					babyArrow.frames = Paths.getSparrowAtlas(imagePath, 'week6');

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.antialiasing = false;

					babyArrow.animation.addByPrefix(colorArray[i], 'arrows-pixels grey' + dirArray[i]);
					babyArrow.animation.addByPrefix('static', 'arrows-pixels grey' + dirArray[i]);
					babyArrow.animation.addByPrefix('pressed', 'arrows-pixels press' + dirArray[i], 12, false);
					babyArrow.animation.addByPrefix('confirm', 'arrows-pixels confirm' + dirArray[i], 24, false);

				default:
					var imagePath:String = (MythsListEngineData.arrowColors ? 'customNOTE_assets' : 'NOTE_assets');

					var colorArray:Array<String> = ['purple', 'blue', 'green', 'red'];
					var dirArray:Array<String> = ['left', 'down', 'up', 'right'];

					babyArrow.frames = Paths.getSparrowAtlas(imagePath, 'shared');

					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.antialiasing = MythsListEngineData.antiAliasing;

					babyArrow.animation.addByPrefix(colorArray[i], 'arrow' + dirArray[i].toUpperCase());
					babyArrow.animation.addByPrefix('static', 'arrow' + dirArray[i].toUpperCase());
					babyArrow.animation.addByPrefix('pressed', dirArray[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', dirArray[i] + ' confirm', 24, false);
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.x += Note.swagWidth * i;

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

			strumLineNotes.add(babyArrow);

			strumLineNotes.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets();
			});
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

			callOnLuas('resume', []);

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

	function makeTrail(character:Character)
	{
		if (character.hasTrail)
		{
			var trail:FlxTrail;
	
			switch(character.curCharacter)
			{
				default:
					trail = new FlxTrail(character, null, 4, 24, 0.3, 0.069);
			}
	
			add(trail);
		}
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

		callOnLuas('update', [elapsed]);

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
		updateTime();

		botTxt.alpha = (MythsListEngineData.botPlay ? 1 : 0);

		var pauseControlArray:Array<Bool> = [controls.PAUSE, controls.ACCEPT];

		if (pauseControlArray.contains(true) && startedCountdown && canPause && !paused)
		{
			var ret:Dynamic = callOnLuas('pause', []);

			if (ret != Modchart.Function_Stop)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				if (FlxG.sound.music != null)
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
		}

		#if debug
			if (FlxG.keys.justPressed.SEVEN && !endingSong)
				FlxG.switchState(new ChartingState());
		#end

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.25 / ((SONG.bpm / 0.65) / 60))));
		iconP1.updateHitbox();
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.25 / ((SONG.bpm / 0.65) / 60))));
		iconP2.updateHitbox();

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - 26);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - 26);

		if (health > 2) health = 2;

		if (!iconP1.isAnimated) iconP1.updateIconState(false, true);
		if (!iconP2.isAnimated) iconP2.updateIconState(false, false);

		if (controls.RESET && !inCutscene && !startingSong && !endingSong)
			health = 0;

		#if debug
			if (FlxG.keys.justPressed.EIGHT && !endingSong)
				FlxG.switchState(new AnimationDebug(SONG.player2, false));
		#end

		#if debug
			if (FlxG.keys.justPressed.NINE && !endingSong)
			{
				if (charSelectionExists)
				{
					switch(MythsListEngineData.characterSkin)
					{
						case 'bf':
							FlxG.switchState(new AnimationDebug(SONG.player1, true));
						default:
							FlxG.switchState(new AnimationDebug(MythsListEngineData.characterSkin, true));
					}
				}
				else
					FlxG.switchState(new AnimationDebug(SONG.player1, true));
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

			setOnLuas('cameraX', camFollow.x);
			setOnLuas('cameraY', camFollow.y);
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
			var ret:Dynamic = callOnLuas('gameOver', []);

			if (ret != Modchart.Function_Stop)
			{
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
				boyfriend.stunned = true;

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
			var roundedSpeed:Float = FlxMath.roundDecimal(SONG.speed, 2);

			var strumX:Float = 0;
			var strumY:Float = 0;
			var strumWidth:Float = Note.swagWidth;

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

				if (MythsListEngineData.middleScroll && !daNote.mustPress)
				{
					daNote.active = true;
					daNote.visible = false;
				}

				if (daNote.mustPress)
				{
					strumX = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					strumY = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
					strumWidth = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].width;
				}
				else
				{
					strumX = cpuStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					strumY = cpuStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
					strumWidth = cpuStrums.members[Math.floor(Math.abs(daNote.noteData))].width;
				}

				if (!daNote.isSustainNote)
					daNote.x = strumX;
				else
					daNote.x = strumX + (strumWidth / 2) - (daNote.width / 2);

				if (MythsListEngineData.downScroll)
				{
					daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

				    if (daNote.isSustainNote)
				    {
						/*
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
							daNote.y += ((daNote.prevNote.height / 1.05) * 0.592) + (0.1 * SONG.speed) + 4;
						*/

						daNote.y -= daNote.height;
						daNote.y += Note.sustainOffset + (8 * SONG.speed);

						if (daNote.y - daNote.offset.y + daNote.height >= strumY + Note.swagWidth / 2 && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.y = (strumY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
							swagRect.height = daNote.frameHeight - swagRect.height;
	
							daNote.clipRect = swagRect;
						}
				   }
				}
				else
				{
					daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

					if (daNote.isSustainNote)
					{
						daNote.y += -25 - (8 * SONG.speed);

				   		if (daNote.y + daNote.offset.y <= strumY + Note.swagWidth / 2 && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				    	{
							var swagRect:FlxRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (strumY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;
	
							daNote.clipRect = swagRect;
				    	}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					var altAnim:String = '';
					var singData:Int = Std.int(Math.abs(daNote.noteData));
					var daSection:Dynamic = SONG.notes[Math.floor(curStep / 16)];

					if (SONG.song.toLowerCase() != 'tutorial')
						camZooming = true;

					if (daSection != null && daSection.altAnim)
						altAnim = '-alt';

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
						noteMiss(daNote.noteData, daNote.noteType, daNote, true);
					else
						updateAccuracy();

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
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
				boyfriend.dance();
		}

		if (!inCutscene && !startingSong && !endingSong)
			keyShit();

		setOnLuas('health', health);
		setOnLuas('downScroll', MythsListEngineData.downScroll);
		setOnLuas('middleScroll', MythsListEngineData.middleScroll);
		setOnLuas('ghostTapping', MythsListEngineData.ghostTapping);
		setOnLuas('botPlay', MythsListEngineData.botPlay);

		for (i in 0...playerStrums.length)
		{
			setOnLuas('defPlrStrumX' + i, playerStrums.members[i].x);
			setOnLuas('defPlrStrumY' + i, playerStrums.members[i].y);
		}
	
		for (i in 0...cpuStrums.length)
		{
			setOnLuas('defOppStrumX' + i, cpuStrums.members[i].x);
			setOnLuas('defOppStrumY' + i, cpuStrums.members[i].y);
		}

		callOnLuas('updateEnd', [elapsed]);
	}

	public var skipAchievements:Bool = false;

	public function endSong():Void
	{
		canPause = false;
		endingSong = true;

		setOnLuas('endingSong', endingSong);

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		Highscore.saveScore(SONG.song.toLowerCase(), songScore, storyDifficulty);
		
		// DATA

		// Did you think you will be awarded for beating a song with some help?
		if (!MythsListEngineData.botPlay && !skipAchievements)
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

		MythsListEngineData.dataSave();

		// DATA

		#if windows
		var ret:Dynamic = callOnLuas('endSong', []);
		#else
		var ret:Dynamic = Modchart.Function_Continue;
		#end

		var freeplaySongsWithDialogue:Array<String> = [
			// 'tutorial'
		];

		createDialogue(true);

		if (ret != Modchart.Function_Stop)
		{
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
			if (!hadCutscene)
			{
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}

			if (MythsListEngineData.resultsScreen)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				openSubState(new ResultsScreenSubState([sicks, goods, bads, shits], campaignScore, misses, truncateFloat(accuracy, 2), rating + (fc ? ' (FC)' : '')));
			}
			else
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
		if (MythsListEngineData.resultsScreen)
			openSubState(new ResultsScreenSubState([sicks, goods, bads, shits], songScore, misses, truncateFloat(accuracy, 2), rating + (fc ? ' (FC)' : '')));
		else
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

		setOnLuas('combo', combo);
		setOnLuas('score', songScore);
		setOnLuas('sicks', sicks);
		setOnLuas('goods', goods);
		setOnLuas('bads', bads);
		setOnLuas('shits', shits);
		setOnLuas('noteHits', totalNotesHit);
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
					if ((controlArray[daNote.noteData] || MythsListEngineData.botPlay) && daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
						goodNoteHit(daNote);
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!controlArray.contains(true) || MythsListEngineData.botPlay))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && health > 0)
				boyfriend.dance();
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

	function noteMiss(noteData:Int = 0, noteType:Int = 0, ?note:Note, ?tooLate:Bool = false):Void
	{
		if (!MythsListEngineData.botPlay && !endingSong && health > 0)
		{
			switch(noteType)
			{
				case 0:
				{
					if (gf != null && combo >= 5 && gf.animOffsets.exists('sad'))
						gf.playAnim('sad');

					if ((note != null && !note.isSustainNote) || note == null)
					{
						combo = 0;
						misses++;
					}

					health -= (!tooLate ? 0.02 : 0.075);
					songScore -= 10;

					vocals.volume = 0;
					FlxG.sound.play(Paths.soundRandom('missnote', 1, 3, 'shared'), FlxG.random.float(0.1, 0.2));

					if (boyfriend.animation.getByName('sing' + curPress[noteData] + 'miss') != null)
						boyfriend.playAnim('sing' + curPress[noteData] + 'miss', true);
				}
			}

			updateAccuracy();

			setOnLuas('combo', combo);
			setOnLuas('score', songScore);
			setOnLuas('misses', misses);
			setOnLuas('health', health);
			callOnLuas('noteMiss', [noteData, noteType, tooLate]);
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
					noteMiss(0, 0);
				if (controlArrayPress[1])
					noteMiss(1, 0);
				if (controlArrayPress[2])
					noteMiss(2, 0);
				if (controlArrayPress[3])
					noteMiss(3, 0);
			}
			else
			{
				noteMiss(daNote.noteData, daNote.noteType, daNote, false);
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
		if (!note.wasGoodHit && !endingSong && health > 0)
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
					health += (note.noteData >= 0 ? 0.023 : 0.004);

					boyfriend.playAnim('sing' + curPress[note.noteData], true);
				}
			}

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

			setOnLuas('noteHits', totalNotesHit);
			setOnLuas('health', health);
			callOnLuas('noteHit', [note.noteData, note.noteType]);
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
			
			if (gf != null && gf.animOffsets.exists('hairBlow'))
			{
				gf.playAnim('hairBlow');
				gf.stunned = true;
			}
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
		if (gf != null && gf.animOffsets.exists('hairFall'))
		{
			gf.playAnim('hairFall');
			gf.stunned = false;
		}

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

		if (gf != null && gf.animOffsets.exists('scared'))
			gf.playAnim('scared', true);
	}

	private var preventModchartRemove:Bool = false;

	override function destroy()
	{
		preventModchartRemove = true;

		for (i in 0...modchartArray.length)
		{
			modchartArray[i].call('onDestroy', []);
			modchartArray[i].stop();
		}

		modchartArray = [];

		super.destroy();
	}

	public function removeModchart(modchart:Modchart)
	{
		if (modchartArray != null && !preventModchartRemove)
			modchartArray.remove(modchart);
	}

	function updateTime()
	{
		var timeLeft:Float = (songLength - Conductor.songPosition);
		var secondsTotal:Int = Math.floor(timeLeft / 1000);
		if (secondsTotal < 0) secondsTotal = 0;

		if (songBarText != null)
		{
			songBarText.text = FlxStringUtil.formatTime(secondsTotal, false);
			songBarText.x = songBar.x + (songBar.width / 2) - (songBarText.width / 2);
		}
	}

	var lastStepHit:Int = -1;

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		if (curStep == lastStepHit)
			return;

		#if desktop
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		if (fc)
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating + " (FC)", iconRPC, true, songLength - Conductor.songPosition);
		else
			DiscordClient.changePresence(detailsText, SONG.song + storyDifficultyText + "| Score: " + songScore + " / Misses: " + misses + " / Accuracy: " + truncateFloat(accuracy, 2) + "% | " + rating, iconRPC, true, songLength - Conductor.songPosition);
		#end

		setOnLuas('songLength', songLength);
		setOnLuas('curStep', curStep);
		callOnLuas('stepHit', []);
	}

	var lastBeatHit:Int = -1;
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (lastBeatHit >= curBeat)
			return;

		if (generatedMusic)
			notes.sort(FlxSort.byY, (MythsListEngineData.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));

		var note = SONG.notes[Math.floor(curStep / 16)];

		if (note != null)
		{
			if (note.changeBPM)
			{
				Conductor.changeBPM(note.bpm);
				FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBPM', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}

			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
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

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP1.updateHitbox();
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
		iconP2.updateHitbox();

		if (iconP1.isAnimated) iconP1.updateIconState(true, true);
		if (iconP2.isAnimated) iconP2.updateIconState(true, false);

		if (curBeat % gfSpeed == 0 && gf != null && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith('sing') && !gf.stunned)
			gf.dance();
		
		if (curBeat % 2 == 0)
		{
			if (dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				dad.dance();

			if (boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith('sing') && (health > 0 || !boyfriend.stunned))
				boyfriend.dance();
		}
		else if (dad.hasDanceAnimations || boyfriend.hasDanceAnimations)
		{
			if (dad.hasDanceAnimations && dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				dad.dance();
			
			if (boyfriend.hasDanceAnimations && boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith('sing') && (health > 0 || !boyfriend.stunned))
				boyfriend.dance();
		}

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
						trainCooldown ++;

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

		setOnLuas('curBeat', curBeat);
		callOnLuas('beatHit', []);
	}

	public function getControl(key:String)
	{
		var pressed:Bool = Reflect.getProperty(controls, key);
		return pressed;
	}

	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic
	{
		var returnedValue:Dynamic = Modchart.Function_Continue;

		#if windows
		for (i in 0...modchartArray.length)
		{
			var ret:Dynamic = modchartArray[i].call(event, args);

			if (ret != Modchart.Function_Continue)
				returnedValue = ret;
		}
		#end

		return returnedValue;
	}

	public function setOnLuas(variable:String, arg:Dynamic)
	{
		#if windows
		for (i in 0...modchartArray.length)
		{
			modchartArray[i].set(variable, arg);
		}
		#end
	}
}