  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.geom.QuadraticBezier;class BezierCurve extends AbstractGeometry
{
    public var segments(get, set) : Array<Dynamic>;
private var _segments : Array<Dynamic>;  //Vector.<QuadraticBezier>;  public function new()
    {
        super();name = "BezierCurve";_segments = new Array<Dynamic>();
    }@:meta(Serializable())
private function set_Segments(value : Array<Dynamic>) : Array<Dynamic>  //Vector.<QuadraticBezier> ):void  {_segments = value;invalidate("geometry");
        return value;
    }private function get_Segments() : Array<Dynamic>  //Vector.<QuadraticBezier>  {return _segments;
    }
}