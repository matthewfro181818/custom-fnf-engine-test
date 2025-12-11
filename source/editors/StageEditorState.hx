package editors;

import flixel.FlxState;
import editors.ui.EditorUI;
import stages.Stage;

class StageEditorState extends FlxState {
    var stage:Stage;

    override public function create() {
        super.create();

        add(EditorUI.label(20,20,"STAGE EDITOR"));

        stage = new Stage("default");
        stage.instantiatePreview(this);
        add(stage);

        add(EditorUI.button(20,70,"ADD LAYER",addLayer));
        add(EditorUI.button(20,120,"SAVE",saveStage));
    }

    function addLayer() {
        stage.addLayer("mods/exampleMod/images/stages/default_bg.png");
    }

    function saveStage() {
        stage.saveJSON("mods/exampleMod/stages/default.json");
    }
}
