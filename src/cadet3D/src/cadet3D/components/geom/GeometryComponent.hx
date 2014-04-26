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

import cadet3d.components.geom.Event;
import away3d.core.base.Geometry;
import cadet.core.Component;
import nme.events.Event;

class GeometryComponent extends AbstractGeometryComponent
{
	public var geometry(never, set) : Geometry;
	
	public function new()
	{
		super();
	}
	
	@:meta(Serializable(type="resource"))
	@:meta(Inspectable(editor="ResourceItemEditor"))
	private function set_geometry(value : Geometry) : Geometry
	{
		if (value == _geometry) return;
		_geometry = value || new Geometry();
		dispatchEvent(new Event(Event.CHANGE));
		return value;
	}
}