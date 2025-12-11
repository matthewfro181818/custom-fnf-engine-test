package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;
import openfl.Lib;
import states.SplashState;

class Main extends Sprite {
    public function new() {
        super();

        // Start the engine
        setupSave();
        setupGame();
    }

    // =====================================================================
    // SAVE INITIALIZATION
    // =====================================================================

    private function setupSave() {
        if (FlxG.save.data.downscroll == null)
            FlxG.save.data.downscroll = false;

        if (FlxG.save.data.volume == null)
            FlxG.save.data.volume = 1.0;

        if (FlxG.save.data.selectedMod == null)
            FlxG.save.data.selectedMod = "exampleMod";
    }

    // =====================================================================
    // CREATE GAME INSTANCE
    // =====================================================================

    private function setupGame() {
        var width = 1280;
        var height = 720;
        var zoom = 1;

        var framerate = 60;

        addChild(new FlxGame(width, height, SplashState, zoom, framerate, framerate, true));
    }
}
