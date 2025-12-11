package objects.notes;

import flixel.FlxSprite;

class Note extends FlxSprite {
    public var strumTime:Float;
    public var lane:Int;
    public var sustainLength:Float = 0;
    public var mustPress:Bool = false;
    public var wasGoodHit:Bool = false;
    public var wasMissed:Bool = false;
    public var type:String = "";
    public var isSustainNote:Bool = false;

    public function new(time:Float, lane:Int, sustain:Float, type:String, mustPress:Bool) {
        super();

        this.strumTime = time;
        this.lane = lane;
        this.type = type;
        this.mustPress = mustPress;
        this.sustainLength = sustain;

        this.isSustainNote = sustain > 0;
    }
}
