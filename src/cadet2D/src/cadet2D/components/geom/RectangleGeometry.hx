  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.components.transforms.Transform2D;import cadet2d.geom.Vertex;class RectangleGeometry extends PolygonGeometry
{
    public var width(get, set) : Float;
    public var height(get, set) : Float;
private inline var SIZE : String = "size";private var _width : Float;private var _height : Float;private var corners : Array<Dynamic>;public function new(width : Float = 100, height : Float = 100)
    {
        super();name = "RectangleGeometry";  // corners order: TopLeft, TopRight, BottomRight, BottomLeft  corners = [new Vertex(0, 0), new Vertex(1, 0), new Vertex(1, 1), new Vertex(0, 1)];this.width = width;this.height = height;
    }override public function validateNow() : Void{if (isInvalid(GEOMETRY)) {validateGeometry();
        }if (isInvalid(SIZE)) {validateSize();
        }super.validateNow();
    }  // Checks to see if the rectangle is regular or not (i.e. not distorted)  private function isRegular() : Bool{if (corners[1].x != corners[2].x)             return false;if (corners[0].x != corners[3].x)             return false;if (corners[0].y != corners[1].y)             return false;if (corners[2].y != corners[3].y)             return false;return true;
    }private function getCornersBy(filterFunc : Function) : Array<Dynamic>{var ordered : Array<Dynamic> = [];  //trace("unordered "+corners);  for (i in 0...corners.length){ordered[i] = corners[i];
        }ordered.sort(filterFunc);  //trace("ordered "+ordered);  return ordered;
    }private function filterByX(a : Vertex, b : Vertex) : Int{if (a.x < b.x)             return -1;if (b.x < a.x)             return 1;return 0;
    }private function filterByY(a : Vertex, b : Vertex) : Int{if (a.y < b.y)             return -1;if (b.y < a.y)             return 1;return 0;
    }private function validateSize() : Void{var regular : Bool = isRegular();  //trace("regular "+regular);    // setting the vertices and setting the width & height values causes a battle for control,    // so RectangleGeometry has 2 modes: regular & irregular. If regular, vertex positions are    // overridden by width & height values, if irregular, width & height values are overridden    // by vertex positions.  if (regular) {corners[1].x = _width;corners[2].x = _width;corners[2].y = _height;corners[3].y = _height;
        }
        else {var xCorners : Array<Dynamic> = getCornersBy(filterByX);var yCorners : Array<Dynamic> = getCornersBy(filterByY);var last : Vertex = xCorners[xCorners.length - 1];var first : Vertex = xCorners[0];_width = last.x - first.x;last = yCorners[yCorners.length - 1];first = yCorners[0];_height = last.y - first.y;
        }vertices = corners;
    }private function validateGeometry() : Void{if (vertices.length == 0)             return;corners = vertices;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Width(value : Float) : Float{_width = value;invalidate(SIZE);
        return value;
    }private function get_Width() : Float{return _width;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Height(value : Float) : Float{_height = value;invalidate(SIZE);
        return value;
    }private function get_Height() : Float{return _height;
    }override public function centre(transform : Transform2D, useCentroid : Bool = false) : Void{  //validateNow();  super.centre(transform, useCentroid);
    }
}