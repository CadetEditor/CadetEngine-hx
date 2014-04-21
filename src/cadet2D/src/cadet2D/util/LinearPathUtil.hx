// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.util;

import cadet2d.util.Vertex;
import cadet2d.geom.Vertex;

class LinearPathUtil
{
	public static function weld(vertices : Array<Dynamic>, minimumDistance : Float) : Void
	{
		var L : Int = vertices.length;
		if (L < 3) return;
		var dis : Float = minimumDistance * minimumDistance;
		
		while (true) { 
			if (L < 3) break;
			var found: Bool = false;
			
			for (i in 0...L - 2) {
				var vertexA : Vertex = vertices[i];
				var vertexB : Vertex = vertices[i + 1];
				var dx : Float = vertexB.x - vertexA.x;
				var dy : Float = vertexB.y - vertexA.y;
				var d : Float = dx * dx + dy * dy;
				if (d > dis) {
					continue;
                }
				found = true;
				vertexA.x += dx * 0.5;
				vertexA.y += dy * 0.5;
				vertices.splice(i + 1, 1);
				L--;
            }
			
			if (!found) break;
        }
    }
	
	public static function getLength(vertices : Array<Dynamic>) : Float
	{
		if (vertices.length < 2) return 0;
		var d : Float = 0;
		var prevPos : Vertex = vertices[0];
		
		for (i in 1...vertices.length) {
			var pos : Vertex = vertices[i];
			var dx : Float = pos.x - prevPos.x;
			var dy : Float = pos.y - prevPos.y;
			d += Math.sqrt(dx * dx + dy * dy);
			prevPos = pos;
        }
		
		return d;
    }
	
	public static function evaluate(vertices : Array<Dynamic>, t : Float, output : Vertex) : Vertex
	{
		var L : Int = vertices.length;
		
		if (L == 1) {
			output.x = vertices[0].x;
			output.y = vertices[0].y;
			return output;
        }
		
		var ratio : Float = (t * (L - 1)) % 1;
		var index : Int = t * (L - 1);
		var vertexA : Vertex = vertices[index];
		var vertexB : Vertex = vertices[index + 1];
		output.x = (1 - ratio) * vertexA.x + ratio * vertexB.x; 
		output.y = (1 - ratio) * vertexA.y + ratio * vertexB.y;
		return output;
    }

    public function new()
    {
    }
}