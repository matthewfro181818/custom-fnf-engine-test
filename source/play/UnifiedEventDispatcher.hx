package play;

import backend.UnifiedEvent;

class UnifiedEventDispatcher {
    public static function dispatch(ps:PlayState, ev:UnifiedEvent) {
        var name = ev.name.toLowerCase();

        //
        // 1. Psych Engine events
        //
        if (PsychEventMap.exists(name)) {
            PsychEventMap.run(ps, name, ev.params);
            return;
        }

        //
        // 2. V-Slice events
        //
        if (VSliceEventMap.exists(name)) {
            VSliceEventMap.run(ps, name, ev.params);
            return;
        }

        //
        // 3. Custom events via ScriptManager
        //
        if (ps.scriptManager.runEvent(name, ev.params))
            return;

        trace('[Event] Unknown event: ' + ev.name);
    }
}
