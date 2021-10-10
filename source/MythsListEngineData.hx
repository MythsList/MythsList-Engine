package;

import flixel.FlxG;

class MythsListEngineData
{
    // VERSION

    public static var engineVersion:String = 'V.1.1.0';
    public static var modVersion:String = '';

    // KEYBINDS

    public static var keyBinds:Array<String>;

    // FPS

    public static var fpsCap:Int;

    // GAMEPLAY

    public static var downScroll:Bool;
    public static var middleScroll:Bool;
	public static var ghostTapping:Bool;
	public static var inputsCounter:Bool;
    public static var statsDisplay:Bool;
    public static var songinfosDisplay:Bool;
    public static var versionDisplay:Bool;
	public static var songpositionDisplay:Bool;
	public static var botPlay:Bool;

	// PERFORMANCE

	public static var antiAliasing:Bool;
	public static var backgroundDisplay:Bool;

    // CHARACTER SELECTION

    public static var characterSkin:String;

    // ACHIEVEMENTS

    public static var dataAchievements:Array<Array<Bool>>;

    // ACHIEVEMENTS PROGRESS

    public static var fcAmount:Int;
    public static var playAmount:Int;
    public static var deathAmount:Int;
	public static var playUpscroll:Bool;
	public static var playDownscroll:Bool;
	public static var playMiddlescroll:Bool;

	// FUNCTIONS

    static public function dataLoad():Void
    {
        if (FlxG.save.data.keyBinds == null)
			FlxG.save.data.keyBinds = ['A', 'S', 'W', 'D', 'R', 'P'];

		for (i in 0...Std.int(FlxG.save.data.keyBinds.length - 1))
		{
			if (FlxG.save.data.keyBinds[i] == null)
			{
				FlxG.save.data.keyBinds = ['A', 'S', 'W', 'D', 'R', 'P'];
				FlxG.save.flush();
			}
		}

		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.ghostTapping == null)
			FlxG.save.data.ghostTapping = false;
		if (FlxG.save.data.inputsCounter == null)
			FlxG.save.data.inputsCounter = false;
		if (FlxG.save.data.statsDisplay == null)
			FlxG.save.data.statsDisplay = true;
		if (FlxG.save.data.songinfosDisplay == null)
			FlxG.save.data.songinfosDisplay = true;
		if (FlxG.save.data.versionDisplay == null)
			FlxG.save.data.versionDisplay = true;
		if (FlxG.save.data.songpositionDisplay == null)
			FlxG.save.data.songpositionDisplay = false;
		if (FlxG.save.data.botPlay == null)
			FlxG.save.data.botPlay = false;

		if (FlxG.save.data.antiAliasing == null)
			FlxG.save.data.antiAliasing = true;
		if (FlxG.save.data.backgroundDisplay == null)
			FlxG.save.data.backgroundDisplay = true;

		if (FlxG.save.data.characterSkin == null)
			FlxG.save.data.characterSkin = 'bf';

		if (FlxG.save.data.dataAchievements == null)
		{
			FlxG.save.data.dataAchievements = [
				[false, false, false, false, false],
				[false, false, false, false, false],
				[false, false, false, false, false],
				[false, false, false],
			];
		}

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

		MythsListEngineData.keyBinds = [
			FlxG.save.data.keyBinds[0],
			FlxG.save.data.keyBinds[1],
			FlxG.save.data.keyBinds[2],
			FlxG.save.data.keyBinds[3],
			FlxG.save.data.keyBinds[4],
			FlxG.save.data.keyBinds[5],
		];

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.ghostTapping = FlxG.save.data.ghostTapping;
		MythsListEngineData.inputsCounter = FlxG.save.data.inputsCounter;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;
		MythsListEngineData.songpositionDisplay = FlxG.save.data.songpositionDisplay;
		MythsListEngineData.botPlay = FlxG.save.data.botPlay;

