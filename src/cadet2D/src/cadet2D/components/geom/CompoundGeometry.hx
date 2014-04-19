  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.components.geom.ComponentContainer;
import cadet2d.components.geom.ValidationEvent;
import nme.errors.Error;
import cadet.components.geom.IGeometry;import cadet.core.ComponentContainer;import cadet.core.IComponent;import cadet.events.ValidationEvent;class CompoundGeometry extends ComponentContainer implements IGeometry
{
    public var label(get, never) : String;
public function new()
    {
        super();name = "CompoundGeometry";
    }override private function childAdded(child : IComponent, index : Int) : Void{super.childAdded(child, index);if (Std.is(child, IGeometry) == false) {throw (new Error("CompoundGeometry only supports children of type IGeometry"));return;
        }child.addEventListener(ValidationEvent.INVALIDATE, invalidateChildHandler);invalidate("geometry");
    }override private function childRemoved(child : IComponent) : Void{super.childRemoved(child);child.removeEventListener(ValidationEvent.INVALIDATE, invalidateChildHandler);invalidate("geometry");
    }private function invalidateChildHandler(event : ValidationEvent) : Void{invalidate(event.validationType);
    }private function get_Label() : String{return "Compound Geometry";
    }
}