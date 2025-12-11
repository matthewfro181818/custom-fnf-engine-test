debug("ExampleMod global script loaded.");

function onBeatHit(beat:Int) {
    if (beat % 8 == 0)
        debug("Beat: " + beat);
}
