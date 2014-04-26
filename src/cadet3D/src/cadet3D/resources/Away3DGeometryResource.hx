// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.resources;

import cadet3d.resources.Geometry;
import away3d.core.base.Geometry;
import core.app.resources.FactoryResource;
import core.app.resources.IFactoryResource;

class Away3DGeometryResource implements IFactoryResource
{
	private var id : String;
	private var geometry : Geometry;
	
	public function new(id : String, geometry : Geometry)
	{
		this.id = id;
		this.geometry = geometry;
	}
	
	public function getLabel() : String
	{
		return "Away3D Geometry Resource";
	}
	
	public function getInstance() : Dynamic
	{
		return geometry.clone();
	}
	
	public function getInstanceType() : Class<Dynamic>
	{
		return Geometry;
	}
	
	public function getID() : String
	{
		return id;
	}
}