package editors.ui;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxSlider;

class EditorUI {
    public static function label(x:Float, y:Float, text:String):FlxText {
        var t = new FlxText(x, y, 400, text, 16);
        t.color = 0xFFFFFF;
        return t;
    }

    public static function button(x:Float, y:Float, text:String, callback:Void->Void):FlxButton {
        var b = new FlxButton(x, y, text, callback);
        b.label.size = 16;
        return b;
    }

    public static function slider(x:Float, y:Float, min:Float, max:Float, value:Float, callback:Float->Void):FlxSlider {
        var s = new FlxSlider(callback, x, y, min, max, 200);
        s.value = value;
        return s;
    }
}
