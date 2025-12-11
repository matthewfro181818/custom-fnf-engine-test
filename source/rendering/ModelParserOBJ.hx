package rendering;

import openfl.geom.Vector3D;
import sys.io.File;

class ModelParserOBJ {
    public static function parse(path:String):Model3D {
        var model = new Model3D();
        var lines = File.getContent(path).split("\n");

        for (line in lines) {
            var parts = line.split(" ");

            switch parts[0] {
                case "v":
                    model.vertices.push(new Vector3D(
                        Std.parseFloat(parts[1]),
                        Std.parseFloat(parts[2]),
                        Std.parseFloat(parts[3])
                    ));

                case "vt":
                    model.uvs.push(new Vector3D(
                        Std.parseFloat(parts[1]),
                        Std.parseFloat(parts[2])
                    ));

                case "f":
                    var face = [];
                    for (i in 1...parts.length) {
                        var idx = parts[i].split("/")[0];
                        face.push(Std.parseInt(idx) - 1);
                    }
                    model.faces.push(face);
            }
        }

        return model;
    }
}
