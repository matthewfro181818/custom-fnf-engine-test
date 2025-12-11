package play;

class PlayState extends MusicBeatState {
    public var songManager:SongManager;
    public var noteManager:NoteManager;
    public var characterManager:CharacterManager;
    public var stageManager:StageManager;
    public var uiManager:UIManager;
    public var autoPlayer1:AutoPlayer;
    public var autoPlayer2:AutoPlayer;
    public var eventManager:EventManager;

    override function create() {
        songManager = new SongManager(this);
        stageManager = new StageManager(this);
        characterManager = new CharacterManager(this);
        noteManager = new NoteManager(this);
        eventManager = new EventManager(this);
        uiManager = new UIManager(this);

        autoPlayer1 = new AutoPlayer(this, 1);
        autoPlayer2 = new AutoPlayer(this, 2);

        super.create();
    }

    override function update(elapsed:Float) {
        songManager.update(elapsed);
        noteManager.update(elapsed);
        eventManager.update(elapsed);
        autoPlayer1.update(elapsed);
        autoPlayer2.update(elapsed);
        uiManager.update(elapsed);

        super.update(elapsed);
    }

    override function beatHit() {
        super.beatHit();
        stageManager.beatHit();
        characterManager.beatHit();
    }

    override function stepHit() {
        super.stepHit();
        eventManager.stepHit();
    }
}
