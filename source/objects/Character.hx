package objects;

import flixel.FlxSprite;

class Character extends FlxSprite {
    public var charType:String = "base";
    public var animPrefix:String = "";
    public var flip:Bool = false;

    public function playAnim(name:String):Void {}

    public function beatHit(curBeat:Int):Void {}
}
