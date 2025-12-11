package play;

import objects.notes.Note;
import backend.Conductor;

class AutoPlayer {
    public var ps:PlayState;
    public var enabled:Bool = false;
    public var player:Int; // 1 = P1, 2 = P2

    public function new(ps:PlayState, player:Int) {
        this.ps = ps;
        this.player = player;
    }

    /**
     * Toggle botplay on/off
     */
    public function setEnabled(v:Bool) {
        enabled = v;
        ps.uiManager.botplayText.visible = v;
    }

    /**
     * Main update loop
     */
    public function update(elapsed:Float) {
        if (!enabled) return;

        autoHitNotes();
    }

    /**
     * Automatically hit all notes for this player.
     */
    function autoHitNotes() {
        var nm = ps.noteManager;

        for (note in nm.activeNotes.members) {
            if (note == null) continue;

            // Only hit notes belonging to this player
            if (note.mustPress != (player == 1))
                continue;

            // Already hit or missed
            if (note.wasGoodHit || note.wasMissed)
                continue;

            var diff = Conductor.songPosition - note.strumTime;

            // Perfect timing window (0ms)
            if (Math.abs(diff) <= 10) {
                // Force perfect hit
                nm.dispatchPlayerHit(note, "sick");
                note.wasGoodHit = true;
            }

            // Sustain notes get held automatically
            if (note.isSustainNote) {
                if (Conductor.songPosition >= note.strumTime) {
                    nm.dispatchPlayerHit(note, "sick");
                }
            }
        }
    }
}
