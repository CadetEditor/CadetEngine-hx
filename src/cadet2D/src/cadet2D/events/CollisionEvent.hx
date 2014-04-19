// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.events;

import cadet2d.events.Event;
import cadet2d.events.ICollisionShape;
import nme.events.Event;import cadet2d.components.geom.ICollisionShape;class CollisionEvent extends Event
{
    public var objectA(get, never) : ICollisionShape;
    public var objectB(get, never) : ICollisionShape;
public static inline var COLLISION : String = "collision";private var _objectA : ICollisionShape;private var _objectB : ICollisionShape;public function new(type : String, objectA : ICollisionShape, objectB : ICollisionShape)
    {super(type, false, false);_objectA = objectA;_objectB = objectB;
    }override public function clone() : Event{return new CollisionEvent(type, _objectA, _objectB);
    }private function get_ObjectA() : ICollisionShape{return _objectA;
    }private function get_ObjectB() : ICollisionShape{return _objectB;
    }
}