package play;

import play.notes.Note;
import play.PlayState;
import backend.Conductor;

class AutoPlayer {
    public var enabled:Bool = false;
    public var player:Int = 1; // 1 = BF, 2 = Opponent (optional)

    var ps:PlayState;

    public function new(state:PlayState, player:Int = 1) {
        ps = state;
        this.player = player;
    }

    public function update(elapsed:Float) {
        if (!enabled) return;

        for (note in ps.notes) {
            // match correct player
            if (note.mustPress && player == 1)
                checkNote(note);
            else if (!note.mustPress && player == 2)
                checkNote(note);
        }
    }

    inline function checkNote(note:Note) {
        if (note.wasGoodHit || note.ignoreNote) return;

        // Perfect-timing condition
        if (Conductor.songPosition >= note.strumTime - Conductor.safeZoneOffset) {
            hitNote(note);
        }
    }

    inline function hitNote(note:Note) {
        if (player == 1)
            ps.goodNoteHit(note);
        else
            ps.opponentNoteHit(note);

        note.wasGoodHit = true;
    }
}
