// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.events;

import nme.events.Event;
import cadet.core.IComponent;

class ComponentEvent extends Event
{
    public var component(get, never) : IComponent;
	public static inline var ADDED_TO_PARENT : String = "addedToParent";
	public static inline var REMOVED_FROM_PARENT : String = "removedFromParent";
	public static inline var ADDED_TO_SCENE : String = "addedToScene";
	public static inline var REMOVED_FROM_SCENE : String = "removedFromScene";
	private var _component : IComponent;
	
	public function new(type : String, component : IComponent)
    {
		super(type);
		_component = component;
    }
	
	private function get_Component() : IComponent
	{
		return _component;
    }
	
	override public function clone() : Event
	{
		return new ComponentEvent(type, _component);
    }
}