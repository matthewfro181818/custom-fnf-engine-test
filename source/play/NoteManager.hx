package play;

import objects.notes.Note;
import objects.notes.SustainNote;
import backend.UnifiedChart;
import backend.Conductor;
import play.NoteJudge;

import flixel.group.FlxTypedGroup;

class NoteManager {
    public var ps:PlayState;
    public var allNotes:Array<Note> = [];
    public var activeNotes:FlxTypedGroup<Note>;

    public function new(ps:PlayState) {
        this.ps = ps;
        activeNotes = new FlxTypedGroup<Note>();
        ps.add(activeNotes);
    }

    public function loadChart(chart:UnifiedChart) {
        allNotes = NoteSpawner.generate(chart);

        // Create sustain children
        var sustainNotes:Array<SustainNote> = [];

        for (note in allNotes) {
            var sustain = Std.int(note.sustainLength / 50);

            for (i in 1...sustain) {
                var sn = new SustainNote(note, i);
                sustainNotes.push(sn);
            }
        }

        for (sn in sustainNotes) allNotes.push(sn);

        allNotes.sort((a,b) -> Reflect.compare(a.strumTime, b.strumTime));
    }

    public function update(elapsed:Float) {
        spawnIncomingNotes();
        scrollNotes(elapsed);
        checkPlayerInput();
        checkForMisses();
    }

    function spawnIncomingNotes() {
        var threshold = Conductor.songPosition + 1800;

        while (allNotes.length > 0 && allNotes[0].strumTime <= threshold) {
            var n = allNotes.shift();
            activeNotes.add(n);
        }
    }

    function scrollNotes(elapsed:Float) {
        for (note in activeNotes.members) {
            if (note == null) continue;

            var dist = note.strumTime - Conductor.songPosition;
            note.y = ps.uiManager.getStrumY(note) - dist * ps.uiManager.scrollSpeed;
        }
    }

    private function checkPlayerInput() {
        if (ps.autoPlayer1.enabled) return;

        var keys = ps.inputManager.getActiveLanes();

        for (lane in keys) {
            for (note in activeNotes.members) {
                if (note == null) continue;

                if (note.mustPress && note.lane == lane) {
                    if (NoteJudge.tryHit(ps, note)) break;
                }
            }
        }
    }

    private function checkForMisses() {
        for (note in activeNotes.members) {
            if (!note.mustPress || note.wasGoodHit || note.wasMissed) continue;

            if (Conductor.songPosition > note.strumTime + backend.TimingWindow.miss) {
                NoteJudge.miss(ps, note);
            }
        }
    }

    //
    // Event dispatch (called by NoteJudge)
    //

    public function dispatchPlayerHit(note:Note, rating:String) {
        ps.characterManager.playerSing(note.lane);
        ps.uiManager.onHit(rating);
    }

    public function dispatchPlayerMiss(note:Note) {
        ps.characterManager.playerMiss(note.lane);
        ps.uiManager.onMiss();
    }

    public function opponentHit(note:Note) {
        ps.characterManager.opponentSing(note.lane);
    }
}
