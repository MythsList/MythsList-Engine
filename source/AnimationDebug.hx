package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;

	var textAnim:FlxText;

	var redgridBG:FlxSprite;

	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];

	var curAnim:Int = 0;

	var isDad:Bool = true;

	var daAnim:String = 'bf';

	var camFollow:FlxObject;

	public function new(daAnim:String = 'bf')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		#if desktop
			DiscordClient.changePresence("In The Animation Debug Menu", null);
		#end

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set();
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad == true)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.scrollFactor.set();
			dad.debugMode = true;

			redgridBG = new FlxSprite(0, 0).makeGraphic(dad.frameWidth, dad.frameHeight, FlxColor.RED);
			redgridBG.alpha = 0.25;
			redgridBG.scrollFactor.set();
			add(redgridBG);

			add(dad);

			dad.updateHitbox();

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0, daAnim);
			bf.screenCenter();
			bf.scrollFactor.set();
			bf.debugMode = true;

			redgridBG = new FlxSprite(0, 0).makeGraphic(bf.frameWidth, bf.frameHeight, FlxColor.RED);
			redgridBG.alpha = 0.25;
			redgridBG.scrollFactor.set();
			add(redgridBG);

			add(bf);

			bf.updateHitbox();

			char = bf;
			bf.flipX = false;
		}

		redgridBG.screenCenter(XY);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(0, 15);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		textAnim.x = FlxG.width - (textAnim.width + 15);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ' : ' + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;
		textAnim.x = FlxG.width - (textAnim.width + 15);

		switch(char.animation.curAnim.name.toLowerCase())
		{
			case 'danceleft' | 'danceright' | 'idle':
			{
				if (isDad)
				{
					redgridBG.x = (dad.getGraphicMidpoint().x) - (redgridBG.width / 2);
					redgridBG.y = (dad.getGraphicMidpoint().y) - (redgridBG.height / 2);
				}
				else
				{
					redgridBG.x = (bf.getGraphicMidpoint().x) - (redgridBG.width / 2);
					redgridBG.y = (bf.getGraphicMidpoint().y) - (redgridBG.height / 2);
				}
			}
		}

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;

		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		var camControlArray:Array<Bool> = [FlxG.keys.pressed.I, FlxG.keys.pressed.J, FlxG.keys.pressed.K, FlxG.keys.pressed.L];

		if (camControlArray.contains(true))
		{
			if (camControlArray[0])
				camFollow.velocity.y = -90;
			else if (camControlArray[2])
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (camControlArray[1])
				camFollow.velocity.x = -90;
			else if (camControlArray[3])
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
			camFollow.velocity.set();

		if (FlxG.keys.justPressed.W)
			curAnim --;

		if (FlxG.keys.justPressed.S)
			curAnim ++;

		if (curAnim < 0)
			curAnim = animList.length - 1;
		else if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var offsetControlArray:Array<Bool> = [
			FlxG.keys.anyJustPressed([UP]),
			FlxG.keys.anyJustPressed([RIGHT]),
			FlxG.keys.anyJustPressed([DOWN]),
			FlxG.keys.anyJustPressed([LEFT])
		];

		var multiplier:Int = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiplier = 10;

		if (offsetControlArray.contains(true))
		{
			updateTexts();

			if (offsetControlArray[0])
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;

			if (offsetControlArray[2])
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;

			if (offsetControlArray[3])
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;

			if (offsetControlArray[1])
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();

			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}
}
