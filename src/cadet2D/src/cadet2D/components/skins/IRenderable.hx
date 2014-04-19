  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.skins;

import cadet.core.IComponent;import starling.display.DisplayObject;interface IRenderable extends IComponent
{
    var indexStr(get, never) : String;
// Ties this implementation to Starling
}