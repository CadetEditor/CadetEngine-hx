  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.geom.Vertex;@:meta(Serializable())
class TriangleGeometry extends PolygonGeometry
{
    public var flipVertical(get, set) : Bool;
    public var tipRatio(get, set) : Float;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
private var _flipVertical : Bool = false;private var _tipRatio : Float;private var _width : Float;private var _height : Float;public function new()
    {
        super();name = "TriangleGeometry";width = 100;height = 100;tipRatio = 0;flipVertical = false;
    }override public function validateNow() : Void{if (isInvalid("geometry")) {validateGeometry();
        }super.validateNow();
    }private function validateGeometry() : Void{var v1 : Vertex = new Vertex();v1.x = _tipRatio * _width;v1.y = (_flipVertical) ? _height : 0;var v2 : Vertex = new Vertex();v2.x = _width;v2.y = (_flipVertical) ? 0 : _height;var v3 : Vertex = new Vertex();v3.x = 0;v3.y = (_flipVertical) ? 0 : _height;var newVertices : Array<Dynamic> = [];newVertices.push(v1, v2, v3);vertices = newVertices;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_FlipVertical(value : Bool) : Bool{_flipVertical = value;invalidate("geometry");
        return value;
    }private function get_FlipVertical() : Bool{return _flipVertical;
    }@:meta(Serializable())
private function set_TipRatio(value : Float) : Float{_tipRatio = value;invalidate("geometry");
        return value;
    }private function get_TipRatio() : Float{return _tipRatio;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Width(value : Float) : Float{_width = value;invalidate("geometry");
        return value;
    }private function get_Width() : Float{return _width;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Height(value : Float) : Float{_height = value;invalidate("geometry");
        return value;
    }private function get_Height() : Float{return _height;
    }
}