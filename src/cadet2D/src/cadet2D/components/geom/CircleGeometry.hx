  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.components.transforms.Transform2D;import nme.geom.Matrix;import nme.geom.Point;@:meta(Serializable())
class CircleGeometry extends AbstractGeometry
{
    public var radius(get, set) : Float;
@:meta(Serializable())
public var x : Float = 0;@:meta(Serializable())
public var y : Float = 0;private var _radius : Float;public function new(radius : Float = 50)
    {super("Circle");this.radius = radius;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Radius(value : Float) : Float{_radius = value;invalidate("geometry");
        return value;
    }private function get_Radius() : Float{return _radius;
    }public function centre(transform : Transform2D) : Void{  //addOperation( new ChangePropertyOperation( circle, "x", 0 ) );    //addOperation( new ChangePropertyOperation( circle, "y", 0 ) );  x = 0;y = 0;var m : Matrix = new Matrix(transform.matrix.a, transform.matrix.b, transform.matrix.c, transform.matrix.d);var pt : Point = new Point(x, y);pt = m.transformPoint(pt);  //addOperation( new ChangePropertyOperation( transform, "x", transform.x+pt.x ) );    //addOperation( new ChangePropertyOperation( transform, "y", transform.y+pt.y ) );  transform.x = transform.x + pt.x;transform.y = transform.y + pt.y;transformConnections(m, transform);
    }
}