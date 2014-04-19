  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.behaviours;

import cadet2d.components.behaviours.IComponent;
import cadet.core.IComponent;interface IFootprint extends IComponent
{
    var x(get, never) : Int;    var y(get, never) : Int;    var sizeX(get, never) : Int;    var sizeY(get, never) : Int;    var values(get, never) : Array<Dynamic>;

}