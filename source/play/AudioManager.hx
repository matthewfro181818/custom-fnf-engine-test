package play;

import flixel.FlxG;
import flixel.system.FlxSound;
import sys.FileSystem;

import util.Paths;

class AudioManager {
    public var ps:PlayState;

    // Main audio components
    public var inst:FlxSound;
    public var voices:FlxSound;

    public var volumeInst:Float = 1.0;
    public var volumeVoices:Float = 1.0;

    public var songName:String = "";
    public var modName:String = "";
    public var pitch:Float = 1;

    // Event callback
    public var onSongEnd:Void->Void = null;

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    // ========================================================================
    // PUBLIC API
    // ========================================================================

    public function loadSong(mod:String, name:String, startTimeMs:Float = 0) {
        modName = mod;
        songName = name;

        stop(); // stop previous song safely

        // Load INST
        var instPath = Paths.inst(modName, songName);
        if (instPath == null || !FileSystem.exists(instPath))
            trace("[AudioManager] Missing Inst for song: " + songName);

        inst = new FlxSound().loadStream(instPath, false, false);
        inst.volume = volumeInst;

        // Load VOICES
        var voicesPath = Paths.voices(modName, songName);
        if (voicesPath != null && FileSystem.exists(voicesPath)) {
            voices = new FlxSound().loadStream(voicesPath, false, false);
            voices.volume = volumeVoices;
        } else {
            voices = null;
        }

        // Sync voices to inst
        if (voices != null)
            voices.proximity(0, 0, inst);

        // Add to sound list
        FlxG.sound.list.add(inst);
        if (voices != null) FlxG.sound.list.add(voices);

        // Seek if needed
        if (startTimeMs > 0)
            setPosition(startTimeMs);

        trace("[AudioManager] Loaded: " + songName + " from mod: " + modName);
    }

    public function start() {
        if (inst != null) inst.play();
        if (voices != null) voices.play();
    }

    public function stop() {
        if (inst != null) inst.stop();
        if (voices != null) voices.stop();
    }

    public function pause() {
        if (inst != null) inst.pause();
        if (voices != null) voices.pause();
    }

    public function resume() {
        if (inst != null) inst.resume();
        if (voices != null) voices.resume();
    }

    public function setPosition(ms:Float) {
        if (inst != null) inst.time = ms;
        if (voices != null) voices.time = ms;
    }

    public function getPosition():Float {
        return inst != null ? inst.time : 0;
    }

    public function setPitch(value:Float) {
        pitch = value;
        if (inst != null) inst.pitch = value;
        if (voices != null) voices.pitch = value;
    }

    public function update(elapsed:Float) {
        if (inst != null && inst.finished) {
            if (onSongEnd != null)
                onSongEnd();
        }
    }

    // ========================================================================
    // MENU PREVIEW AUDIO
    // ========================================================================
    public function playPreview(mod:String, song:String) {
        var path = Paths.inst(mod, song);

        if (path == null || !FileSystem.exists(path)) {
            trace("[AudioManager] No preview audio for: " + song);
            return;
        }

        stop(); // stop current preview

        inst = new FlxSound().loadStream(path, false, false);
        inst.volume = 0.9;

        FlxG.sound.list.add(inst);

        inst.play();
    }

    // ========================================================================
    // CLEANUP
    // ========================================================================
    public function destroy() {
        stop();
        inst = null;
        voices = null;
    }
}
