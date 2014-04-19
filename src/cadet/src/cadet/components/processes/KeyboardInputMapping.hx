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

import cadet.components.processes.Component;
import cadet.components.processes.PropertyChangeEvent;
import cadet.core.Component;
import core.events.PropertyChangeEvent;

class KeyboardInputMapping extends Component implements IInputMapping
{
    public var input(get, set) : String;
	private static var KEY_CODE_TABLE : Dynamic = {
		UP : 38,
		DOWN : 40,
		LEFT : 37,
		RIGHT : 39,
		SPACE : 32,
		ENTER : 13,
		0 : 48,
		1 : 49,
		2 : 50,
		3 : 51,
		4 : 52,
		5 : 53,
		6 : 54,
		7 : 55,
		8 : 56,
		9 : 67
	};
		
	private static var INPUT_TABLE : Dynamic = {
		38 : "UP",
		40 : "DOWN",
		37 : "LEFT",
		39 : "RIGHT",
		32 : "SPACE",
		13 : "ENTER",
		48 : "0",
		49 : "1",
		50 : "2",
		51 : "3",
		52 : "4",
		53 : "5",
		54 : "6",
		55 : "7",
		56 : "8",
		67 : "9"
	};
	
	private var _input : String;
	public static inline var UP : String = "UP";
	public static inline var DOWN : String = "DOWN";
	public static inline var LEFT : String = "LEFT";
	public static inline var RIGHT : String = "RIGHT";
	public static inline var SPACE : String = "SPACE";
	public static inline var ENTER : String = "ENTER";
	
	public function new(name : String = "KeyboardInputMapping")
    {
		super(name);
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="DropDownMenu",dataProvider="[UP,DOWN,LEFT,RIGHT,SPACE,ENTER,0,1,2,3,4,5,6,7,8,9]"))
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
	
	public function getKeyCode() : Int
	{
		return inputToKeyCode(_input);
    }
	
	public static function inputToKeyCode(input : String) : Int
	{
		return (Reflect.field(KEY_CODE_TABLE, input)) ? Reflect.field(KEY_CODE_TABLE, input) : -1;
    }
	
	public static function keyCodeToInput(keyCode : Int) : String
	{
		return INPUT_TABLE[keyCode];
    }
}