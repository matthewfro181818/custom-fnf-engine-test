package backend;

class UnifiedChartParser {
    public static function fromUnified(raw:Dynamic):UnifiedChart {
        return {
            notes: raw.chart.notes,
            events: raw.chart.events
        };
    }
}
