package play;

import stages.Stage;
import stages.StageParser;
import flixel.FlxState;

class StageManager {
    public var ps:PlayState;
    public var stage:Stage;

    public function new(ps:PlayState) {
        this.ps = ps;
    }

    public function loadStage(name:String) {
        var path = Paths.stageJson(ps.modName, name);
        config = Json.parse(File.getContent(path));

        loadCamera(config.camera);
        loadLayers(config.layers);
        loadPost(config.post);
        loadScript(config.script);
    }

    function loadLayers(arr:Array<Dynamic>) {
        for (l in arr) {
            switch(l.type) {
                case "sprite":
                    addSprite(l);
                case "animated":
                    addAnimated(l);
                case "atlas":
                    addAtlas(l);
                case "animate":
                    addAnimateSymbol(l);
                case "model3d":
                    add3DModel(l);
            }
        }
    }

    public function beatHit(curBeat:Int) {
        if (stage != null)
            stage.beatHit(curBeat);
    }

    public function update(elapsed:Float) {
        if (stage != null)
            stage.update(elapsed);
    }
}
