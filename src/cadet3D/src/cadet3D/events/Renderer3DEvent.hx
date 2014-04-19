// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.events;

import cadet3d.events.Event;
import nme.events.Event;class Renderer3DEvent extends Event
{public static inline var PRE_RENDER : String = "preRender";public static inline var POST_RENDER : String = "postRender";public function new(type : String)
    {super(type);
    }override public function clone() : Event{return new Renderer3DEvent(type);
    }
}