// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.renderers;

import cadet2d.components.renderers.DisplayObject;
import cadet2d.components.renderers.IRenderer;
import cadet2d.components.renderers.Matrix;
import cadet2d.components.renderers.Point;
import nme.display.DisplayObject;
import nme.geom.Matrix;
import nme.geom.Point;
import cadet.core.IRenderer;
interface IRenderer2D extends IRenderer
{
	//need to return Object rather than Sprite because of Starling implementation  
	//function get worldContainer():Sprite; 
	function worldToViewport(pt : Point) : Point;
	function viewportToWorld(pt : Point) : Point;
	function enable(parent : DisplayObject) : Void;
	function disable() : Void;
	function setWorldContainerTransform(m : Matrix) : Void;
}