// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.debug;

import cadet3d.components.debug.ColorMaterial;
import cadet3d.components.debug.Geometry;
import cadet3d.components.debug.LatheExtrude;
import cadet3d.components.debug.Merge;
import cadet3d.components.debug.Mesh;
import cadet3d.components.debug.ObjectContainer3D;
import cadet3d.components.debug.ObjectContainer3DComponent;
import cadet3d.components.debug.TridentLines;
import cadet3d.components.debug.Vector3D;
import away3d.containers.ObjectContainer3D;import away3d.core.base.Geometry;import away3d.debug.Trident;import away3d.debug.data.TridentLines;import away3d.entities.Mesh;import away3d.extrusions.LatheExtrude;import away3d.materials.ColorMaterial;import away3d.tools.commands.Merge;import cadet3d.components.core.ObjectContainer3DComponent;import nme.geom.Vector3D;class TridentComponent extends ObjectContainer3DComponent
{
    public var length(get, set) : Int;
    public var showLetters(get, set) : Bool;
    public var mesh(get, never) : Mesh;
private var _mesh : Mesh;private var _length : Int;private var _showLetters : Bool;private static inline var DISPLAY : String = "display";public function new(length : Int = 500, showLetters : Bool = true)
    {
        super();_object3D = _mesh = new Mesh(new Geometry());_mesh.castsShadows = false;_length = length;_showLetters = showLetters;invalidate(DISPLAY);
    }@:meta(Serializable())
@:meta(Inspectable(priority="150"))
private function set_Length(value : Int) : Int{if (_length == value)             return;_length = value;invalidate(DISPLAY);
        return value;
    }private function get_Length() : Int{return _length;
    }@:meta(Serializable())
@:meta(Inspectable(priority="151"))
private function set_ShowLetters(value : Bool) : Bool{if (_showLetters == value)             return;_showLetters = value;invalidate(DISPLAY);
        return value;
    }private function get_ShowLetters() : Bool{return _showLetters;
    }override private function validate() : Void{if (isInvalid(DISPLAY)) {validateDisplay();
        }
    }private function validateDisplay() : Void{while (_mesh.numChildren){var child : ObjectContainer3D = _mesh.getChildAt(0);_mesh.removeChild(child);
        }buildTrident(_length, _showLetters);
    }override public function dispose() : Void{super.dispose();_mesh.dispose();
    }private function get_Mesh() : Mesh{return _mesh;
    }private function buildTrident(length : Float, showLetters : Bool) : Void{_mesh.geometry = new Geometry();var base : Float = length * .9;var rad : Float = 2.4;var offset : Float = length * .025;var vectors : Array<Array<Vector3D>> = new Array<Array<Vector3D>>();var colors : Array<Int> = [0xFF0000, 0x00FF00, 0x0000FF];var matX : ColorMaterial = new ColorMaterial(0xFF0000);var matY : ColorMaterial = new ColorMaterial(0x00FF00);var matZ : ColorMaterial = new ColorMaterial(0x0000FF);var matOrigin : ColorMaterial = new ColorMaterial(0xCCCCCC);var merge : Merge = new Merge(true, true);var profileX : Array<Vector3D> = new Array<Vector3D>();profileX[0] = new Vector3D(length, 0, 0);profileX[1] = new Vector3D(base, 0, offset);profileX[2] = new Vector3D(base, 0, -rad);vectors[0] = [new Vector3D(0, 0, 0), new Vector3D(base, 0, 0)];var arrowX : LatheExtrude = new LatheExtrude(matX, profileX, LatheExtrude.X_AXIS, 1, 10);var profileY : Array<Vector3D> = new Array<Vector3D>();profileY[0] = new Vector3D(0, length, 0);profileY[1] = new Vector3D(offset, base, 0);profileY[2] = new Vector3D(-rad, base, 0);vectors[1] = [new Vector3D(0, 0, 0), new Vector3D(0, base, 0)];var arrowY : LatheExtrude = new LatheExtrude(matY, profileY, LatheExtrude.Y_AXIS, 1, 10);var profileZ : Array<Vector3D> = new Array<Vector3D>();vectors[2] = [new Vector3D(0, 0, 0), new Vector3D(0, 0, base)];profileZ[0] = new Vector3D(0, rad, base);profileZ[1] = new Vector3D(0, offset, base);profileZ[2] = new Vector3D(0, 0, length);var arrowZ : LatheExtrude = new LatheExtrude(matZ, profileZ, LatheExtrude.Z_AXIS, 1, 10);var profileO : Array<Vector3D> = new Array<Vector3D>();profileO[0] = new Vector3D(0, rad, 0);profileO[1] = new Vector3D(-(rad * .7), rad * .7, 0);profileO[2] = new Vector3D(-rad, 0, 0);profileO[3] = new Vector3D(-(rad * .7), -(rad * .7), 0);profileO[4] = new Vector3D(0, -rad, 0);var origin : LatheExtrude = new LatheExtrude(matOrigin, profileO, LatheExtrude.Y_AXIS, 1, 10);merge.applyToMeshes(_mesh, [arrowX, arrowY, arrowZ, origin]);if (showLetters) {var scaleH : Float = length / 10;var scaleW : Float = length / 20;offset = length - scaleW;var scl1 : Float = scaleW * 1.5;var scl2 : Float = scaleH * 3;var scl3 : Float = scaleH * 2;var scl4 : Float = scaleH * 3.4;var cross : Float = length + (scl3) + (((length + scl4) - (length + scl3)) / 3 * 2);  //x  vectors[3] = [new Vector3D(length + scl2, scl1, 0), new Vector3D(length + scl3, -scl1, 0), new Vector3D(length + scl3, scl1, 0), new Vector3D(length + scl2, -scl1, 0)];  //y  vectors[4] = [new Vector3D(-scaleW * 1.2, length + scl4, 0), new Vector3D(0, cross, 0), new Vector3D(scaleW * 1.2, length + scl4, 0), new Vector3D(0, cross, 0), new Vector3D(0, cross, 0), new Vector3D(0, length + scl3, 0)];  //z  vectors[5] = [new Vector3D(0, scl1, length + scl2), new Vector3D(0, scl1, length + scl3), new Vector3D(0, -scl1, length + scl2), new Vector3D(0, -scl1, length + scl3), new Vector3D(0, -scl1, length + scl3), new Vector3D(0, scl1, length + scl2)];colors.push(0xFF0000, 0x00FF00, 0x0000FF);
        }_mesh.addChild(new TridentLines(vectors, colors));arrowX = arrowY = arrowZ = origin = null;
    }
}