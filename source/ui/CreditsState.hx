package ui;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class CreditsState extends FlxState {
    override public function create() {
        super.create();

        var t = new FlxText(0, 60, FlxG.width,
            "HYBRID ENGINE\nCreated by: You\nPowered by Flixel + OpenFL\n3D Renderer Included\nSupports Mods & Scripts",
            28
        );
        t.alignment = "center";
        add(t);

        add(new FlxText(0, FlxG.height-50, FlxG.width, "Press ESC to go back", 16).setFormat(null,16,0xCCCCCC,"center"));
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MainMenuState());
    }
}
