// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Abstract  

package cadet3d.components.lights;

import cadet3d.components.lights.LightBase;
import cadet3d.components.lights.ObjectContainer3DComponent;
import away3d.lights.LightBase;
import cadet3d.components.core.ObjectContainer3DComponent;

class AbstractLightComponent extends ObjectContainer3DComponent
{
	public var light(get, never) : LightBase;
	public var castsShadows(get, set) : Bool;
	public var ambient(get, set) : Float;
	public var diffuse(get, set) : Float;
	public var specular(get, set) : Float;
	public var color(get, set) : Int;
	public var ambientColor(get, set) : Int;
	private var _light : LightBase;
	
	public function new()
	{
		super();
	}
	
	private function get_light() : LightBase
	{
		return _light;
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="150"))
	private function get_castsShadows() : Bool
	{
		return _light.castsShadows;
	}
	
	private function set_castsShadows(value : Bool) : Bool
	{
		_light.castsShadows = value;
		return value;
	}  
	
	/**
	 * The ambient emission strength of the light.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="151",editor="Slider",min="0",max="1",snapInterval="0.01"))
	private function get_ambient() : Float
	{
		return _light.ambient;
	}
	
	private function set_ambient(value : Float) : Float
	{
		_light.ambient = value;
		return value;
	}  
	
	/**
	 * The diffuse emission strength of the light.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="152",editor="Slider",min="0",max="10",snapInterval="0.1"))
	private function get_diffuse() : Float
	{
		return _light.diffuse;
	}
	
	private function set_diffuse(value : Float) : Float
	{
		_light.diffuse = value;
		return value;
	}  
	
	/**
	 * The specular emission strength of the light.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="153",editor="Slider",min="0",max="1",snapInterval="0.01"))
	private function get_specular() : Float
	{
		return _light.specular;
	}
	
	private function set_specular(value : Float) : Float
	{
		_light.specular = value;
		return value;
	}  
	
	/**
	 * The color of the light.
	 */  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="154",editor="ColorPicker"))
	private function get_color() : Int
	{
		return _light.color;
	}
	
	private function set_color(value : Int) : Int
	{
		light.color = value;
		return value;
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="155",editor="ColorPicker"))
	private function get_ambientColor() : Int
	{
		return _light.ambientColor;
	}
	
	private function set_ambientColor(value : Int) : Int
	{
		_light.ambientColor = value;
		return value;
	}
}