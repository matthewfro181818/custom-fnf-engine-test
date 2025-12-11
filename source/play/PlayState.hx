package play;

import flixel.FlxG;
import flixel.FlxState;
import backend.Conductor;

class PlayState extends FlxState {
    public var songManager:SongManager;
    public var noteManager:NoteManager;
    public var stageManager:StageManager;
    public var characterManager:CharacterManager;
    public var uiManager:UIManager;
    public var eventManager:EventManager;
    public var cutsceneManager:CutsceneManager;
    public var scriptManager:ScriptManager;
    public var autoPlayer1:AutoPlayer;
    public var autoPlayer2:AutoPlayer;

    override public function create() {
        songManager       = new SongManager(this);
        stageManager      = new StageManager(this);
        characterManager  = new CharacterManager(this);
        noteManager       = new NoteManager(this);
        eventManager      = new EventManager(this);
        uiManager         = new UIManager(this);
        cutsceneManager   = new CutsceneManager(this);
        scriptManager     = new ScriptManager(this);
        
autoPlayer1 = new AutoPlayer(this, 1);
autoPlayer2 = new AutoPlayer(this, 2);

// Enable Botplay? Player chooses in menu
autoPlayer1.setEnabled(botplay);
inputManager.botplayEnabled = botplay;

        super.create();
    }

    override public function update(elapsed:Float) {
        Conductor.update(elapsed);

        songManager.update(elapsed);
        noteManager.update(elapsed);
        eventManager.update(elapsed);
        autoPlayer1.update(elapsed);
        autoPlayer2.update(elapsed);
        uiManager.update(elapsed);

        super.update(elapsed);
    }

    override public function beatHit() {
        stageManager.beatHit(Conductor.songPosition);
        characterManager.beatHit(Conductor.songPosition);
    }
}
