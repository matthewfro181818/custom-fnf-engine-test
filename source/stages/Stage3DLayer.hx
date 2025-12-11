package stages;

import rendering.ModelLoader;
import rendering.ModelRenderer;

class Stage3DLayer extends StageLayer {
    public var model:Dynamic;

    public function new(path:String) {
        super();
        model = ModelLoader.load(path);
    }

    override public function instantiate(ps:PlayState) {
        // 3D models do not use FlxSprite
    }

    override public function update(elapsed:Float) {
        ModelRenderer.render(model);
    }
}
