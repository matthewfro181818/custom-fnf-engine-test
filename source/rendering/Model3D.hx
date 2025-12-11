package rendering;

import openfl.geom.Vector3D;

class Model3D {
    public var vertices:Array<Vector3D>;
    public var faces:Array<Array<Int>>;
    public var uvs:Array<Vector3D>;
    public var rotation:Vector3D = new Vector3D();
    public var position:Vector3D = new Vector3D();
    public var scale:Vector3D = new Vector3D(1,1,1);

    public function new() {
        vertices = [];
        faces = [];
        uvs = [];
    }
}
