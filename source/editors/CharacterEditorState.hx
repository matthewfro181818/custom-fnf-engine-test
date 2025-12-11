package editors;

import flixel.FlxState;
import objects.Character;
import editors.ui.EditorUI;

class CharacterEditorState extends FlxState {
    var character:Character;

    override public function create() {
        super.create();

        add(EditorUI.label(20,20,"CHARACTER EDITOR"));

        character = new Character("bf");
        add(character);

        add(EditorUI.button(20,70,"PLAY IDLE",function(){ character.playAnim("idle"); }));
        add(EditorUI.button(20,120,"PLAY LEFT",function(){ character.playAnim("singLEFT"); }));

        add(EditorUI.button(20,170,"SAVE JSON",saveJson));
    }

    function saveJson() {
        character.saveToJSON("mods/exampleMod/characters/bf.json");
    }
}
