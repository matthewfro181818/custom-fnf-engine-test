public function runEvent(name:String, params:Array<String>):Bool {
    // Lua/HScript can override or add events
    var handled:Bool = false;

    for (script in scripts) {
        if (script.onEvent(name, params)) {
            handled = true;
        }
    }

    return handled;
}
