package ui;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MainMenuState extends FlxState {
    override public function create() {
        super.create();

        FlxG.sound.playMusic("assets/music/menuTheme.ogg", 0.8);

        add(new FlxText(0, 40, FlxG.width, "HYBRID ENGINE", 36).setFormat(null,36,0xFFFFFF,"center"));

        add(makeButton("STORY MODE", 150, function() FlxG.switchState(new StoryMenuState())));
        add(makeButton("FREEPLAY",   220, function() FlxG.switchState(new FreeplayState())));
        add(makeButton("OPTIONS",    290, function() FlxG.switchState(new OptionsState())));
        add(makeButton("CREDITS",    360, function() FlxG.switchState(new CreditsState())));
        add(makeButton("EXIT",       430, function() FlxG.game.close()));
    }

    function makeButton(text:String, y:Float, callback:Void->Void):FlxButton {
        return new FlxButton(FlxG.width/2 - 100, y, text, callback);
    }
}
