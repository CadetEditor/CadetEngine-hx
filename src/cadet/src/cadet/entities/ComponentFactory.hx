// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.entities;

import cadet.entities.ComponentParentValidator;
import cadet.entities.ComponentSiblingValidator;
import cadet.entities.FactoryResource;
import cadet.entities.IComponent;
import cadet.entities.IComponentContainer;
import cadet.entities.IComponentValidator;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.assets.CadetEngineIcons;
import cadet.validators.ComponentParentValidator;
import cadet.validators.ComponentSiblingValidator;
import cadet.validators.IComponentValidator;
import core.app.resources.FactoryResource;

class ComponentFactory extends FactoryResource
{
    public var category(get, never) : String;
    public var compatibleContextType(get, never) : Class<Dynamic>;
    public var visible(get, never) : Bool;
	private var _category : String; 
	private var compatibleParentType : Class<Dynamic>;
	private var maxSiblingsOfThisType : Int;
	private var _compatibleContextType : Class<Dynamic>;  
	// If specified during construction, this value indicates the type of context that must be focused for this component to appear in the AddComponent panel.  
	private var _visible : Bool;  
	// If false, will not appear in 'add-component' dialogue.  
	public var validators : Array<IComponentValidator>;
	public function new(type : Class<Dynamic>, label : String, category : String = null, icon : Class<Dynamic> = null, requiredParentType : Class<Dynamic> = null, maxSiblingsOfThisType : Int = -1, requiredSiblingTypes : Array<Dynamic> = null, compatibleContextType : Class<Dynamic> = null, visible : Bool = true)
    {
		super(type, label, icon); 
		_category = category; 
		_icon = icon; _visible = visible;
		validators = new Array<IComponentValidator>();
		if (requiredParentType != null) {
			validators.push(new ComponentParentValidator(requiredParentType));
        } else {
			validators.push(new ComponentParentValidator(IComponentContainer));
        }
		if (maxSiblingsOfThisType != -1 || requiredSiblingTypes != null) {
			validators.push(new ComponentSiblingValidator(maxSiblingsOfThisType, requiredSiblingTypes));
        }
		_compatibleContextType = compatibleContextType;
    }
	
	private function get_Category() : String
	{
		return _category;
    }
	
	override private function get_Icon() : Class<Dynamic>
	{
		if (_icon == null) {
			return CadetEngineIcons.Component;
        }
		return super.icon;
    }
	
	override public function getInstance() : Dynamic
	{
		var instance : IComponent = cast((super.getInstance()), IComponent);
		instance.name = _label;
		return instance;
    }
	
	public function validate(parent : IComponentContainer) : Bool
	{
		for (validator in validators) {
			if (validator.validate(_type, parent) == false) return false;
        }
		return true;
    }
	
	private function get_CompatibleContextType() : Class<Dynamic>
	{
		return _compatibleContextType;
    }
	
	private function get_Visible() : Bool
	{
		return _visible;
    }
}