package play;

import backend.events.*;
import backend.events.UnifiedEvent;

class EventManager {
    public var ps:PlayState;
    public var events:Array<UnifiedEvent>;

    public function new(ps:PlayState) {
        this.ps = ps;
        events = [];
    }

    public function load(e:Array<UnifiedEvent>) {
        events = e.copy();
    }

    public function update(songTime:Float) {
        while (events.length > 0 && songTime >= events[0].time) {
            var e = events.shift();
            dispatch(e);
        }
    }

    public function dispatch(e:UnifiedEvent) {
        var h = EventRegistry.get(e.name);
        
        if (h != null)
            h(ps, e.params);

        ps.scriptManager.callEvent(e.name, e.params);
    }
}
