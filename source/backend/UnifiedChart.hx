package backend;

typedef UnifiedNote = {
    var time:Float;
    var lane:Int;
    var sustain:Float;
    var type:String;
};

typedef UnifiedEvent = {
    var time:Float;
    var name:String;
    var params:Array<String>;
};

typedef UnifiedChart = {
    var notes:Array<UnifiedNote>;
    var events:Array<UnifiedEvent>;
};
