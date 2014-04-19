  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.validators;

import cadet.validators.IComponentValidator;
import cadet.core.IComponentContainer;import cadet.util.ComponentUtil;class ComponentSiblingValidator implements IComponentValidator
{private var maxSiblingsOfSameType : Int = -1;private var requiredSiblingTypes : Array<Dynamic>;public function new(maxSiblingsOfSameType : Int = -1, requiredSiblingTypes : Array<Dynamic> = null)
    {this.maxSiblingsOfSameType = maxSiblingsOfSameType;this.requiredSiblingTypes = requiredSiblingTypes || [];
    }public function validate(componentType : Class<Dynamic>, parent : IComponentContainer) : Bool{if (maxSiblingsOfSameType != -1) {var numSameTypeSiblings : Int = ComponentUtil.getChildrenOfType(parent, componentType, false).length;if (numSameTypeSiblings >= maxSiblingsOfSameType)                 return false;
        }for (requiredSiblingType in requiredSiblingTypes){var numRequiredSiblings : Int = ComponentUtil.getChildrenOfType(parent, requiredSiblingType, false).length;if (numRequiredSiblings == 0)                 return false;
        }return true;
    }
}