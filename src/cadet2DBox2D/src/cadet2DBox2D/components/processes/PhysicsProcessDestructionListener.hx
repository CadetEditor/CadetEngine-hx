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

import cadet2dbox2d.components.processes.B2DestructionListener;
import cadet2dbox2d.components.processes.B2Joint;
import box2d.dynamics.joints.B2Joint;
import box2d.dynamics.B2DestructionListener;

class PhysicsProcessDestructionListener extends B2DestructionListener
{
	private var process : PhysicsProcess;
	
	public function new(process : PhysicsProcess)
    {
        super();
		this.process = process;
    }
	
	override public function SayGoodbyeJoint(joint : B2Joint) : Void
	{
		process.jointDestroyed(joint);
    }
}