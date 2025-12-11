package rendering;

class ModelLoader {
    public static function load(path:String):Dynamic {
        // load OBJ, glTF, or FBX
        return ModelParser.parse(path);
    }
}
