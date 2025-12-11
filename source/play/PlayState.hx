package play;

import flixel.FlxG;
import flixel.FlxState;

import backend.Conductor;
import backend.chart.ChartLoader;
import backend.chart.ChartData;

class PlayState extends FlxState {
    // Core info
    public var modName:String;
    public var songName:String;
    public var downscroll:Bool = false;

    // Managers
    public var characterManager:CharacterManager;
    public var stageManager:StageManager;
    public var audioManager:AudioManager;
    public var scriptManager:ScriptManager;
    public var cameraManager:CameraManager;
    public var noteManager:NoteManager;
    public var uiManager:UIManager;
    public var autoPlayer:AutoPlayer;
    public var postFX:PostFXManager;
    public var input:InputManager;
    public var eventManager:EventManager;

    // Chart
    public var chart:ChartData;

    // Timing
    private var beat:Int = 0;
    private var step:Int = 0;

    // =====================================================================
    // CREATE
    // =====================================================================

    override public function create() {
        super.create();

        // Default values (normally set externally)
        if (modName == null) modName = "default";
        if (songName == null) songName = "tutorial";
        downscroll = FlxG.save.data.downscroll ?? false;

        // -----------------------------
        // Load chart
        // -----------------------------
        chart = ChartLoader.load(modName, songName);
        Conductor.changeBPM(chart.bpm);

        // -----------------------------
        // Managers
        // -----------------------------
        scriptManager = new ScriptManager(this);
        cameraManager = new CameraManager(this);
        stageManager = new StageManager(this);
        characterManager = new CharacterManager(this);
        audioManager = new AudioManager(this);
        noteManager = new NoteManager(this);
        uiManager = new UIManager(this);
        autoPlayer = new AutoPlayer(this, false);
        postFX = new PostFXManager(this);
        input = new InputManager(this);
        eventManager = new EventManager(this);

        // -----------------------------
        // Stage + characters
        // -----------------------------
        stageManager.loadStage("defaultStage");
        characterManager.loadCharacters(modName, songName);

        // -----------------------------
        // Scripts
        // -----------------------------
        scriptManager.loadScripts();
        scriptManager.callCreate();

        // -----------------------------
        // Notes + Events
        // -----------------------------
        noteManager.loadChart(chart);
        eventManager.load(chart.events);

        // -----------------------------
        // Audio
        // -----------------------------
        audioManager.loadSong(modName, songName);
        audioManager.onSongEnd = () -> endSong();

        // -----------------------------
        // Start song
        // -----------------------------
        Conductor.songPosition = 0;
        audioManager.start();

        scriptManager.callCreatePost();
    }

    // =====================================================================
    // UPDATE
    // =====================================================================

    override public function update(elapsed:Float) {
        super.update(elapsed);

        Conductor.update(elapsed);
        input.update();

        // Order matters
        scriptManager.update(elapsed);
        stageManager.update(elapsed);
        cameraManager.update(elapsed);
        characterManager.update(elapsed);
        noteManager.update(elapsed);
        uiManager.update(elapsed);
        postFX.update(elapsed);
        eventManager.update();
        autoPlayer.update(elapsed);
        audioManager.update(elapsed);

        // Beat / Step logic
        updateBeatStep();

        scriptManager.callUpdatePost(elapsed);
    }

    private function updateBeatStep() {
        var curBeat = Conductor.curBeat;
        var curStep = Conductor.curStep;

        if (curBeat != beat) {
            beat = curBeat;
            scriptManager.beatHit(beat);
            stageManager.beatHit(beat);
        }

        if (curStep != step) {
            step = curStep;
            scriptManager.stepHit(step);
        }
    }

    // =====================================================================
    // END SONG
    // =====================================================================

    public function endSong() {
        scriptManager.callEvent("songEnd", []);
        FlxG.switchState(new play.PlayState()); // TEMPORARY
    }
}