		MythsListEngineData.antiAliasing = FlxG.save.data.antiAliasing;
		MythsListEngineData.backgroundDisplay = FlxG.save.data.backgroundDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataAchievements = FlxG.save.data.dataAchievements;

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
		MythsListEngineData.ghostTapping = FlxG.save.data.ghostTapping;
		MythsListEngineData.inputsCounter = FlxG.save.data.inputsCounter;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;
		MythsListEngineData.songpositionDisplay = FlxG.save.data.songpositionDisplay;
		MythsListEngineData.botPlay = FlxG.save.data.botPlay;

		MythsListEngineData.antiAliasing = FlxG.save.data.antiAliasing;
		MythsListEngineData.backgroundDisplay = FlxG.save.data.backgroundDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataAchievements = FlxG.save.data.dataAchievements;

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
			FlxG.save.data.keyBinds = ['A', 'S', 'W', 'D', 'R', 'P'];

		if (FlxG.save.data.middleScroll != null)
			FlxG.save.data.downScroll = false;
		if (FlxG.save.data.middleScroll != null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.ghostTapping != null)
			FlxG.save.data.ghostTapping = false;
		if (FlxG.save.data.inputsCounter != null)
			FlxG.save.data.inputsCounter = false;
		if (FlxG.save.data.statsDisplay != null)
			FlxG.save.data.statsDisplay = true;
		if (FlxG.save.data.songinfosDisplay != null)
			FlxG.save.data.songinfosDisplay = true;
		if (FlxG.save.data.versionDisplay != null)
			FlxG.save.data.versionDisplay = true;
		if (FlxG.save.data.songpositionDisplay != null)
			FlxG.save.data.songpositionDisplay = false;
		if (FlxG.save.data.botPlay != null)
			FlxG.save.data.botPlay = false;

		if (FlxG.save.data.antiAliasing != null)
			FlxG.save.data.antiAliasing = true;
		if (FlxG.save.data.backgroundDisplay != null)
			FlxG.save.data.backgroundDisplay = true;

		if (FlxG.save.data.characterSkin != null)
			FlxG.save.data.characterSkin = 'bf';

		if (FlxG.save.data.dataAchievements != null)
		{
			FlxG.save.data.dataAchievements = [
				[false, false, false, false, false],
				[false, false, false, false, false],
				[false, false, false, false, false],
				[false, false, false],
			];
		}

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

		MythsListEngineData.keyBinds = [
			FlxG.save.data.keyBinds[0],
			FlxG.save.data.keyBinds[1],
			FlxG.save.data.keyBinds[2],
			FlxG.save.data.keyBinds[3],
			FlxG.save.data.keyBinds[4],
			FlxG.save.data.keyBinds[5],
		];

		MythsListEngineData.downScroll = FlxG.save.data.downScroll;
		MythsListEngineData.middleScroll = FlxG.save.data.middleScroll;
		MythsListEngineData.ghostTapping = FlxG.save.data.ghostTapping;
		MythsListEngineData.inputsCounter = FlxG.save.data.inputsCounter;
		MythsListEngineData.statsDisplay = FlxG.save.data.statsDisplay;
		MythsListEngineData.songinfosDisplay = FlxG.save.data.songinfosDisplay;
		MythsListEngineData.versionDisplay = FlxG.save.data.versionDisplay;
		MythsListEngineData.songpositionDisplay = FlxG.save.data.songpositionDisplay;
		MythsListEngineData.botPlay = FlxG.save.data.botPlay;

		MythsListEngineData.antiAliasing = FlxG.save.data.antiAliasing;
		MythsListEngineData.backgroundDisplay = FlxG.save.data.backgroundDisplay;

		MythsListEngineData.characterSkin = FlxG.save.data.characterSkin;

		MythsListEngineData.dataAchievements = FlxG.save.data.dataAchievements;

		MythsListEngineData.fcAmount = FlxG.save.data.fcAmount;
		MythsListEngineData.playAmount = FlxG.save.data.playAmount;
		MythsListEngineData.deathAmount = FlxG.save.data.deathAmount;
		MythsListEngineData.playUpscroll = FlxG.save.data.playUpscroll;
		MythsListEngineData.playDownscroll = FlxG.save.data.playDownscroll;
		MythsListEngineData.playMiddlescroll = FlxG.save.data.playMiddlescroll;

        FlxG.save.flush();
    }
}