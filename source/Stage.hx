package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.effects.chainable.FlxWaveEffect;

class Stage extends StageSprite
{
	public static var background:FlxTypedGroup<StageSprite>;

	public function new(stage:String = 'stage')
	{
		super();

		var layerOrder:Array<StageSprite> = null;
		background = new FlxTypedGroup<StageSprite>();

		var pixelStage:Bool = false;

		switch(stage)
		{
			case 'stage':
			{
				var bg:StageSprite = new StageSprite('stageback', 'week1', -600, -200, 0.9, 0.9);

				var stageFront:StageSprite = new StageSprite('stagefront', 'week1', -650, 600, 0.9, 0.9);
				stageFront.newGraphicSize(1.1);

				var stageCurtains:StageSprite = new StageSprite('stagecurtains', 'week1', -500, -300, 1.3, 1.3);
				stageCurtains.newGraphicSize(0.9);

		        layerOrder = [bg, stageFront, stageCurtains];
			}
			case 'spooky':
			{
				var halloweenBG:StageSprite = new StageSprite('halloween_bg', 'week2', -200, -100, 1, 1, ['halloweem bg0', 'halloweem bg lightning strike'], false);
				halloweenBG.playAnim('halloweem bg0');

	            layerOrder = [halloweenBG];
			}
			case 'philly':
			{
				var bg:StageSprite = new StageSprite('philly/sky', 'week3', -100, 0, 0.1, 0.1);

				var city:StageSprite = new StageSprite('philly/city', 'week3', -10, 0, 0.3, 0.3);
				city.newGraphicSize(0.85);

				var lights:StageSprite = new StageSprite('philly/lights', 'week3', -10, 0, 0.3, 0.3);
				lights.newGraphicSize(0.85);
				lights.visible = false;

				var streetBehind:StageSprite = new StageSprite('philly/behindTrain', 'week3', -40, 50, 1, 1);
				var phillyTrain:StageSprite = new StageSprite('philly/train', 'week3', 2000, 360, 1, 1);
				var street:StageSprite = new StageSprite('philly/street', 'week3', -40, 50, 1, 1);

				PlayState.trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'shared'));

				layerOrder = [bg, city, lights, streetBehind, phillyTrain, street];
			}
			case 'limo':
			{
				var skyBG:StageSprite = new StageSprite('limo/limoSunset', 'week4', -120, -50, 0.1, 0.1);

				var bgLimo:StageSprite = new StageSprite('limo/bgLimo', 'week4', -200, 480, 0.4, 0.4, ['background limo pink'], true);
				bgLimo.playAnim('background limo pink');

				PlayState.grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, 80);
					dancer.scrollFactor.set(0.4, 0.4);
					PlayState.grpLimoDancers.add(dancer);
				}

		        PlayState.limo = new FlxSprite(-120, 550);
		        PlayState.limo.frames = Paths.getSparrowAtlas('limo/limoDrive', 'week4');
		        PlayState.limo.animation.addByPrefix('drive', 'Limo stage', 24);
		        PlayState.limo.animation.play('drive');
		        PlayState.limo.antialiasing = MythsListEngineData.antiAliasing;

		        PlayState.fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));

				layerOrder = [skyBG, bgLimo];
			}
			case 'mall':
			{
		        var bg:StageSprite = new StageSprite('christmas/bgWalls', 'week5', -1000, -500, 0.2, 0.2);
				bg.newGraphicSize(0.8);

				var upperBoppers:StageSprite = new StageSprite('christmas/upperBop', 'week5', -240, -90, 0.33, 0.33, ['Upper Crowd Bob'], false);
				upperBoppers.newGraphicSize(0.85);

				var bgEscalator:StageSprite = new StageSprite('christmas/bgEscalator', 'week5', -1100, -600, 0.3, 0.3);
				bgEscalator.newGraphicSize(0.9);

				var tree:StageSprite = new StageSprite('christmas/christmasTree', 'week5', 370, -250, 0.4, 0.4);
				var bottomBoppers:StageSprite = new StageSprite('christmas/bottomBop', 'week5', -300, 140, 0.9, 0.9, ['Bottom Level Boppers'], false);
				var fgSnow:StageSprite = new StageSprite('christmas/fgSnow', 'week5', -600, 700, 1, 1);
				var santa:StageSprite = new StageSprite('christmas/santa', 'week5', -840, 150, 1, 1, ['santa idle in fear'], false);

				layerOrder = [bg, upperBoppers, bgEscalator, tree, bottomBoppers, fgSnow, santa];
			}
			case 'mallEvil':
			{
				var bg:StageSprite = new StageSprite('christmas/evilBG', 'week5', -400, -500, 0.2, 0.2);
				bg.newGraphicSize(0.8);

				var evilTree:StageSprite = new StageSprite('christmas/evilTree', 'week5', 300, -300, 0.2, 0.2);
				var evilSnow:StageSprite = new StageSprite('christmas/evilSnow', 'week5', -200, 700, 1, 1);

				layerOrder = [bg, evilTree, evilSnow];
			}
			case 'school':
			{
				pixelStage = true;

				var bgSky:StageSprite = new StageSprite('weeb/weebSky', 'week6', 0, 0, 0.1, 0.1);
				bgSky.newGraphicSize(6);

				var bgSchool:StageSprite = new StageSprite('weeb/weebSchool', 'week6', -200, 0, 0.6, 0.9);
				bgSchool.newGraphicSize(6);

				var bgStreet:StageSprite = new StageSprite('weeb/weebStreet', 'week6', -200, 0, 0.95, 0.95);
				bgStreet.newGraphicSize(6);

				var fgTrees:StageSprite = new StageSprite('weeb/weebTreesBack', 'week6', -30, 130, 0.9, 0.9);
				fgTrees.setGraphicSize(Std.int(fgTrees.width * 6 * 0.8));
				fgTrees.updateHitbox();

				var bgTrees:StageSprite = new StageSprite('weeb/weebTrees', 'week6', 0, -950, 0.85, 0.85, ['treeLoop'], true);
				bgTrees.playAnim('treeLoop');
				bgTrees.animation.curAnim.frameRate = 12;
				bgTrees.newGraphicSize(6);
				bgTrees.screenCenter(X);

				var treeLeaves:StageSprite = new StageSprite('weeb/petals', 'week6', -200, -40, 0.85, 0.85, ['PETALS ALL'], true);
				treeLeaves.playAnim('PETALS ALL');
				treeLeaves.newGraphicSize(6);

				if (PlayState.SONG.song.toLowerCase() != 'thorns')
				{
		        	PlayState.bgGirls = new BackgroundGirls(-100, 190);
		        	PlayState.bgGirls.scrollFactor.set(0.9, 0.9);
					PlayState.bgGirls.antialiasing = false;

		        	if (PlayState.SONG.song.toLowerCase() == 'roses')
		            	PlayState.bgGirls.getScared();

		        	PlayState.bgGirls.setGraphicSize(Std.int(PlayState.bgGirls.width * 6));
		        	PlayState.bgGirls.updateHitbox();
				}

				layerOrder = [bgSky, bgSchool, bgStreet, fgTrees, bgTrees, treeLeaves];
			}
			case 'schoolEvil':
			{
				pixelStage = true;

				var waveEffectBG:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		        var waveEffectFG:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var bg:StageSprite = new StageSprite('weeb/animatedEvilSchool', 'week6', 420, 200, 0.8, 0.9, ['background 2'], true);
				bg.scale.set(6, 6);
				bg.playAnim('background 2');

				layerOrder = [bg];
			}
		}

		if (layerOrder != null)
			addObjects(layerOrder, pixelStage);
	}

	function addObjects(daLayerOrder:Array<StageSprite>, daPixelStage:Bool)
	{
		for (item in daLayerOrder)
		{
			if (Std.is(item, StageSprite))
			{
				if (daPixelStage)
					item.antialiasing = false;

				background.add(item);
			}
		}
	}
}