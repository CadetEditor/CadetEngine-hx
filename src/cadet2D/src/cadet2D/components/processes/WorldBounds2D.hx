  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.processes;

import cadet2d.components.processes.ValidationEvent;
import nme.geom.Rectangle;import cadet.core.Component;import cadet.events.ValidationEvent;class WorldBounds2D extends Component
{
    public var left(get, set) : Float;
    public var right(get, set) : Float;
    public var top(get, set) : Float;
    public var bottom(get, set) : Float;
private static inline var BOUNDS : String = "bounds";private var _left : Float = 0;private var _right : Float = 1000;private var _top : Float = 0;private var _bottom : Float = 1000;private var rect : Rectangle;public function new()
    {super("WorldBounds2D");
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Left(value : Float) : Float{_left = value;invalidate(BOUNDS);
        return value;
    }private function get_Left() : Float{return _left;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Right(value : Float) : Float{_right = value;invalidate(BOUNDS);
        return value;
    }private function get_Right() : Float{return _right;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Top(value : Float) : Float{_top = value;invalidate(BOUNDS);
        return value;
    }private function get_Top() : Float{return _top;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Bottom(value : Float) : Float{_bottom = value;invalidate(BOUNDS);
        return value;
    }private function get_Bottom() : Float{return _bottom;
    }override public function validateNow() : Void{if (isInvalid(BOUNDS)) {validateBounds();dispatchEvent(new ValidationEvent(ValidationEvent.INVALIDATE));
        }super.validateNow();
    }private function validateBounds() : Void{rect = new Rectangle(left, top, right, bottom);
    }public function getRect() : Rectangle{if (rect == null)             validateBounds();return rect;
    }
}