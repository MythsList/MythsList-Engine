package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class MythsListEngineData
{
    // VERSION

    public static var engineVersion:String = "V.1 - WIP BUILD";
    public static var modVersion:String = "V.1 - DEMO";

    // KEYBINDS

    public static var keyBinds:String;

    // FPS

    public static var fpsCap:Int;

    // GAMEPLAY

    public static var downScroll:Bool;
    public static var middleScroll:Bool;
    public static var statsDisplay:Bool;
    public static var songinfosDisplay:Bool;
    public static var versionDisplay:Bool;

    // CHARACTER SELECTION

    public static var characterSkin:String;

    // ACHIEVEMENTS

    public static var dataCategoryOne:Array<Bool>;
    public static var dataCategoryTwo:Array<Bool>;
    public static var dataCategoryThree:Array<Bool>;
	public static var dataCategoryFour:Array<Bool>;

    // ACHIEVEMENTS PROGRESS

    public static var fcAmount:Int;
    public static var playAmount:Int;
    public static var deathAmount:Int;
	public static var playUpscroll:Bool;
	public static var playDownscroll:Bool;
	public static var playMiddlescroll:Bool;

    static public function dataLoad():Void
    {
        if (FlxG.save.data.keyBinds == null)
			FlxG.save.data.keyBinds = 'SDKL';

		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.statsDisplay == null)
			FlxG.save.data.statsDisplay = true;
		if (FlxG.save.data.songinfosDisplay == null)
			FlxG.save.data.songinfosDisplay = true;
		if (FlxG.save.data.versionDisplay == null)
			FlxG.save.data.versionDisplay = true;

		if (FlxG.save.data.characterSkin == null)
			FlxG.save.data.characterSkin = 'bf';

		if (FlxG.save.data.dataCategoryOne == null)
			FlxG.save.data.dataCategoryOne = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryTwo == null)
			FlxG.save.data.dataCategoryTwo = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree == null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree == null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryFour == null)
			FlxG.save.data.dataCategoryFour = [false, false, false, false, false];

		if (FlxG.save.data.fcAmount == null)
			FlxG.save.data.fcAmount = 0;
		if (FlxG.save.data.playAmount == null)
			FlxG.save.data.playAmount = 0;
		if (FlxG.save.data.deathAmount == null)
			FlxG.save.data.deathAmount = 0;
		if (FlxG.save.data.playUpscroll == null)
			FlxG.save.data.playUpscroll = false;
		if (FlxG.save.data.playDownscroll == null)
			FlxG.save.data.playDownscroll = false;
		if (FlxG.save.data.playMiddlescroll == null)
			FlxG.save.data.playMiddlescroll = false;

		MythsListEngineData.keyBinds = FlxG.save.data.keyBinds;

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataCategoryOne = FlxG.save.data.dataCategoryOne;
		MythsListEngineData.dataCategoryTwo = FlxG.save.data.dataCategoryTwo;
		MythsListEngineData.dataCategoryThree = FlxG.save.data.dataCategoryThree;
		MythsListEngineData.dataCategoryFour = FlxG.save.data.dataCategoryFour;

		MythsListEngineData.fcAmount = FlxG.save.data.fcAmount;
		MythsListEngineData.playAmount = FlxG.save.data.playAmount;
		MythsListEngineData.deathAmount = FlxG.save.data.deathAmount;
		MythsListEngineData.playUpscroll = FlxG.save.data.playUpscroll;
		MythsListEngineData.playDownscroll = FlxG.save.data.playDownscroll;
		MythsListEngineData.playMiddlescroll = FlxG.save.data.playMiddlescroll;

		FlxG.save.flush();
    }

    static public function dataSave():Void
    {
        MythsListEngineData.keyBinds = FlxG.save.data.keyBinds;

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataCategoryOne = FlxG.save.data.dataCategoryOne;
		MythsListEngineData.dataCategoryTwo = FlxG.save.data.dataCategoryTwo;
		MythsListEngineData.dataCategoryThree = FlxG.save.data.dataCategoryThree;
		MythsListEngineData.dataCategoryFour = FlxG.save.data.dataCategoryFour;

		MythsListEngineData.fcAmount = FlxG.save.data.fcAmount;
		MythsListEngineData.playAmount = FlxG.save.data.playAmount;
		MythsListEngineData.deathAmount = FlxG.save.data.deathAmount;
		MythsListEngineData.playUpscroll = FlxG.save.data.playUpscroll;
		MythsListEngineData.playDownscroll = FlxG.save.data.playDownscroll;
		MythsListEngineData.playMiddlescroll = FlxG.save.data.playMiddlescroll;
    }

    static public function dataReset():Void
    {
        if (FlxG.save.data.keyBinds != null)
			FlxG.save.data.keyBinds = 'SDKL';

		if (FlxG.save.data.middleScroll != null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.middleScroll != null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.statsDisplay != null)
			FlxG.save.data.statsDisplay = true;
		if (FlxG.save.data.songinfosDisplay != null)
			FlxG.save.data.songinfosDisplay = true;
		if (FlxG.save.data.versionDisplay != null)
			FlxG.save.data.versionDisplay = true;

		if (FlxG.save.data.characterSkin != null)
			FlxG.save.data.characterSkin = 'bf';

		if (FlxG.save.data.dataCategoryOne != null)
			FlxG.save.data.dataCategoryOne = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryTwo != null)
			FlxG.save.data.dataCategoryTwo = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree != null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryThree != null)
			FlxG.save.data.dataCategoryThree = [false, false, false, false, false];
		if (FlxG.save.data.dataCategoryFour != null)
			FlxG.save.data.dataCategoryFour = [false, false, false, false, false];

		if (FlxG.save.data.fcAmount != null)
			FlxG.save.data.fcAmount = 0;
		if (FlxG.save.data.playAmount != null)
			FlxG.save.data.playAmount = 0;
		if (FlxG.save.data.deathAmount != null)
			FlxG.save.data.deathAmount = 0;
		if (FlxG.save.data.playUpscroll != null)
			FlxG.save.data.playUpscroll = false;
		if (FlxG.save.data.playDownscroll != null)
			FlxG.save.data.playDownscroll = false;
		if (FlxG.save.data.playMiddlescroll != null)
			FlxG.save.data.playMiddlescroll = false;

		MythsListEngineData.keyBinds = FlxG.save.data.keyBinds;

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataCategoryOne = FlxG.save.data.dataCategoryOne;
		MythsListEngineData.dataCategoryTwo = FlxG.save.data.dataCategoryTwo;
		MythsListEngineData.dataCategoryThree = FlxG.save.data.dataCategoryThree;
		MythsListEngineData.dataCategoryFour = FlxG.save.data.dataCategoryFour;

		MythsListEngineData.fcAmount = FlxG.save.data.fcAmount;
		MythsListEngineData.playAmount = FlxG.save.data.playAmount;
		MythsListEngineData.deathAmount = FlxG.save.data.deathAmount;
		MythsListEngineData.playUpscroll = FlxG.save.data.playUpscroll;
		MythsListEngineData.playDownscroll = FlxG.save.data.playDownscroll;
		MythsListEngineData.playMiddlescroll = FlxG.save.data.playMiddlescroll;

        FlxG.save.flush();
    }
}