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

import core.data.ArrayCollection;

@:meta(Event(type="cadet.events.ComponentContainerEvent",name="childAdded"))
@:meta(Event(type="cadet.events.ComponentContainerEvent",name="childRemoved"))
interface IComponentContainer extends IComponent
{
    var children(get, never) : ArrayCollection;
}