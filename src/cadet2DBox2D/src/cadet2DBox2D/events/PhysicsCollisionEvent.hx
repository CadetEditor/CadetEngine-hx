// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2dbox2d.events;

import cadet2dbox2d.events.Event;
import cadet2dbox2d.events.Point;
import cadet2dbox2d.events.RigidBodyBehaviour;
import nme.events.Event;import nme.geom.Point;import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;class PhysicsCollisionEvent extends Event
{public static inline var COLLISION : String = "collision";public var behaviourA : RigidBodyBehaviour;public var behaviourB : RigidBodyBehaviour;public var position : Point;  // In world space  public var normal : Point;  // Points from A->B;  public var normalImpulse : Float;  // In newtons  public var tangentImpulse : Float;  // In newtons  public function new(type : String, behaviourA : RigidBodyBehaviour, behaviourB : RigidBodyBehaviour, position : Point, normal : Point, normalImpulse : Float, tangentImpulse : Float)
    {super(type);this.behaviourA = behaviourA;this.behaviourB = behaviourB;this.position = position;this.normal = normal;this.normalImpulse = normalImpulse;this.tangentImpulse = tangentImpulse;
    }
}