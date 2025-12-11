package play;

import backend.UnifiedSong;
import backend.UnifiedChart;
import backend.Conductor;
import play.EventManager;
import play.NoteManager;
import backend.AudioController;

class SongManager {
    public var ps:PlayState;
    public var songData:UnifiedSong;
    public var chart:UnifiedChart;

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    public function loadSong(path:String) {
        var json = haxe.Json.parse(sys.io.File.getContent(path));

        songData = UnifiedSongConverter.toUnified(json);

        Conductor.bpm = songData.bpm;
        Conductor.recalcTimes();

        chart = songData.chart;

        AudioController.load(songData.instPath, songData.voicesPath);
    }

    public function startSong() {
        Conductor.songPosition = 0;
        AudioController.play();
    }

    public function update(elapsed:Float) {
        // update conductor position
        Conductor.update(elapsed);

        // update events
        ps.eventManager.update(Conductor.songPosition);
    }
}
