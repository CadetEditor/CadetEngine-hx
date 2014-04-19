// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.util;

import cadet.util.ComponentContainerEvent;
import cadet.util.Dictionary;
import cadet.util.IComponent;
import cadet.util.IComponentContainer;
import nme.utils.Dictionary;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.events.ComponentContainerEvent;
import cadet.util.ComponentUtil;

class ComponentReferenceUtil
{
	private static var hostTable : Dictionary = new Dictionary();
	
	public static function addReferenceByType(target : IComponentContainer, type : Class<Dynamic>, host : IComponent, property : String, excludedTypes : Array<Class<Dynamic>> = null) : Void
	{
		var reference : Reference = new Reference(target, type, host, property, excludedTypes);
		var references : Array<Dynamic> = Reflect.field(hostTable, Std.string(host));
		if (references == null) {
			Reflect.setField(hostTable, Std.string(host), references = []);
        }
		references[references.length] = reference;
    }
	
	public static function removeReferenceByType(target : IComponentContainer, type : Class<Dynamic>, host : IComponent, property : String) : Void
	{
		var references : Array<Dynamic> = Reflect.field(hostTable, Std.string(host));
		if (references == null) return;
		var L : Int = references.length;
		
		for (i in 0...L) { 
			var reference : Reference = references[i];
			
			if (reference.target != target) {
				continue;
            }
			
			if (reference.property != property) {
				continue;
            }
			
			if (reference.type != type) {
				continue;
            }
			
			references.splice(i, 1);
			return;
        }
    }
	
	public static function removeAllReferencesForHost(host : IComponent) : Void
	{
		var references : Array<Dynamic> = Reflect.field(hostTable, Std.string(host));
		if (references == null) return;
		for (reference in references) {
			reference.dispose();
        }
		Reflect.setField(hostTable, Std.string(host), null);
    }

    public function new()
    {
    }
}

class Reference
{	
	public var type : Class<Dynamic>;
	public var host : IComponent;
	public var property : String;
	public var target : IComponentContainer;
	private var _excludedComponents : Array<IComponent>;
	private var _excludedTypes : Array<Class<Dynamic>>;
	
	@:allow(cadet.util)
    private function new(target : IComponentContainer, type : Class<Dynamic>, host : IComponent, property : String, excludedTypes : Array<Class<Dynamic>> = null)
    {
		init(target, type, host, property, excludedTypes);
    }
	
	public function init(target : IComponentContainer, type : Class<Dynamic>, host : IComponent, property : String, excludedTypes : Array<Class<Dynamic>> = null) : Void
	{
		this.target = target;
		this.type = type; 
		this.host = host;
		this.property = property;
		target.addEventListener(ComponentContainerEvent.CHILD_ADDED, childAddedHandler);
		target.addEventListener(ComponentContainerEvent.CHILD_REMOVED, childRemovedHandler);
		_excludedComponents = new Array<IComponent>();
		_excludedComponents.push(host);
		_excludedTypes = excludedTypes;
		Reflect.setField(host, property, ComponentUtil.getChildOfType(target, type, false, _excludedComponents, _excludedTypes));
    }
	
	public function dispose() : Void
	{
		target.removeEventListener(ComponentContainerEvent.CHILD_ADDED, childAddedHandler);
		target.removeEventListener(ComponentContainerEvent.CHILD_REMOVED, childRemovedHandler);
		Reflect.setField(host, property, null);
		target = null;
		host = null;
		type = null;
		property = null;
    }
	
	private function childAddedHandler(event : ComponentContainerEvent) : Void
	{
		if (Std.is(event.child, type) && !ComponentUtil.isExcluded(event.child, _excludedComponents, _excludedTypes)) {
			Reflect.setField(host, property, event.child);
        }
    }
	
	private function childRemovedHandler(event : ComponentContainerEvent) : Void
	{  
		// Presumes there will only be one sibling of a type  
		if (Std.is(event.child, type) && !ComponentUtil.isExcluded(event.child, _excludedComponents, _excludedTypes)) {
			Reflect.setField(host, property, null);
        }
    }
}