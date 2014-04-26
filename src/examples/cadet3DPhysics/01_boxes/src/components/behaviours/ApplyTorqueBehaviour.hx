package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.RigidBodyBehaviour;
import components.behaviours.Vector3D;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet3dphysics.components.behaviours.RigidBodyBehaviour;
import nme.geom.Vector3D;

class ApplyTorqueBehaviour extends Component implements ISteppableComponent
{
	public var rigidBodyBehaviour : RigidBodyBehaviour;
	public var torque : Float;
	public var targetVelocity : Vector3D;
	
	public function new(torque : Float = 50, targetVelocity : Vector3D = null)
	{
		super();
		this.torque = torque;
		if (targetVelocity == null) {
			targetVelocity = new Vector3D(2, 0, 0);
		}
		this.targetVelocity = targetVelocity;
	}
	
	override private function addedToParent() : Void
	{
		addSiblingReference(RigidBodyBehaviour, "rigidBodyBehaviour");
	}
	
	public function step(dt : Float) : Void
	{  
		// If we're not attached to an Entity with a RigidBodyBehaviour, then skip.  
		if (rigidBodyBehaviour == null) return;
		var angularVelocity : Vector3D = rigidBodyBehaviour.getAngularVelocity();
		if (angularVelocity == null) return;  
		// Calculate a ratio where 0.5 means we're spinning at half the target speed, and 1 means full speed.  
		var ratio : Float = angularVelocity.x / targetVelocity.x;  
		// Scale the torque value by the opposite of the ratio, so as we near the target    
		// velocity, we reduce the amount of torque applied.  
		rigidBodyBehaviour.applyTorque(new Vector3D((1 - ratio) * torque));
	}
}