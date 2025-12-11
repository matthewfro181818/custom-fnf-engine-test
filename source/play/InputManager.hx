package play;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

class InputManager {
    public var ps:PlayState;

    // Keybind map: lane → array of keys
    public var binds:Map<Int, Array<FlxKey>>;

    // Gamepad binds
    public var padBinds:Map<Int, Array<FlxGamepadInputID>>;

    // Cached state
    private var keysDown:Array<Bool> = [];
    private var keysJust:Array<Bool> = [];

    public function new(ps:PlayState) {
        this.ps = ps;
        setupDefaultBinds();
    }

    // ======================================================================
    // DEFAULT BINDS
    // ======================================================================

    private function setupDefaultBinds() {
        binds = [
            0 => [FlxKey.A, FlxKey.LEFT, FlxKey.D],     // left
            1 => [FlxKey.S, FlxKey.DOWN, FlxKey.F],     // down
            2 => [FlxKey.W, FlxKey.UP, FlxKey.J],       // up
            3 => [FlxKey.K, FlxKey.RIGHT, FlxKey.L]     // right
        ];

        padBinds = [
            0 => [FlxGamepadInputID.DPAD_LEFT, FlxGamepadInputID.X],
            1 => [FlxGamepadInputID.DPAD_DOWN, FlxGamepadInputID.A],
            2 => [FlxGamepadInputID.DPAD_UP,   FlxGamepadInputID.Y],
            3 => [FlxGamepadInputID.DPAD_RIGHT,FlxGamepadInputID.B]
        ];

        // Initialize cache
        for (i in 0...4) {
            keysDown[i] = false;
            keysJust[i] = false;
        }
    }

    // ======================================================================
    // UPDATE (called by PlayState)
    // ======================================================================

    public function update() {
        for (lane in 0...4) {
            keysDown[lane] = checkLane(lane, false);
            keysJust[lane] = checkLane(lane, true);
        }
    }

    // ======================================================================
    // CHECK INPUT
    // ======================================================================

    // If justPress = true → look for “just pressed”
    // Otherwise → look for “held down”
    private function checkLane(lane:Int, justPress:Bool):Bool {
        // Keyboard checks
        for (key in binds[lane]) {
            if (justPress && FlxG.keys.checkStatus(key, JUST_PRESSED)) return true;
            if (!justPress && FlxG.keys.checkStatus(key, PRESSED)) return true;
        }

        // Gamepad checks (any connected pad)
        var pads = FlxG.gamepads.getActiveGamepads();
        for (pad in pads) {
            for (btn in padBinds[lane]) {
                if (justPress && pad.justPressed(btn)) return true;
                if (!justPress && pad.pressed(btn)) return true;
            }
        }

        // Touch input (optional future expansion)
        return false;
    }

    // ======================================================================
    // API — USED BY NoteManager
    // ======================================================================

    public function laneHeld(lane:Int):Bool {
        return keysDown[lane];
    }

    public function laneJustPressed(lane:Int):Bool {
        return keysJust[lane];
    }

    // ======================================================================
    // REMAPPING API
    // ======================================================================

    public function remapKey(lane:Int, oldKey:FlxKey, newKey:FlxKey) {
        if (binds[lane].contains(oldKey)) {
            binds[lane].remove(oldKey);
            binds[lane].push(newKey);
        }
    }

    public function setLaneKeys(lane:Int, keys:Array<FlxKey>) {
        binds[lane] = keys.copy();
    }

    public function setGamepadLane(lane:Int, buttons:Array<FlxGamepadInputID>) {
        padBinds[lane] = buttons.copy();
    }

    // ======================================================================
    // SCRIPT API HOOKS
    // ======================================================================

    public function isDown(dir:String):Bool {
        return laneHeld(nameToLane(dir));
    }

    public function isPressed(dir:String):Bool {
        return laneJustPressed(nameToLane(dir));
    }

    private function nameToLane(dir:String):Int {
        switch (dir.toLowerCase()) {
            case "left": return 0;
            case "down": return 1;
            case "up":   return 2;
            case "right":return 3;
        }
        return 0;
    }
}
