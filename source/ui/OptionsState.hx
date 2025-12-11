package ui;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import backend.Settings;

class OptionsState extends FlxState {
    override public function create() {
        super.create();

        add(new FlxText(0, 40, FlxG.width, "OPTIONS", 36).setFormat(null,36,0xFFFFFF,"center"));

        add(new FlxButton(100, 160, "Downscroll: " + Settings.data.downscroll, toggleDownscroll));
        add(new FlxButton(100, 220, "Botplay: " + Settings.data.botplay, toggleBotplay));
        add(new FlxButton(100, 280, "Back", function() FlxG.switchState(new MainMenuState())));
    }

    function toggleDownscroll() {
        Settings.data.downscroll = !Settings.data.downscroll;
        Settings.save();
        FlxG.resetState();
    }

    function toggleBotplay() {
        Settings.data.botplay = !Settings.data.botplay;
        Settings.save();
        FlxG.resetState();
    }
}
