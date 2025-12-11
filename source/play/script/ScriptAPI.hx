package play.script;

import play.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;

class ScriptAPI {
    public static function bindLua(state:Dynamic, ps:PlayState) {
        // Expose camera
        state.cameraTween = (x,y,t)->ps.cameraManager.moveTo(x,y,t);
        state.cameraZoom  = (amt)->FlxG.camera.zoom += amt;

        // Characters
        state.playAnim = (id,anim)->ps.characterManager.playAnimOn(id,anim);

        // Notes
        state.setNoteSpeed = (spd)->ps.uiManager.scrollSpeed = spd;

        // Stage
        state.loadStage = (name)->ps.stageManager.loadStage(name);

        // HUD/UI
        state.shakeHUD = (amt,dur)->ps.uiManager.shake(amt,dur);

        // Print
        state.debugPrint = (msg)->trace("[LUA] " + msg);
    }

    public static function bindHScript(interp:Dynamic, ps:PlayState) {
        interp.variables.set("ps", ps);
        interp.variables.set("camera", ps.cameraManager);
        interp.variables.set("characters", ps.characterManager);
        interp.variables.set("notes", ps.noteManager);
        interp.variables.set("ui", ps.uiManager);
        interp.variables.set("stage", ps.stageManager);
        interp.variables.set("event", ps.eventManager);
        interp.variables.set("audio", backend.AudioController);

        interp.variables.set("print", (x)->trace("[HScript] " + x));
    }
}
