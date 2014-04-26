// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.components.geom;

import cadet3d.components.geom.CubeGeometry;
import away3d.primitives.CubeGeometry;

class CubeGeometryComponent extends AbstractGeometryComponent
{
	public var width(get, set) : Float;
	public var height(get, set) : Float;
	public var depth(get, set) : Float;
	public var segmentsW(get, set) : Float;
	public var segmentsH(get, set) : Float;
	public var segmentsD(get, set) : Float;
	public var tile6(get, set) : Bool;
	private var cubeGeom : CubeGeometry;
	
	public function new(width : Float = 100, height : Float = 100, depth : Float = 100)
	{
		super();
		_geometry = cubeGeom = new CubeGeometry();
		this.width = width;
		this.height = height;
		this.depth = depth;
	}  
	
	/**
	 * The size of the cube along its X-axis.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="100",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
	private function get_width() : Float
	{
		return cubeGeom.width;
	}
	
	private function set_width(value : Float) : Float
	{
		cubeGeom.width = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The size of the cube along its Y-axis.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="101",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
	private function get_height() : Float
	{
		return cubeGeom.height;
	}
	
	private function set_height(value : Float) : Float
	{
		cubeGeom.height = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The size of the cube along its Z-axis.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="102",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
	private function get_depth() : Float
	{
		return cubeGeom.depth;
	}
	
	private function set_depth(value : Float) : Float
	{
		cubeGeom.depth = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The number of segments that make up the cube along the X-axis. Defaults to 1.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="103",editor="NumberInput",min="1",max="128",numDecimalPlaces="0"))
	private function get_segmentsW() : Float
	{
		return cubeGeom.segmentsW;
	}
	
	private function set_segmentsW(value : Float) : Float
	{
		cubeGeom.segmentsW = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The number of segments that make up the cube along the Y-axis. Defaults to 1.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="104",editor="NumberInput",min="1",max="128",numDecimalPlaces="0"))
	private function get_segmentsH() : Float
	{
		return cubeGeom.segmentsH;
	}
	
	private function set_segmentsH(value : Float) : Float
	{
		cubeGeom.segmentsH = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The number of segments that make up the cube along the Z-axis. Defaults to 1.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="105",editor="NumberInput",min="1",max="128",numDecimalPlaces="0"))
	private function get_segmentsD() : Float
	{
		return cubeGeom.segmentsD;
	}
	
	private function set_segmentsD(value : Float) : Float
	{
		cubeGeom.segmentsD = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}  
	
	/**
	 * The type of uv mapping to use. When true, a texture will be subdivided in a 2x3 grid, each used for a single
	 * face. When false, the entire image is mapped on each face.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="106"))
	private function get_tile6() : Bool
	{
		return cubeGeom.tile6;
	}
	
	private function set_tile6(value : Bool) : Bool
	{
		cubeGeom.tile6 = value;
		cubeGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}
}