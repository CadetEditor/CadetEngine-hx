// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.components.lights;

import cadet3d.components.lights.DirectionalLight;
import away3d.lights.DirectionalLight;

class DirectionalLightComponent extends AbstractLightComponent
{
	public function new()
	{
		super();
		_object3D = _light = new DirectionalLight();
		castsShadows = true;
	}
}