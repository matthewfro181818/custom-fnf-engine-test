package backend;

class ChartLoader {
    public static function load(path:String):UnifiedChart {
        var raw = haxe.Json.parse(sys.io.File.getContent(path));

        if (raw.chart != null)
            return UnifiedChartParser.fromUnified(raw);

        if (raw.song != null && raw.song.notes != null)
            return PsychChartParser.fromPsych(raw.song);

        if (raw.hasOwnProperty("Actors"))
            return VSliceChartParser.fromVSlice(raw);

        throw "Unknown chart format: " + path;
    }
}
