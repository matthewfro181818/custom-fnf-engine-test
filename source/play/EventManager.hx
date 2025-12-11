package play;

import backend.chart.ChartEvent;
import backend.Conductor;

class EventManager {
    public var ps:PlayState;

    private var events:Array<ChartEvent> = [];

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    // ================================================================
    // LOAD EVENTS FROM CHART
    // ================================================================

    public function load(eventList:Array<ChartEvent>) {
        events = eventList.copy();
    }

    // ================================================================
    // UPDATE (called every frame in PlayState.update)
    // ================================================================

    public function update() {
        if (events.length == 0) return;

        var time = Conductor.songPosition;

        while (events.length > 0 && events[0].time <= time) {
            var e = events.shift();
            trigger(e.name, e.params);
        }
    }

    // ================================================================
    // TRIGGER EVENT BY NAME
    // ================================================================

    public function trigger(name:String, params:Array<String>) {
        if (params == null) params = [];

        trace("[Event] Triggering: " + name + " | " + params);

        switch (name.toLowerCase()) {

            // ------------------------------------------------------------
            // CAMERA EVENTS
            // ------------------------------------------------------------
            case "camerazoom":
                var amt = Std.parseFloat(params[0]);
                var dur = Std.parseFloat(params[1]);
                ps.cameraManager.addZoom(amt, dur);

            case "camerafocus":
                ps.cameraManager.focusCharacter(params[0]);

            case "cameraoffset":
                var x = Std.parseFloat(params[0]);
                var y = Std.parseFloat(params[1]);
                ps.cameraManager.offset(x, y);

            case "cameratween":
                var tx = Std.parseFloat(params[0]);
                var ty = Std.parseFloat(params[1]);
                var t  = Std.parseFloat(params[2]);
                ps.cameraManager.tweenTo(tx, ty, t);

            // ------------------------------------------------------------
            // CHARACTER EVENTS
            // ------------------------------------------------------------
            case "playcharanim":
                var char = ps.characterManager.get(params[0]);
                if (char != null)
                    char.playAnim(params[1], true);

            case "setcharacter":
                ps.characterManager.changeCharacter(params[0], params[1]);

            // ------------------------------------------------------------
            // POST FX EVENTS
            // ------------------------------------------------------------
            case "vignette":
                ps.postFX.tweenVignette(Std.parseFloat(params[0]), Std.parseFloat(params[1]));

            case "bloom":
                ps.postFX.tweenBloom(Std.parseFloat(params[0]), Std.parseFloat(params[1]));

            case "chromatic":
                ps.postFX.tweenChromatic(Std.parseFloat(params[0]), Std.parseFloat(params[1]));

            case "togglecrt":
                ps.postFX.toggleCRT(params[0].toLowerCase() == "true");

            case "grayscale":
                ps.postFX.toggleGrayscale(params[0].toLowerCase() == "true");

            case "invert":
                ps.postFX.toggleInvert(params[0].toLowerCase() == "true");

            // ------------------------------------------------------------
            // HUD EVENTS
            // ------------------------------------------------------------
            case "hudalpha":
                ps.uiManager.tweenHUDAlpha(Std.parseFloat(params[0]), Std.parseFloat(params[1]));

            case "hudpulse":
                ps.uiManager.pulseHUD();

            // ------------------------------------------------------------
            // AUDIO EVENTS
            // ------------------------------------------------------------
            case "setsongposition":
                ps.audioManager.setPosition(Std.parseFloat(params[0]));

            case "pitch":
                ps.audioManager.setPitch(Std.parseFloat(params[0]));

            // ------------------------------------------------------------
            // LUA / HSCRIPT CUSTOM EVENTS
            // ------------------------------------------------------------
            default:
                ps.scriptManager.callEvent(name, params);
        }
    }

    // ================================================================
    // DIRECT TRIGGER FROM SCRIPTS OR CODE
    // ================================================================

    public function call(name:String, p1:String = "", p2:String = "", p3:String = "") {
        trigger(name, [p1, p2, p3]);
    }
}
