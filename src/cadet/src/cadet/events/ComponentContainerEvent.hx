// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.events;

import cadet.events.Event;
import cadet.events.IComponent;
import nme.events.Event;import cadet.core.IComponent;class ComponentContainerEvent extends Event
{public static inline var CHILD_ADDED : String = "childAdded";public static inline var CHILD_REMOVED : String = "childRemoved";public var child : IComponent;public function new(type : String, child : IComponent)
    {super(type);this.child = child;
    }override public function clone() : Event{return new ComponentContainerEvent(type, child);
    }
}