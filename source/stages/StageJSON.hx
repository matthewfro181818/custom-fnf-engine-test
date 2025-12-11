package stages;

typedef StageJSON = {
    var name:String;
    var layers:Array<{
        var image:String;
        var x:Float;
        var y:Float;
        var scrollX:Float;
        var scrollY:Float;
        @:optional var xml:String;
        @:optional var animation:String;
        @:optional var frames:Array<Int>;
        @:optional var fps:Int;
    }>;
};
