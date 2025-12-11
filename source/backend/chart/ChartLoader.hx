package backend.chart;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import util.Paths;

class ChartLoader {

    // ======================================================================
    // PUBLIC: LOAD ANY FNF CHART FORMAT
    // ======================================================================

    public static function load(mod:String, song:String):ChartData {
        var chartPathPsych = Paths.chart(mod, song);
        var chartPathVSlice = Paths.vsliceChart(mod, song);
        var chartPathKade = Paths.kadeChart(mod, song);

        if (chartPathPsych != null && FileSystem.exists(chartPathPsych))
            return loadPsych(chartPathPsych);

        if (chartPathVSlice != null && FileSystem.exists(chartPathVSlice))
            return loadVSlice(chartPathVSlice);

        if (chartPathKade != null && FileSystem.exists(chartPathKade))
            return loadKade(chartPathKade);

        trace("[ChartLoader] No chart found for " + song + " in mod " + mod);
        return empty();
    }

    // ======================================================================
    // PSYCH ENGINE FORMAT
    // ======================================================================

    private static function loadPsych(path:String):ChartData {
        var raw = File.getContent(path);
        var json:Dynamic = Json.parse(raw);

        var song = json.song;
        var bpm:Float = song.bpm;
        var speed:Float = song.speed != null ? song.speed : 1.0;

        var out = new ChartData(bpm, speed);

        // NOTES
        for (section in song.notes) {
            var mustPress = section.mustHitSection == true;

            for (n in section.sectionNotes) {
                var time:Float = n[0];
                var lane:Int = Std.int(n[1]) % 4;
                var sustain:Float = n[2];
                var event:String = n.length > 3 ? n[3] : null;

                var note = new ChartNote(time, lane, sustain, mustPress);
                out.notes.push(note);

                if (event != null && event != "")
                    out.events.push(new ChartEvent(time, event, []));
            }
        }

        // EVENTS (V-Slice style inside Psych)
        if (Reflect.hasField(song, "events")) {
            for (ev in song.events) {
                var name:String = ev[0];
                var time:Float = ev[1];
                var params:Array<String> = ev[2];
                out.events.push(new ChartEvent(time, name, params));
            }
        }

        return out;
    }

    // ======================================================================
    // V-SLICE STYLE
    // ======================================================================

    private static function loadVSlice(path:String):ChartData {
        var json:Dynamic = Json.parse(File.getContent(path));

        var bpm:Float = json.bpm;
        var speed:Float = json.scrollSpeed;

        var out = new ChartData(bpm, speed);

        // Notes are time-based
        for (note in json.notes) {
            var time:Float = note.time;
            var lane:Int = note.lane;
            var sustain:Float = note.sustain;
            var mustPress:Bool = note.mustPress;

            out.notes.push(new ChartNote(time, lane, sustain, mustPress));
        }

        // Events
        for (ev in json.events) {
            var time:Float = ev.time;
            var name:String = ev.name;
            var params:Array<String> = ev.params;
            out.events.push(new ChartEvent(time, name, params));
        }

        return out;
    }

    // ======================================================================
    // KADE ENGINE STYLE
    // ======================================================================

    private static function loadKade(path:String):ChartData {
        var json:Dynamic = Json.parse(File.getContent(path));

        var bpm:Float = json.song.bpm;
        var speed:Float = json.song.speed != null ? json.song.speed : 1.0;

        var out = new ChartData(bpm, speed);

        for (section in json.song.notes) {
            var mustPress = section.mustHitSection == true;

            for (n in section.sectionNotes) {
                var time:Float = n[0];
                var lane:Int = Std.int(n[1]);
                var sustain:Float = n[2];

                var note = new ChartNote(time, lane, sustain, mustPress);
                out.notes.push(note);
            }
        }

        return out;
    }

    // ======================================================================
    // EMPTY CHART
    // ======================================================================

    public static function empty():ChartData {
        return new ChartData(120, 1.0); // default BPM 120, speed 1.0
    }
}
