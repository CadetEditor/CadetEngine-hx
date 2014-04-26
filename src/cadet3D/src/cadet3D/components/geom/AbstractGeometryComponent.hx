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

import cadet3d.components.geom.Component;
import cadet3d.components.geom.Geometry;
import cadet3d.components.geom.IGeometry;
import away3d.core.base.Geometry;
import cadet.components.geom.IGeometry;
import cadet.core.Component;

class AbstractGeometryComponent extends Component implements IGeometry
{
	public var geometry(get, never) : Geometry;
	// Invalidation types
	private var GEOMETRY : String = "geometry";
	private var _geometry : Geometry;
	
	public function new()
	{
		super();
		_geometry = new Geometry();
	}
	
	private function get_geometry() : Geometry
	{
		return _geometry;
	}
}