package;

import flixel.FlxGame;
import openfl.display.Sprite;
import backend.Settings;
import backend.ModLoader;

class Main extends Sprite {
    public function new() {
        super();

        // Load global settings
        Settings.load();

        // Scan mods folder
        ModLoader.scanMods();

        // Start engine with IntroState (or TitleState)
        addChild(new FlxGame(1280, 720, IntroState, 60, 60, true, false));
    }

    // For HTML5
    public static function main() {
        #if html5
        new Main();
        #end
    }
}
