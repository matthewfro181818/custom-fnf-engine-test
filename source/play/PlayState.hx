package play;

import flixel.FlxG;
import flixel.FlxState;
import backend.Conductor;
import backend.ChartLoader;

class PlayState extends FlxState {
    // Core systems
    public var stageManager:StageManager;
    public var characterManager:CharacterManager;
    public var songManager:SongManager;
    public var noteManager:NoteManager;
    public var eventManager:EventManager;
    public var cameraManager:CameraManager;
    public var uiManager:UIManager;
    public var inputManager:InputManager;
    public var scriptManager:ScriptManager;

    // Only the player uses AutoPlayer
    public var autoPlayer:AutoPlayer;

    // Song info
    public var songName:String = "test";
    public var modName:String = "mod";
    public var downscroll:Bool = false;

    var curBeat:Int = 0;
    var curStep:Int = 0;

    override public function create() {
        super.create();

        // Initialize managers
        stageManager     = new StageManager(this);
        characterManager = new CharacterManager(this);
        songManager      = new SongManager(this);
        noteManager      = new NoteManager(this);
        eventManager     = new EventManager(this);
        cameraManager    = new CameraManager(this);
        uiManager        = new UIManager(this);
        inputManager     = new InputManager();
        scriptManager    = new ScriptManager(this);
        autoPlayer       = new AutoPlayer(this, 1);

        // Load scripts before stage/characters
        scriptManager.loadScripts();
        scriptManager.callCreate();

        // Stage
        stageManager.loadStage("default");

        // Characters (uses JSON)
        characterManager.loadCharacter("dad",  "mods/" + modName + "/characters/dad.json");
        characterManager.loadCharacter("bf",   "mods/" + modName + "/characters/bf.json");

        // Chart + Song
        var chart = ChartLoader.load("mods/" + modName + "/data/" + songName + "/chart.json");
        noteManager.loadChart(chart);
        eventManager.load(chart.events);

        // Song metadata
        var songJson = haxe.Json.parse(sys.io.File.getContent("mods/" + modName + "/data/" + songName + "/" + songName + ".json"));
        songManager.songData = songJson;
        Conductor.bpm = songJson.bpm;
        Conductor.recalcTimes();

        // Start music
        songManager.startSong();

        scriptManager.callCreatePost();
    }

    override public function update(elapsed:Float) {
        // Conductor updates timing
        Conductor.update(elapsed);

        // Managers update
        cameraManager.update(elapsed);
        stageManager.update(elapsed);
        characterManager.update(elapsed);
        noteManager.update(elapsed);
        uiManager.update(elapsed);
        scriptManager.update(elapsed);
        eventManager.update(Conductor.songPosition);
        autoPlayer.update(elapsed);

        // Beat and Step logic
        var newStep = Std.int(Conductor.songPosition / Conductor.stepCrochet);
        if (newStep > curStep) {
            curStep = newStep;
            stepHit();

            if (curStep % 4 == 0) {
                curBeat = Std.int(curStep / 4);
                beatHit();
            }
        }

        super.update(elapsed);
    }

    // ================
    // FRAME CALLBACKS
    // ================
    public function beatHit() {
        stageManager.beatHit(curBeat);
        characterManager.beatHit(curBeat);
        scriptManager.beatHit(curBeat);
    }

    public function stepHit() {
        scriptManager.stepHit(curStep);
    }
}
