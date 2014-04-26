// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2dbox2d.events;

import nme.events.Event;

class RigidBodyBehaviourEvent extends Event
{
	public static inline var DESTROY_RIGID_BODY : String = "destroyRigidBody";
	
	public function new(type : String)
    {
		super(type);
    }
}