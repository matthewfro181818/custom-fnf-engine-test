package rendering;

class ModelLoader {
    public static function load(path:String):Model3D {
        if (path.endsWith(".obj"))
            return ModelParserOBJ.parse(path);

        if (path.endsWith(".gltf"))
            return ModelParserGLTF.parse(path);

        throw "Unsupported 3D model: " + path;
    }
}
