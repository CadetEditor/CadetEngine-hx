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

import cadet.core.Stage;
import nme.display.Stage;

interface IRenderer extends IComponent
{
    //function get viewport():Sprite;
	var viewportWidth(get, set) : Float;    
	var viewportHeight(get, set) : Float;    
	var mouseX(get, never) : Float;
	var mouseY(get, never) : Float;
	//function enable(parent:DisplayObjectContainer, depth:int = -1):void  
	//function disable(parent:DisplayObjectContainer):void  
	function getNativeStage() : Stage;
	function get initialised() : Bool;
}