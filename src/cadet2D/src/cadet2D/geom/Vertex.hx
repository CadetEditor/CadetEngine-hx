// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.geom;

import cadet2d.geom.Point;
import nme.geom.Point;
import core.app.datastructures.ObjectPool;

class Vertex
{
	@:meta(Serializable())
	public var x : Float;
	@:meta(Serializable())
	public var y : Float;
	
	public function new(x : Float = 0, y : Float = 0)
    {
		this.x = x;
		this.y = y;
    }
	
	public function setValues(x : Float, y : Float) : Void
	{
		this.x = x;
		this.y = y;
    }
	
	public function toPoint() : Point
	{
		return new Point(x, y);
    }
	
	public function clone() : Vertex
	{
		var v : Vertex = ObjectPool.getInstance(Vertex);
		v.setValues(x, y);
		return v;
    }
	
	public function toString() : String
	{
		return "{x: " + x + ", y: " + y + "}";
    }
}