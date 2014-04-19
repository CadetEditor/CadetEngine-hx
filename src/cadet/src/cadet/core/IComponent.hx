// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.core;

import cadet.core.IEventDispatcher;
import nme.events.IEventDispatcher;

@:meta(Event(type="cadet.events.ComponentEvent",name="addedToParent"))
@:meta(Event(type="cadet.events.ComponentEvent",name="removedFromParent"))
@:meta(Event(type="cadet.events.ComponentEvent",name="addedToScene"))
@:meta(Event(type = "cadet.events.ComponentEvent", name = "removedFromScene"))

interface IComponent extends IEventDispatcher
{
    var index(never, set) : Int;    
	var scene(never, set) : CadetScene;    
	var exportTemplateID(never, set) : String;
}