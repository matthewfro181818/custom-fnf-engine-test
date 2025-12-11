package backend;

class EventParser {
    public static function parse(raw:Array<Dynamic>):Array<UnifiedEvent> {
        var arr:Array<UnifiedEvent> = [];

        for (ev in raw) {
            arr.push({
                time: ev.time,
                name: ev.name,
                params: ev.params
            });
        }

        return arr;
    }
}
