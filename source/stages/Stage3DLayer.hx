package stages;

import rendering.Model3D;
import rendering.ModelLoader;
import rendering.ModelRenderer;
import openfl.display.Sprite;

class Stage3DLayer extends StageLayer {
    public var model:Model3D;
    public var sprite:Sprite;

    public function new(modelPath:String) {
        super();
        model = ModelLoader.load(modelPath);
        sprite = new Sprite();
    }

    override public function instantiate(ps:PlayState) {
        ps.add(sprite);
    }

    override public function update(elapsed:Float) {
        ModelRenderer.render(model, sprite.graphics);
    }
}
