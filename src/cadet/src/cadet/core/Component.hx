// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 0-49  

package cadet.core;

import cadet.core.EventDispatcher;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.core.ValidationEvent;
import nme.events.EventDispatcher;
import cadet.events.ComponentEvent;
import cadet.events.ValidationEvent;
import cadet.util.ComponentReferenceUtil;
import core.events.PropertyChangeEvent;

@:meta(Event(type="cadet.events.ComponentEvent",name="addedToParent"))
@:meta(Event(type="cadet.events.ComponentEvent",name="removedFromParent"))
@:meta(Event(type="cadet.events.ComponentEvent",name="addedToScene"))
@:meta(Event(type="cadet.events.ComponentEvent",name="removedFromScene"))
@:meta(Event(type="cadet.events.ValidationEvent",name="invalidate"))
@:meta(Event(type = "cadet.events.ValidationEvent", name = "validated"))

/**
* Abstract. This class is not designed to be directly instantiated.
* @author Jonathan
* 
*/  

class Component extends EventDispatcher implements IComponent
{
    public var parentComponent(get, set) : IComponentContainer;
    public var scene(get, set) : CadetScene;
    public var index(get, set) : Int;
    public var name(get, set) : String;
    public var exportTemplateID(get, set) : String;
    public var templateID(get, set) : String;
    public var invalidationTable(get, never) : Dynamic;
	private var _name : String;
	private var _index : Int = -1;
	private var _scene : CadetScene;
	private var _parentComponent : IComponentContainer;
	private var _templateID : String;
	private var _exportTemplateID : String;
	private var addedToSceneEvent : ComponentEvent;
	private var removedFromSceneEvent : ComponentEvent;
	private var addedToParentEvent : ComponentEvent;
	private var removedFromParentEvent : ComponentEvent;
	private var _invalidationTable : Dynamic;
	private var invalidationEvent : ValidationEvent;
	
	public function new(name : String = "Component")
    {
        super();
		this.name = name;  
		// Delegate work to init() function to gain    
		// performance increase from JIT compilation (which ignores constructors).  
		init();
    }
	
	private function init() : Void
	{  
		// Create some event classes that can be re-used.  
		addedToSceneEvent = new ComponentEvent(ComponentEvent.ADDED_TO_SCENE, this);
		removedFromSceneEvent = new ComponentEvent(ComponentEvent.REMOVED_FROM_SCENE, this);
		addedToParentEvent = new ComponentEvent(ComponentEvent.ADDED_TO_PARENT, this);
		removedFromParentEvent = new ComponentEvent(ComponentEvent.REMOVED_FROM_PARENT, this);
		_invalidationTable = { };
		invalidationEvent = new ValidationEvent(ValidationEvent.INVALIDATE);
		invalidate("*");
    }
	
	public function dispose() : Void
	{
		_templateID = null;
		_exportTemplateID = null;
    }
	
	private function addSiblingReference(type : Class<Dynamic>, property : String, excludedTypes : Array<Class<Dynamic>> = null) : Void
	{
		ComponentReferenceUtil.addReferenceByType(_parentComponent, type, this, property, excludedTypes);
    }
	
	private function addSceneReference(type : Class<Dynamic>, property : String, excludedTypes : Array<Class<Dynamic>> = null) : Void
	{
		ComponentReferenceUtil.addReferenceByType(_scene, type, this, property, excludedTypes);
    }
	
	private function set_ParentComponent(value : IComponentContainer) : IComponentContainer
	{
		if (value == _parentComponent) return;
		
		if (_parentComponent != null) {
			removedFromParent();
			ComponentReferenceUtil.removeAllReferencesForHost(this);
			dispatchEvent(removedFromParentEvent);
        }
		
		_parentComponent = value;
		
		if (_parentComponent != null) {
			addedToParent();
			invalidate("*");
			dispatchEvent(addedToParentEvent);
        }
        return value;
    }
	
	private function get_ParentComponent() : IComponentContainer
	{
		return _parentComponent;
    }
	
	private function set_Scene(value : CadetScene) : CadetScene
	{
		if (value == _scene) return;
		if (_scene != null) {
			removedFromScene();
			ComponentReferenceUtil.removeAllReferencesForHost(this);
			dispatchEvent(removedFromSceneEvent);
        }
		_scene = value;
		if (_scene != null) {
			addedToScene();
			invalidate("*");
			dispatchEvent(addedToSceneEvent);
        }
        return value;
    }
	
	private function get_Scene() : CadetScene
	{
		return _scene;
    }
	
	private function set_Index(value : Int) : Int
	{
		_index = value;
        return value;
    }
	
	private function get_Index() : Int
	{
		return _index;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="0"))
	private function set_Name(value : String) : String
	{
		_name = value;dispatchEvent(new PropertyChangeEvent("propertyChange_name", null, _name));
        return value;
    }
	
	private function get_Name() : String
	{
		return _name;
    }
	
	@:meta(Serializable())
	private function set_ExportTemplateID(value : String) : String
	{
		_exportTemplateID = value;
        return value;
    }
	
	private function get_ExportTemplateID() : String
	{
		return _exportTemplateID;
    }
	
	@:meta(Serializable())
	private function set_TemplateID(value : String) : String
	{
		_templateID = value;
        return value;
    }
	
	private function get_TemplateID() : String
	{
		return _templateID;
    }  
	
	// Invalidation methods  
	
	public function invalidate(invalidationType : String) : Void
	{  
		//if ( _invalidationTable[invalidationType] ) return;  
		Reflect.setField(_invalidationTable, invalidationType, true);
		invalidationEvent.validationType = invalidationType;
		dispatchEvent(invalidationEvent);
    }
	
	public function validateNow() : Void
	{
		validate();
		_invalidationTable = { };
    }
	
	private function validateIndex() : Void
	{
		if (parentComponent != null) {
			index = parentComponent.children.getItemIndex(this);
        }
    }
	
	private function validate() : Void
	{
    }
	
	public function isInvalid(type : String) : Bool
	{
		if (Reflect.field(_invalidationTable, "*")) return true;
		
		if (type == "*") {
			for (val/* AS3HX WARNING could not determine type for var: val exp: EIdent(_invalidationTable) type: Dynamic */ in _invalidationTable) {
				return true;
            }
        }
		
		return Reflect.field(_invalidationTable, type) == true;
    }
	
	private function get_InvalidationTable() : Dynamic
	{
		return _invalidationTable;
    }  
	
	// Virtual methods  
	private function addedToParent() : Void
	{
    }
	
	private function removedFromParent() : Void
	{
    }
	
	private function addedToScene() : Void
	{
    }
	
	private function removedFromScene() : Void
	{
    }
}