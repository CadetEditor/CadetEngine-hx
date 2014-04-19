// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.components.processes;

import cadet.core.Component;
import core.events.PropertyChangeEvent;

class TouchInputMapping extends Component implements IInputMapping
{
    public var input(get, set) : String;
	private var _input : String;
	
	/** Only available for mouse input: the cursor hovers over an object <em>without</em> a 
	*  pressed button. */  

	public static inline var HOVER : String = "HOVER";  
	
	/** The finger touched the screen just now, or the mouse button was pressed. */  
	
	public static inline var BEGAN : String = "BEGAN";  
	
	/** The finger moves around on the screen, or the mouse is moved while the button is 
	*  pressed. */  
	
	public static inline var MOVED : String = "MOVED";  
	
	/** The finger or mouse (with pressed button) has not moved since the last frame. */  
	
	public static inline var STATIONARY : String = "STATIONARY";  
	
	/** The finger was lifted from the screen or from the mouse button. */  
	
	public static inline var ENDED : String = "ENDED";
	
	public static var mappings : Array<Dynamic> = [HOVER, BEGAN, MOVED, STATIONARY, ENDED];
	
	public function new()
    {
		super();
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="DropDownMenu",dataProvider="[HOVER,BEGAN,MOVED,STATIONARY,ENDED]"))
	private function set_Input(value : String) : String
	{
		if (value != null) {
			value = value.toUpperCase();
        }
		_input = value; 
		invalidate("code");
		dispatchEvent(new PropertyChangeEvent("propertyChange_input", null, _input));
        return value;
    }
	
	private function get_Input() : String
	{
		return _input;
    }
}