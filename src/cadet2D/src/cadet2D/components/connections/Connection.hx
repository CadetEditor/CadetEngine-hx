// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 100-149  

package cadet2d.components.connections;

import cadet2d.components.connections.Component;
import cadet2d.components.connections.Transform2D;
import cadet2d.components.connections.ValidationEvent;
import cadet2d.components.connections.Vertex;
import cadet.core.Component;
import cadet.events.ValidationEvent;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.Vertex;

class Connection extends Component
{
    public var transformA(get, set) : Transform2D;
    public var transformB(get, set) : Transform2D;
    public var localPosA(get, set) : Vertex;
    public var localPosB(get, set) : Vertex;
    public var label(get, never) : String;
	private static inline var TRANSFORM : String = "transform";
	private var _transformA : Transform2D;
	private var _transformB : Transform2D;
	private var _localPosA : Vertex;
	private var _localPosB : Vertex;
	
	public function new(name : String = "Connection")
    {
		super(name);
		_localPosA = new Vertex(0, 0);
		_localPosB = new Vertex(0, 0);
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="100"))
	private function set_TransformA(value : Transform2D) : Transform2D
	{
		if (_transformA != null) {
			_transformA.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		_transformA = value;
		if (_transformA != null) {
			_transformA.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_TransformA() : Transform2D
	{
		return _transformA;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="101"))
	private function set_TransformB(value : Transform2D) : Transform2D
	{
		if (_transformB != null) {
			_transformB.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		_transformB = value;
		if (_transformB != null) {
			_transformB.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_TransformB() : Transform2D
	{
		return _transformB;
    }
	
	@:meta(Serializable())
	private function set_LocalPosA(value : Vertex) : Vertex
	{
		_localPosA = value;
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_LocalPosA() : Vertex
	{
		return _localPosA;
    }
	
	@:meta(Serializable())
	private function set_LocalPosB(value : Vertex) : Vertex
	{
		_localPosB = value;
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_LocalPosB() : Vertex
	{
		return _localPosB;
    }
	
	private function invalidateTransformHandler(event : ValidationEvent) : Void
	{
		invalidate(TRANSFORM);
    }
	
	private function get_Label() : String
	{
		return "Connection";
    }
}