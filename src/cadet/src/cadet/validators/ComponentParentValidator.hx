// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.validators;

import cadet.validators.IComponentValidator;
import cadet.core.IComponentContainer;

class ComponentParentValidator implements IComponentValidator
{
	private var compatibleParentType : Class<Dynamic>;
	
	public function new(compatibleParentType : Class<Dynamic>)
    {
		this.compatibleParentType = compatibleParentType;
    }
	
	public function validate(componentType : Class<Dynamic>, parent : IComponentContainer) : Bool
	{
		if (Std.is(parent, compatibleParentType) == false) return false;
		return true;
    }
}