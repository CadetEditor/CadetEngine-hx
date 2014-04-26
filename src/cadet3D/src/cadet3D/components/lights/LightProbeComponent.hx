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

import cadet3d.components.lights.AbstractCubeTextureComponent;
import cadet3d.components.lights.LightProbe;
import cadet3d.components.lights.ValidationEvent;
import away3d.lights.LightProbe;
import cadet.events.ValidationEvent;
import cadet3d.components.textures.AbstractCubeTextureComponent;
import cadet3d.util.NullBitmapCubeTexture;

class LightProbeComponent extends AbstractLightComponent
{
	public var diffuseMap(get, set) : AbstractCubeTextureComponent;
	private var _lightProbe : LightProbe;
	private var _diffuseMap : AbstractCubeTextureComponent;
	
	public function new()
	{
		super();
		_object3D = _light = _lightProbe = new LightProbe(NullBitmapCubeTexture.instance, NullBitmapCubeTexture.instance);
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="200",editor="ComponentList",scope="scene"))
	private function set_diffuseMap(value : AbstractCubeTextureComponent) : AbstractCubeTextureComponent
	{
		if (_diffuseMap != null) {
			_diffuseMap.removeEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseMapHandler);
		}
		_diffuseMap = value;
		if (_diffuseMap != null) {
			_diffuseMap.addEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseMapHandler);
		}
		updateDiffuseMap();
		return value;
	}
	
	private function get_diffuseMap() : AbstractCubeTextureComponent
	{
		return _diffuseMap;
	}
	
	private function invalidateDiffuseMapHandler(event : ValidationEvent) : Void
	{
		updateDiffuseMap();
	}
	
	private function updateDiffuseMap() : Void
	{
		if (_diffuseMap != null) {
			_lightProbe.diffuseMap = _diffuseMap.cubeTexture;
		} else {
			_lightProbe.diffuseMap = NullBitmapCubeTexture.instance;
		}
	}
}