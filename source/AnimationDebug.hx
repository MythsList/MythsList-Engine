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
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

class AnimationDebug extends FlxState
{
	var _file:FileReference;

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

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('breakfast', 'shared'), 0.4);

		#if desktop
			DiscordClient.changePresence("In The Animation Debug Menu", null);
		#end

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set();
		add(gridBG);

		if (CharacterSelectionSubState.icons.contains(daAnim))
			isDad = false;

		if (isDad == true)
		{
			dad = new Character(0, 0, daAnim);
			dad.updateHitbox();
			dad.screenCenter(XY);
			dad.scrollFactor.set(1, 1);
			dad.debugMode = true;

			redgridBG = new FlxSprite(0, 0).makeGraphic(Std.int(dad.width), Std.int(dad.height), FlxColor.RED);
			redgridBG.alpha = 0.25;
			redgridBG.scrollFactor.set(1, 1);
			add(redgridBG);

			add(dad);

			char = dad;
		}
		else
		{
			bf = new Boyfriend(0, 0, daAnim);
			bf.updateHitbox();
			bf.screenCenter(XY);
			bf.scrollFactor.set(1, 1);
			bf.debugMode = true;

			redgridBG = new FlxSprite(0, 0).makeGraphic(Std.int(bf.width), Std.int(bf.height), FlxColor.RED);
			redgridBG.alpha = 0.25;
			redgridBG.scrollFactor.set(1, 1);
			add(redgridBG);

			add(bf);

			char = bf;
		}

		redgridBG.screenCenter(XY);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(0, 10, 0, 'PlaceHolder', 32);
		textAnim.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textAnim.scrollFactor.set();
		textAnim.antialiasing = true;
		add(textAnim);

		textAnim.x = FlxG.width - (textAnim.width + 10);

		var noteText:FlxText = new FlxText(0, 0, 0, 'Press ENTER or ALT to save offsets', 26);
		noteText.scrollFactor.set();
		noteText.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noteText.antialiasing = true;
		add(noteText);

		noteText.x = FlxG.width - noteText.width - 5;
		noteText.y = FlxG.height - noteText.height - 5;

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
			var text:FlxText = new FlxText(10, 10 + (28 * daLoop), 0, anim + ' : ' + offsets, 26);
			text.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.BLUE, LEFT);
			text.scrollFactor.set();
			text.antialiasing = true;
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
				camFollow.velocity.y = 90;
			else if (camControlArray[2])
				camFollow.velocity.y = -90;
			else
				camFollow.velocity.y = 0;

			if (camControlArray[1])
				camFollow.velocity.x = 90;
			else if (camControlArray[3])
				camFollow.velocity.x = -90;
			else
				camFollow.velocity.x = 0;
		}
		else
			camFollow.velocity.set(0, 0);

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
				char.animOffsets.get(animList[curAnim])[1] += multiplier;
			else if (offsetControlArray[2])
				char.animOffsets.get(animList[curAnim])[1] -= multiplier;
			else if (offsetControlArray[3])
				char.animOffsets.get(animList[curAnim])[0] += multiplier;
			else if (offsetControlArray[1])
				char.animOffsets.get(animList[curAnim])[0] -= multiplier;

			updateTexts();

			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ALT)
			generateOffsetsFile();

		super.update(elapsed);
	}

	private function generateOffsetsFile()
	{
		var fileData:String = '';

		for (anim => offsets in char.animOffsets)
		{
			fileData += anim + ' ' + offsets[0] + ' ' + offsets[1] + '\n';
		}

		if (fileData.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(fileData, daAnim + 'Offsets.txt');
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved the file.");
	}
	
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("File encountered an error during the saving process!");
	}
}
