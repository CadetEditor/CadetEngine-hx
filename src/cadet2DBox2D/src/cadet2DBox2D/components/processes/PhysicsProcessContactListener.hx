// =================================================================================================    
//
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
package cadet2dbox2d.components.processes;

import cadet2dbox2d.components.processes.B2Body;
import cadet2dbox2d.components.processes.B2ContactListener;
import cadet2dbox2d.components.processes.B2ContactResult;
import cadet2dbox2d.components.processes.PhysicsCollisionEvent;
import cadet2dbox2d.components.processes.Point;
import box2d.dynamics.contacts.B2ContactResult;
import box2d.dynamics.B2Body;
import box2d.dynamics.B2ContactListener;
import nme.geom.Point;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;
import cadet2dbox2d.events.PhysicsCollisionEvent;

class PhysicsProcessContactListener extends B2ContactListener
{
	private var physicsProcess : PhysicsProcess;
	
	public function new(physicsProcess : PhysicsProcess)
    {
        super();
		this.physicsProcess = physicsProcess;
    }
	
	override public function Result(result : B2ContactResult) : Void
	{
		var bodyA : B2Body = result.shape1.GetBody();
		var bodyB : B2Body = result.shape2.GetBody();
		var behaviourA : RigidBodyBehaviour = physicsProcess.getBehaviourForRigidBody(bodyA);
		var behaviourB : RigidBodyBehaviour = physicsProcess.getBehaviourForRigidBody(bodyB);
		physicsProcess.dispatchEvent(new PhysicsCollisionEvent(PhysicsCollisionEvent.COLLISION, behaviourA, behaviourB, new Point(result.position.x * physicsProcess.invScaleFactor, result.position.y * physicsProcess.invScaleFactor), new Point(result.normal.x, result.normal.y), result.normalImpulse, result.normalImpulse));
    }
}