package editors;

import backend.UnifiedChart;
import backend.UnifiedNote;
import flixel.FlxSprite;
import flixel.FlxG;

class EditorTimeline extends FlxSprite {
    public var chart:UnifiedChart;
    public var songPos:Float = 0;
    public var playing:Bool = false;

    public function new(c:UnifiedChart) {
        super();
        chart = c;
        makeGraphic(1000, 800, 0xFF111111);
    }

    public function setChart(c:UnifiedChart) {
        chart = c;
    }

    public function play() playing = true;
    public function stop() playing = false;

    override public function update(elapsed:Float) {
        if (playing) {
            songPos += elapsed * 1000;
        }
        super.update(elapsed);
    }

    override public function draw() {
        super.draw();

        for (note in chart.notes) {
            var laneX = 100 + (note.lane * 60);
            var y = 700 - (note.time - songPos) * 0.2;

            FlxG.camera.buffer.fillRect(new openfl.geom.Rectangle(
                laneX, y, 58, 12
            ), 0xFF00FF00);
        }
    }
}
