// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.events;

import nme.events.Event;

class RendererEvent extends Event
{
	public static inline var INITIALISED : String = "initialised";
	
	public function new(type : String, bubbles : Bool = false, cancelable : Bool = false)
    {
		super(type, bubbles, cancelable);
    }
}