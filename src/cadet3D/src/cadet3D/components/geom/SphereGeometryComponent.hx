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

import cadet3d.components.geom.SphereGeometry;
import away3d.core.base.Geometry;
import away3d.primitives.CubeGeometry;
import away3d.primitives.SphereGeometry;
import cadet.core.Component;

class SphereGeometryComponent extends AbstractGeometryComponent
{
	public var radius(get, set) : Float;
	public var segmentsW(get, set) : Float;
	public var segmentsH(get, set) : Float;
	private var sphereGeom : SphereGeometry;
	
	public function new()
	{
		super();
		_geometry = sphereGeom = new SphereGeometry();
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="100",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
	private function get_radius() : Float
	{
		return sphereGeom.radius;
	}
	
	private function set_radius(value : Float) : Float
	{
		sphereGeom.radius = value;
		sphereGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="101",editor="NumberInput",min="4",max="256",numDecimalPlaces="0"))
	private function get_segmentsW() : Float
	{
		return sphereGeom.segmentsW;
	}
	
	private function set_segmentsW(value : Float) : Float
	{
		sphereGeom.segmentsW = value;
		sphereGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="102",editor="NumberInput",min="4",max="256",numDecimalPlaces="0"))
	private function get_segmentsH() : Float
	{
		return sphereGeom.segmentsH;
	}
	
	private function set_segmentsH(value : Float) : Float
	{
		sphereGeom.segmentsH = value;
		sphereGeom.subGeometries;  // Trigger validatation  
		invalidate(GEOMETRY);
		return value;
	}
}