package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.effects.chainable.FlxWaveEffect;

class Stage extends FlxSprite
{
	public static var background:FlxTypedGroup<FlxSprite>;

	public function new(stage:String = 'stage', daAntialiasing:Bool = true)
	{
		super();

		background = new FlxTypedGroup<FlxSprite>();

		switch(stage)
		{
			case 'stage':
			{
				PlayState.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback', 'week1'));
		        bg.antialiasing = daAntialiasing;
		        bg.scrollFactor.set(0.9, 0.9);
		        bg.active = false;

		        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront', 'week1'));
		        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		        stageFront.updateHitbox();
		        stageFront.antialiasing = daAntialiasing;
		        stageFront.scrollFactor.set(0.9, 0.9);
		        stageFront.active = false;

		        var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains', 'week1'));
		        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		        stageCurtains.updateHitbox();
		        stageCurtains.antialiasing = daAntialiasing;
		        stageCurtains.scrollFactor.set(1.3, 1.3);
		        stageCurtains.active = false;

				background.add(bg);
				background.add(stageFront);
				background.add(stageCurtains);
			}
			case 'spooky':
			{
				var halloweenBG:FlxSprite = new FlxSprite(-200, -100);
				halloweenBG.frames = Paths.getSparrowAtlas('halloween_bg', 'week2');
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	            halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	            halloweenBG.animation.play('idle');
	            halloweenBG.antialiasing = daAntialiasing;

	            background.add(halloweenBG);
			}
			case 'philly':
			{
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
		        bg.scrollFactor.set(0.1, 0.1);

	            var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
		        city.scrollFactor.set(0.3, 0.3);
		        city.setGraphicSize(Std.int(city.width * 0.85));
		        city.updateHitbox();

				var lights:FlxSprite = new FlxSprite(city.x, 0).loadGraphic(Paths.image('philly/lights', 'week3'));
				lights.scrollFactor.set(0.3, 0.3);
		        lights.visible = false;
		        lights.setGraphicSize(Std.int(lights.width * 0.85));
		        lights.updateHitbox();
		        lights.antialiasing = daAntialiasing;

		        var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));

	            var phillyTrain:FlxSprite = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));

		        var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
	            
				background.add(bg);
		        background.add(city);
				background.add(lights);
				background.add(streetBehind);
				background.add(phillyTrain);
				background.add(street);
			}
			case 'limo':
			{
				PlayState.defaultCamZoom = 0.9;

		        var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
		        skyBG.scrollFactor.set(0.1, 0.1);

		        var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		        bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
		        bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
		        bgLimo.animation.play('drive');
		        bgLimo.scrollFactor.set(0.4, 0.4);

				background.add(skyBG);
				background.add(bgLimo);

				PlayState.grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					PlayState.grpLimoDancers.add(dancer);
				}

		        PlayState.limo = new FlxSprite(-120, 550);
		        PlayState.limo.frames = Paths.getSparrowAtlas('limo/limoDrive', 'week4');
		        PlayState.limo.animation.addByPrefix('drive', 'Limo stage', 24);
		        PlayState.limo.animation.play('drive');
		        PlayState.limo.antialiasing = daAntialiasing;

		        PlayState.fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
			}
			case 'mall':
			{
				PlayState.defaultCamZoom = 0.8;

		        var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
				bg.antialiasing = daAntialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();

		        var upperBoppers:FlxSprite = new FlxSprite(-240, -90);
		        upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
		        upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		        upperBoppers.antialiasing = daAntialiasing;
		        upperBoppers.scrollFactor.set(0.33, 0.33);
		        upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		        upperBoppers.updateHitbox();

		        var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
				bgEscalator.antialiasing = daAntialiasing;
		        bgEscalator.scrollFactor.set(0.3, 0.3);
		        bgEscalator.active = false;
		        bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		        bgEscalator.updateHitbox();

		        var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
				tree.antialiasing = daAntialiasing;
		        tree.scrollFactor.set(0.40, 0.40);

		        var bottomBoppers:FlxSprite = new FlxSprite(-300, 140);
		        bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
		        bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = daAntialiasing;
	            bottomBoppers.scrollFactor.set(0.9, 0.9);
	            bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		        bottomBoppers.updateHitbox();

		        var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
		        fgSnow.active = false;
				fgSnow.antialiasing = daAntialiasing;

		        var santa:FlxSprite = new FlxSprite(-840, 150);
		        santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
		        santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = daAntialiasing;

				background.add(bg);
				background.add(upperBoppers);
				background.add(bgEscalator);
				background.add(tree);
				background.add(bottomBoppers);
				background.add(fgSnow);
		        background.add(santa);
			}
			case 'mallEvil':
			{
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
				bg.antialiasing = daAntialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();

		        var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
				evilTree.antialiasing = daAntialiasing;
		        evilTree.scrollFactor.set(0.2, 0.2);

		        var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image('christmas/evilSnow', 'week5'));
				evilSnow.antialiasing = daAntialiasing;

				background.add(bg);
				background.add(evilTree);
		        background.add(evilSnow);
			}
			case 'school':
			{
				var bgSky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('weeb/weebSky', 'week6'));
		        bgSky.scrollFactor.set(0.1, 0.1);

		        var bgSchool:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
		        bgSchool.scrollFactor.set(0.6, 0.90);

		        var bgStreet:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
		        bgStreet.scrollFactor.set(0.95, 0.95);

		        var fgTrees:FlxSprite = new FlxSprite(-200 + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
		        fgTrees.scrollFactor.set(0.9, 0.9);

		        var bgTrees:FlxSprite = new FlxSprite(-200 - 380, -800);
		        bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
		        bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		        bgTrees.animation.play('treeLoop');
		        bgTrees.scrollFactor.set(0.85, 0.85);

		        var treeLeaves:FlxSprite = new FlxSprite(-200, -40);
		        treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
		        treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		        treeLeaves.animation.play('leaves');
		        treeLeaves.scrollFactor.set(0.85, 0.85);

		        bgSky.setGraphicSize(Std.int(bgSky.width * 6));
		        bgSchool.setGraphicSize(Std.int(bgSky.width * 6));
		        bgStreet.setGraphicSize(Std.int(bgSky.width * 6));
		        bgTrees.setGraphicSize(Std.int(bgSky.width * 6 * 1.4));
		        fgTrees.setGraphicSize(Std.int(bgSky.width * 6 * 0.8));
		        treeLeaves.setGraphicSize(Std.int(bgSky.width * 6));

		        fgTrees.updateHitbox();
		        bgSky.updateHitbox();
		        bgSchool.updateHitbox();
		        bgStreet.updateHitbox();
		        bgTrees.updateHitbox();
		        treeLeaves.updateHitbox();

				background.add(bgSky);
				background.add(bgSchool);
				background.add(bgStreet);
				background.add(fgTrees);
				background.add(bgTrees);
				background.add(treeLeaves);
			}
			case 'schoolEvil':
			{
				var waveEffectBG:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		        var waveEffectFG:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		        var bg:FlxSprite = new FlxSprite(420, 200);
		        bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
		        bg.animation.addByPrefix('idle', 'background 2', 24);
		        bg.animation.play('idle');
		        bg.scrollFactor.set(0.8, 0.9);
		        bg.scale.set(6, 6);

		        background.add(bg);
			}
		}
	}
}