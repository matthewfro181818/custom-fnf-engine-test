package backend;

class PsychChartParser {
    public static function fromPsych(song:Dynamic):UnifiedChart {
        var chart:UnifiedChart = {
            notes: [],
            events: []
        };

        for (section in song.notes) {
            var mustPress = section.mustHitSection;

            for (noteData in section.sectionNotes) {
                var time = noteData[0];
                var lane = noteData[1];
                var sustain = noteData[2];
                var type = (noteData.length > 3) ? noteData[3] : "";

                chart.notes.push({
                    time: time,
                    lane: lane,
                    sustain: sustain,
                    type: type
                });
            }
        }

        if (song.events != null) {
            for (ev in song.events) {
                chart.events.push({
                    time: ev[0],
                    name: ev[1],
                    params: ev[2]
                });
            }
        }

        return chart;
    }
}
