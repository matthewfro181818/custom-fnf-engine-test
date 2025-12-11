package objects;

class ModelCharacter extends Character {
    public var model:Dynamic;

    public function new(json:Dynamic) {
        super();
        model = ModelLoader.load(json.model);
    }

    override function playAnim(name:String) {
        model.playAnimation(name);
    }
}
