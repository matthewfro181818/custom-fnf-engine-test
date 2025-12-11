package play;

import backend.TimingWindow;
import play.PlayState;
import objects.notes.Note;

class NoteJudge {
    public static function tryHit(ps:PlayState, note:Note):Bool {
        if (note.wasGoodHit || note.wasMissed) return false;

        var diff = backend.Conductor.songPosition - note.strumTime;
        var rating = TimingWindow.judge(diff);

        switch rating {
            case "miss":
                return false;

            default:
                note.wasGoodHit = true;
                ps.noteManager.dispatchPlayerHit(note, rating);
                return true;
        }
    }

    public static function forceHit(ps:PlayState, note:Note, rating:String = "sick") {
        note.wasGoodHit = true;
        ps.noteManager.dispatchPlayerHit(note, rating);
    }

    public static function miss(ps:PlayState, note:Note) {
        note.wasMissed = true;
        ps.noteManager.dispatchPlayerMiss(note);
    }
}
