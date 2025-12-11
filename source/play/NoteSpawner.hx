package play;

import objects.notes.Note;
import backend.UnifiedChart;

class NoteSpawner {
    public static function generate(chart:UnifiedChart):Array<Note> {
        var arr:Array<Note> = [];

        for (n in chart.notes) {
            var mustPress = (n.lane < 4);

            var note = new Note(
                n.time,
                n.lane,
                n.sustain,
                n.type,
                mustPress
            );

            arr.push(note);
        }

        // sort by strum time
        arr.sort((a, b) -> Reflect.compare(a.strumTime, b.strumTime));

        return arr;
    }
}
