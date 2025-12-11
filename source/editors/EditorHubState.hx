package editors;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxText;
import flixel.text.FlxTextAlign;
import flixel.ui.FlxButton;

class EditorHubState extends FlxState {
    override public function create() {
        super.create();
        
        var title = new FlxText(0, 40, FlxG.width, "HYBRID ENGINE — EDITOR HUB", 32);
        title.setFormat(null, 32, 0xFFFFFFFF, FlxTextAlign.CENTER);
        add(title);

        add(makeButton("CHART EDITOR", 150, ChartEditorState));
        add(makeButton("CHARACTER EDITOR", 250, CharacterEditorState));
        add(makeButton("STAGE EDITOR", 350, StageEditorState));
        add(makeButton("EVENT EDITOR", 450, EventEditorState));
    }

    function makeButton(text:String, y:Float, state:Class<FlxState>):FlxButton {
        return new FlxButton(FlxG.width/2 - 100, y, text, function() {
            FlxG.switchState(Type.createInstance(state, []));
        });
    }
}
