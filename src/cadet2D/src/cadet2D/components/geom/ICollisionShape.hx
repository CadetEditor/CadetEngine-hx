// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.geom;

import cadet.core.IComponent;
import cadet2d.components.transforms.Transform2D;

interface ICollisionShape extends IComponent
{
    var transform(get, never) : Transform2D;
}