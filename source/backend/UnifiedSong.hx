package backend;

typedef UnifiedSong = {
    var song:String;
    var bpm:Float;
    var speed:Float;

    var chart:Dynamic;   // unified chart
    var events:Array<Dynamic>;

    var instPath:String;
    var voicesPath:String;

    var stage:String;
    var characters:Array<String>;
}
