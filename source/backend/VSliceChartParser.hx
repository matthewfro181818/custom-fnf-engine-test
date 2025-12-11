package backend;

class VSliceChartParser {
    public static function fromVSlice(raw:Dynamic):UnifiedChart {
        var chart:UnifiedChart = {
            notes: [],
            events: []
        };

        for (n in raw.Notes) {
            chart.notes.push({
                time: n.Time,
                lane: n.Lane,
                sustain: n.Length,
                type: n.Type
            });
        }

        for (ev in raw.Events) {
            chart.events.push({
                time: ev.Time,
                name: ev.Event,
                params: ev.Params
            });
        }

        return chart;
    }
}
