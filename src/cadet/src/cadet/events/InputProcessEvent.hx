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

class InputProcessEvent extends Event
{
	public static inline var INPUT_DOWN : String = "inputDown";
	public static inline var INPUT_UP : String = "inputUp";
	public static inline var UPDATE : String = "update";
	public var name : String;
	
	public function new(type : String, name : String)
    {
		super(type);
		this.name = name;
    }
}