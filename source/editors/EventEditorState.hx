package editors;

import flixel.FlxState;
import editors.ui.EditorUI;
import backend.UnifiedEvent;

class EventEditorState extends FlxState {
    var events:Array<UnifiedEvent> = [];

    override public function create() {
        super.create();

        add(EditorUI.label(20,20,"EVENT EDITOR"));

        add(EditorUI.button(20,70,"ADD CAMERA ZOOM",addZoomEvent));
    }

    function addZoomEvent() {
        events.push({
            time: 1000,
            name: "add camera zoom",
            params: ["0.1","0.3"]
        });
    }
}
