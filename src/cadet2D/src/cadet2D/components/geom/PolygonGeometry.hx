// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.geom;

import cadet2d.components.geom.Rectangle;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.Vertex;

import cadet2d.util.VertexUtil;  

/**
 * This class serves a base class for all geometry consisting of a series of points. 
 * @author Jonathan
 * 
 */  

class PolygonGeometry extends AbstractGeometry
{
    public var vertices(get, set) : Array<Dynamic>;
    public var serializedVertices(get, set) : String;
	private var GEOMETRY : String = "geometry";
	private var _vertices : Array<Dynamic>;
	
	public function new(name : String = "PolygonGeometry")
    {
		super(name);
		init();
    }
	
	private function init() : Void
	{
		_vertices = [];
    }
	
	override public function dispose() : Void
	{
		super.dispose();
		init();
    }
	
	private function set_Vertices(value : Array<Dynamic>) : Array<Dynamic>
	{
		_vertices = value;
		invalidate(GEOMETRY);
        return value;
    }
	
	private function get_Vertices() : Array<Dynamic>
	{
		return _vertices;
    }
	
	@:meta(Serializable(alias="vertices"))
	private function set_SerializedVertices(value : String) : String
	{
		var newVertices : Array<Dynamic> = new Array<Dynamic>();
		var split : Array<Dynamic> = value.split(":");
		ar L : Int = split.length;
		for (i in 0...L) {
			var subSplit : Array<Dynamic> = split[i].split(",");
			newVertices[i] = new Vertex(Std.parseFloat(subSplit[0]), Std.parseFloat(subSplit[1]));
        }
		vertices = newVertices;
        return value;
    }
	
	private function get_SerializedVertices() : String
	{
		var output : String = "";
		var L : Int = vertices.length;
		for (i in 0...L) {
			output += vertices[i].x + "," + vertices[i].y;
			if (i != L - 1) {
				output += ":";
            }
        }
		return output;
    }
	
	public function centre(transform : Transform2D, useCentroid : Bool = false) : Void
	{  
		 //var convertToPolygonOperation:ConvertToPolygonOperation = new ConvertToPolygonOperation(polygon);    
		 //addOperation(convertToPolygonOperation);    
		 //polygon = convertToPolygonOperation.getResult();    
		 //var clonedVertices:Array = VertexUtil.copy(polygon.vertices);    
		 //result.vertices = clonedVertices;  
		 
		 var centerX : Float;
		 var centerY : Float;
		 
		 if (useCentroid) {
			 var center : Vertex = VertexUtil.computeCentroid(vertices);
			 centerX = center.x;
			 centerY = center.y;
        } else {
			var bounds : Rectangle = VertexUtil.getBounds(vertices);
			centerX = bounds.x + bounds.width * 0.5;
			centerY = bounds.y + bounds.height * 0.5;
        }
		
		var newVertices : Array<Dynamic> = VertexUtil.copy(vertices);
		var m : Matrix = new Matrix(1, 0, 0, 1, -centerX, -centerY);
		VertexUtil.transform(newVertices, m);
		transformConnections(m, transform);  
		//addOperation( new ChangePropertyOperation( polygon, "vertices", newVertices ) );  
		vertices = newVertices;
		m = new Matrix(transform.matrix.a, transform.matrix.b, transform.matrix.c, transform.matrix.d);
		var pt : Point = new Point(centerX, centerY);
		pt = m.transformPoint(pt);  
		//addOperation( new ChangePropertyOperation( transform, "x", transform.x+pt.x ) );    
		//addOperation( new ChangePropertyOperation( transform, "y", transform.y+pt.y ) );  
		transform.x = transform.x + pt.x;
		transform.y = transform.y + pt.y;
    }
}