package play;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;

import backend.Conductor;
import backend.chart.*;
import util.Paths;

import objects.notes.Note;
import objects.notes.Receptor;

class NoteManager {
    public var ps:PlayState;

    public var notes:FlxGroup;          // active notes
    public var receptors:Array<Receptor>;
    public var scrollSpeed:Float = 1.0;

    public var hitWindowSick:Float = 45;
    public var hitWindowGood:Float = 90;
    public var hitWindowBad:Float = 135;

    public var downscroll:Bool = false;

    private var chart:Array<ChartNote>;

    public function new(ps:PlayState) {
        this.ps = ps;

        notes = new FlxGroup();
        receptors = [];

        ps.add(notes);
        createReceptors();
    }

    // =====================================================================
    // LOAD CHART
    // =====================================================================

    public function loadChart(charData:ChartData) {
        chart = charData.notes.copy();

        scrollSpeed = charData.scrollSpeed != null ? charData.scrollSpeed : 1.0;
        downscroll = ps.downscroll;

        notes.clear();
    }

    // =====================================================================
    // RECEPTORS
    // =====================================================================

    private function createReceptors() {
        for (i in 0...4) {
            var r = new Receptor(i, ps);
            r.x = 200 + i * 140;
            r.y = downscroll ? 100 : FlxG.height - 200;
            receptors.push(r);
            ps.add(r);
        }
    }

    // =====================================================================
    // UPDATE (called by PlayState)
    // =====================================================================

    public function update(elapsed:Float) {
        spawnNotes();

        for (note in notes.members) {
            if (note == null) continue;

            updateNotePosition(note);

            if (note.canBeHit() && checkPlayerInput(note)) {
                hitNote(note);
            }

            // AutoPlayer (botplay)
            if (ps.autoPlayer.enabled)
                ps.autoPlayer.updateNote(note);
        }
    }

    // =====================================================================
    // SPAWN NOTES
    // =====================================================================

    private function spawnNotes() {
        var songTime = Conductor.songPosition;

        // spawn notes slightly ahead
        var spawnWindow = 1800;

        while (chart.length > 0 && chart[0].time <= songTime + spawnWindow) {
            var n = chart.shift();
            var newNote = new Note(n, ps, downscroll, scrollSpeed);
            notes.add(newNote);
        }
    }

    // =====================================================================
    // MOVEMENT
    // =====================================================================

    private function updateNotePosition(note:Note) {
        var receptor = receptors[note.data.lane];

        var diff = Conductor.songPosition - note.data.time;

        var pixelsPerMs = 0.45 * scrollSpeed;
        var distance = diff * pixelsPerMs;

        if (downscroll)
            note.y = receptor.y + distance;
        else
            note.y = receptor.y - distance;

        // Hide notes after passing the screen
        if (!note.wasHit && Math.abs(diff) > 400) {
            missNote(note);
        }
    }

    // =====================================================================
    // PLAYER INPUT
    // =====================================================================

    private function checkPlayerInput(note:Note):Bool {
        var lane = note.data.lane;

        // Psych-style keys
        switch (lane) {
            case 0: return FlxG.keys.justPressed.D or FlxG.keys.justPressed.LEFT;
            case 1: return FlxG.keys.justPressed.F or FlxG.keys.justPressed.DOWN;
            case 2: return FlxG.keys.justPressed.J or FlxG.keys.justPressed.UP;
            case 3: return FlxG.keys.justPressed.K or FlxG.keys.justPressed.RIGHT;
        }

        return false;
    }

    // =====================================================================
    // HIT / MISS LOGIC
    // =====================================================================

    private function hitNote(note:Note) {
        var diff = Math.abs(Conductor.songPosition - note.data.time);

        var rating = "bad";

        if (diff <= hitWindowSick)      rating = "sick";
        else if (diff <= hitWindowGood) rating = "good";
        else if (diff <= hitWindowBad)  rating = "bad";

        receptors[note.data.lane].playConfirm();

        note.wasHit = true;
        notes.remove(note, true);

        ps.uiManager.addScore(rating);
        ps.scriptManager.noteHit(note.data.id, note.data.lane, note.data.sustain);

        if (ps.autoPlayer.enabled)
            ps.autoPlayer.onNoteHit(note);

        // Play animations
        ps.characterManager.get("bf").playAnim("sing" + note.getDirName(), true);
    }

    private function missNote(note:Note) {
        note.wasHit = true;
        notes.remove(note, true);

        ps.uiManager.applyMissPenalty();
        ps.scriptManager.noteMiss(note.data.id, note.data.lane, note.data.sustain);

        var bf = ps.characterManager.get("bf");
        if (bf != null) bf.playAnim("miss" + note.getDirName(), true);
    }
}
