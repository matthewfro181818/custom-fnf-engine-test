package rendering;

import openfl.geom.Vector3D;

class ModelCamera {
    public var position:Vector3D = new Vector3D(0,0,-5);
    public var rotation:Vector3D = new Vector3D();

    public function new() {}

    public function getViewMatrix() {
        // placeholder for matrix operations
        return null;
    }
}
