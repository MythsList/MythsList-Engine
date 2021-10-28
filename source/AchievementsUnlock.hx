package;

import flixel.FlxG;

class AchievementsUnlock
{
    public static function fcAchievement()
    {
        if (MythsListEngineData.fcAmount >= 1)
            FlxG.save.data.dataAchievements[0][0] = true;
            
        if (MythsListEngineData.fcAmount >= 5)
            FlxG.save.data.dataAchievements[0][1] = true;
            
        if (MythsListEngineData.fcAmount >= 10)
            FlxG.save.data.dataAchievements[0][2] = true;
            
        if (MythsListEngineData.fcAmount >= 25)
            FlxG.save.data.dataAchievements[0][3] = true;
            
        if (MythsListEngineData.fcAmount >= 50)
            FlxG.save.data.dataAchievements[0][4] = true;
            
        FlxG.save.flush();
        MythsListEngineData.dataSave();
    }

    public static function playAchievement()
    {
		if (MythsListEngineData.playAmount >= 1)
            FlxG.save.data.dataAchievements[1][0] = true;
        
        if (MythsListEngineData.playAmount >= 10)
            FlxG.save.data.dataAchievements[1][1] = true;
        
        if (MythsListEngineData.playAmount >= 25)
            FlxG.save.data.dataAchievements[1][2] = true;
        
        if (MythsListEngineData.playAmount >= 50)
            FlxG.save.data.dataAchievements[1][3] = true;
        
        if (MythsListEngineData.playAmount >= 100)
            FlxG.save.data.dataAchievements[1][4] = true;
        
        FlxG.save.flush();
        MythsListEngineData.dataSave();
    }

    public static function deathAchievement()
    {
        if (MythsListEngineData.deathAmount >= 1)
            FlxG.save.data.dataAchievements[2][0] = true;

        if (MythsListEngineData.deathAmount >= 15)
            FlxG.save.data.dataAchievements[2][1] = true;

        if (MythsListEngineData.deathAmount >= 25)
            FlxG.save.data.dataAchievements[2][2] = true;

        if (MythsListEngineData.deathAmount >= 50)
            FlxG.save.data.dataAchievements[2][3] = true;

        if (MythsListEngineData.deathAmount >= 80)
            FlxG.save.data.dataAchievements[2][4] = true;

        FlxG.save.flush();
        MythsListEngineData.dataSave();
    }

    public static function scrollAchievement()
    {
        if (MythsListEngineData.playUpscroll)
            FlxG.save.data.dataAchievements[3][0] = true;

        if (MythsListEngineData.playDownscroll)
            FlxG.save.data.dataAchievements[3][1] = true;

        if (MythsListEngineData.playMiddlescroll)
            FlxG.save.data.dataAchievements[3][2] = true;

        if (MythsListEngineData.playUpMiddlescroll)
            FlxG.save.data.dataAchievements[3][3] = true;

        if (MythsListEngineData.playDownMiddlescroll)
            FlxG.save.data.dataAchievements[3][4] = true;

        FlxG.save.flush();
        MythsListEngineData.dataSave();
    }
}