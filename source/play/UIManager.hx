package play;

import play.ui.*;
import flixel.FlxG;

class UIManager {
    public var ps:PlayState;

    public var healthBar:HealthBar;
    public var iconP1:Icon;
    public var iconP2:Icon;

    public var score:Int = 0;
    public var combo:Int = 0;

    public var scrollSpeed:Float = 1.0;

    public var botplayText:BotplayText;

    public function new(ps:PlayState) {
        this.ps = ps;

        healthBar = new HealthBar(ps);
        ps.add(healthBar);

        iconP1 = new Icon("bf");
        iconP2 = new Icon("dad");

        ps.add(iconP1);
        ps.add(iconP2);

        botplayText = new BotplayText();
        ps.add(botplayText);
    }

    public function update(elapsed:Float) {
        healthBar.update(elapsed);
        iconP1.updateIcon(healthBar.health);
        iconP2.updateIcon(1 - healthBar.health);
    }

    // Called when player hits a note
    public function onHit(rating:String) {
        score += switch(rating) {
            case "sick": 350;
            case "good": 200;
            case "bad":  100;
            default: 0;
        };

        RatingPopup.spawn(ps, rating);
        ComboPopup.spawn(ps);
    }

    // Called when player misses
    public function onMiss() {
        combo = 0;
    }

    public function shake(amount:Float, duration:Float) {
        FlxG.camera.shake(amount, duration);
    }

    public function setHUDVisible(v:Bool) {
        healthBar.visible = v;
        iconP1.visible = v;
        iconP2.visible = v;
        botplayText.visible = v;
    }

    public function getStrumY(note) {
        // Default Psych-style note position
        return FlxG.height * (ps.downscroll ? 0.2 : 0.8);
    }
}
