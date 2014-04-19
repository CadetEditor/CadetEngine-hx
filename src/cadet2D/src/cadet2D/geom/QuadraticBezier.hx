  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.geom;

class QuadraticBezier
{@:meta(Serializable())
public var startX : Float;@:meta(Serializable())
public var startY : Float;@:meta(Serializable())
public var controlX : Float;@:meta(Serializable())
public var controlY : Float;@:meta(Serializable())
public var endX : Float;@:meta(Serializable())
public var endY : Float;public function new(startX : Float = 0, startY : Float = 0, controlX : Float = 0, controlY : Float = 0, endX : Float = 0, endY : Float = 0)
    {this.startX = startX;this.startY = startY;this.controlX = controlX;this.controlY = controlY;this.endX = endX;this.endY = endY;
    }public function clone() : QuadraticBezier{return new QuadraticBezier(startX, startY, controlX, controlY, endX, endY);
    }
}