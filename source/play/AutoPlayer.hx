package play;

import backend.Conductor;
import objects.notes.Note;

class AutoPlayer {
    public var ps:PlayState;
    public var enabled:Bool = false;

    public var hitDelay:Float = 0;  // future expansion: latency simulation
    public var imperfectMode:Bool = false;

    public function new(ps:PlayState, enabled:Bool = false) {
        this.ps = ps;
        this.enabled = enabled;
    }

    // ================================================================
    // MAIN UPDATE CALLED FROM PlayState.update()
    // ================================================================

    public function update(elapsed:Float) {
        // No global logic needed yet
    }

    // ================================================================
    // NOTE LOGIC
    // Called from NoteManager.update() on every active note
    // ================================================================

    public function updateNote(note:Note) {
        if (!enabled) return;

        // ONLY hit when note is in the hittable window
        if (!note.canBeHit()) return;

        var diff = Math.abs(Conductor.songPosition - note.data.time);

        // Perfect: always hit once in SICK range
        if (diff <= ps.noteManager.hitWindowSick) {
            hit(note);
        }
    }

    // ================================================================
    // HIT NOTE AUTOMATICALLY
    // ================================================================

    private function hit(note:Note) {
        if (note.wasHit) return;

        note.wasHit = true;

        // Remove from note group
        ps.noteManager.notes.remove(note, true);

        // Score and combo
        ps.uiManager.addScore("sick");

        // Let scripts know
        ps.scriptManager.noteHit(note.data.id, note.data.lane, note.data.sustain);

        // Play animation on bf
        var bf = ps.characterManager.get("bf");
        if (bf != null) {
            var anim = "sing" + note.getDirName();
            bf.playAnim(anim, true);
        }

        // Camera follow assist
        ps.cameraManager.offset(
            (note.data.lane == 0 ? -20 : (note.data.lane == 3 ? 20 : 0)),
            0
        );
    }

    // ================================================================
    // CALLED FROM NoteManager AFTER MANUAL HIT
    // ================================================================

    public function onNoteHit(note:Note) {
        // For debug or expansion logic
    }
}
