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

import cadet3d.resources.MaterialBase;
import away3d.materials.MaterialBase;
import core.app.resources.FactoryResource;
import core.app.resources.IFactoryResource;

class Away3DMaterialResource implements IFactoryResource
{
	private var id : String;
	private var material : MaterialBase;
	
	public function new(id : String, material : MaterialBase)
	{
		this.id = id;
		this.material = material;
	}
	
	public function getLabel() : String
	{
		return "Away3D Material Resource";
	}
	
	public function getInstance() : Dynamic
	{
		return material;
	}
	
	public function getInstanceType() : Class<Dynamic>
	{
		return MaterialBase;
	}
	
	public function getID() : String
	{
		return id;
	}
}