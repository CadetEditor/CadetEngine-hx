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

import cadet.core.IComponent;
import cadet.core.IComponentContainer;

class ComponentUtil
{
	public static function getChildByName(parent : IComponentContainer, name : String) : Dynamic
	{
		for (component/* AS3HX WARNING could not determine type for var: component exp: EField(EIdent(parent),children) type: null */ in parent.children) {
			if (component.name == name) return component;
        }
		return null;
    }
	public static function getChildren(container : IComponentContainer, recursive : Bool = false) : Array<IComponent>
	{
		var children : Array<IComponent> = new Array<IComponent>();
		var L : Int = 0;
		for (component/* AS3HX WARNING could not determine type for var: component exp: EField(EIdent(container),children) type: null */ in container.children) {
			children[L++] = component;
			if (recursive && Std.is(component, IComponentContainer)) {
				children = children.concat(getChildren(cast((component), IComponentContainer), true));
				L = children.length;
            }
        }
		return children;
    }
	
	public static function getChildWithExportTemplateID(container : IComponentContainer, exportTemplateID : String, recursive : Bool = false) : Dynamic
	{
		for (component/* AS3HX WARNING could not determine type for var: component exp: EField(EIdent(container),children) type: null */ in container.children) {
			if (component.exportTemplateID == exportTemplateID) {
				return component;
            }
			if (recursive && Std.is(component, IComponentContainer)) {
				var result : IComponent = getChildWithExportTemplateID(cast((component), IComponentContainer), exportTemplateID, true);
				if (result != null) {
					return result;
                }
            }
        }
		return null;
    }
	
	public static function getChildOfType(container : IComponentContainer, type : Class<Dynamic>, recursive : Bool = false, excludedComponents : Array<IComponent> = null, excludedTypes : Array<Class<Dynamic>> = null) : Dynamic
	{
		for (component/* AS3HX WARNING could not determine type for var: component exp: EField(EIdent(container),children) type: null */ in container.children) {
			if (Std.is(component, type)) {
				var excluded : Bool = isExcluded(component, excludedComponents, excludedTypes);
				if (!excluded) {
					return component;
                }
            }
			if (recursive && Std.is(component, IComponentContainer)) {
				var result : IComponent = getChildOfType(cast((component), IComponentContainer), type, true, excludedComponents, excludedTypes);
				if (result != null) {
					return result;
                }
            }
        }
		return null;
    }
	
	public static function isExcluded(component : IComponent, excludedComponents : Array<IComponent> = null, excludedTypes : Array<Class<Dynamic>> = null) : Bool
	{
		if (excludedComponents != null) { for (i in 0...excludedComponents.length) {
			var child : IComponent = excludedComponents[i];
			if (component == child) {
				return true;
                }
            }
        }
		
		if (excludedTypes != null) {
			for (excludedTypes.length) {
				var type : Class<Dynamic> = excludedTypes[i];
				if (Std.is(component, type)) {
					return true;
                }
            }
        }
		return false;
    }
	
	public static function getChildrenOfType(container : IComponentContainer, type : Class<Dynamic>, recursive : Bool = false) : Array<IComponent>
	{
		var children : Array<IComponent> = new Array<IComponent>();
		for (component/* AS3HX WARNING could not determine type for var: component exp: EField(EIdent(container),children) type: null */ in container.children) {
			if (Std.is(component, type)) {
				children.push(component);
            }
			if (recursive && Std.is(component, IComponentContainer)) {
				children = children.concat(getChildrenOfType(cast((component), IComponentContainer), type, true));
            }
        }
		return children;
    }
	
	public static function getUniqueName(baseName : String, parent : IComponentContainer) : String
	{
		var table : Dynamic = { };
		
		for (child/* AS3HX WARNING could not determine type for var: child exp: EField(EIdent(parent),children) type: null */ in parent.children) {
			table[child.name] = true;
        }
		var uid : Int = 0;
		while (table[baseName + "_" + uid]) {
			uid++;
        }
		var newName : String = baseName + "_" + uid;
		return newName;
    }
	
	public static function getComponentContainers(components : Array<Dynamic>) : Array<IComponentContainer>
	{
		var containers : Array<IComponentContainer> = new Array<IComponentContainer>();
		
		for (i in 0...components.length) {
			var component : IComponent = cast((components[i]), IComponent);
			if (Std.is(component, IComponentContainer)) {
				containers.push(component);
            } else if (component.parentComponent) {
				containers.push(component.parentComponent);
            }
        }
		return containers;
    }

    public function new()
    {
    }
}