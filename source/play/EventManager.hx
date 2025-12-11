package play;

import backend.UnifiedEvent;
import backend.Conductor;
import flixel.FlxG;

class EventManager {
    public var ps:PlayState;
    public var events:Array<UnifiedEvent>;
    public var index:Int = 0;

    public function new(ps:PlayState) {
        this.ps = ps;
        events = [];
    }

    public function load(events:Array<UnifiedEvent>) {
        this.events = events;
        index = 0;
    }

    public function update(songPos:Float) {
        while (index < events.length && songPos >= events[index].time) {
            trigger(events[index]);
            index++;
        }
    }

    public function trigger(ev:UnifiedEvent) {
        UnifiedEventDispatcher.dispatch(ps, ev);
    }
}
