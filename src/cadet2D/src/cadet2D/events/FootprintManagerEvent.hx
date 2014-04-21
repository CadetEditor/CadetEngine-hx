// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.events;

import nme.events.Event;

class FootprintManagerEvent extends Event
{
    public var indices(get, never) : Array<Dynamic>;
	public static inline var CHANGE : String = "change";
	private var _indices : Array<Dynamic>;
	
	public function new(type : String, indices : Array<Dynamic>)
    {
		super(type);
		_indices = indices;
    }
	
	override public function clone() : Event
	{
		return new FootprintManagerEvent(type, _indices);
    }
	
	private function get_Indices() : Array<Dynamic>
	{
		return _indices.substring();
    }
}