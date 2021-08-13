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

    // ACHIEVEMENTS PROGRESS

    public static var fcAmount:Int;
    public static var playAmount:Int;
    public static var deathAmount:Int;
}