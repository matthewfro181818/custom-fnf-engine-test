package play;

import objects.*;
import backend.UnifiedSong;
import flixel.group.FlxTypedGroup;

class CharacterManager {
    public var ps:PlayState;
    public var characters:Map<String, Character> = [];
    public var group:FlxTypedGroup<Character>;

    public function new(ps:PlayState) {
        this.ps = ps;
        group = new FlxTypedGroup<Character>();
        ps.add(group);
    }

    public function loadCharacter(id:String, path:String):Character {
        var json:Dynamic = haxe.Json.parse(sys.io.File.getContent(path));

        var type:String = json.type;
        var character:Character = switch(type) {
            case "png":        new PNGCharacter(json);
            case "atlas":      new AtlasCharacter(json);
            case "animate":    new AnimateCharacter(json);
            case "spine":      new SpineCharacter(json);
            case "model3d":    new ModelCharacter(json);
            default:           new PNGCharacter(json);
        };

        characters.set(id, character);
        group.add(character);

        return character;
    }

    public function beatHit(curBeat:Int) {
        for (c in characters) c.beatHit(curBeat);
    }
}
