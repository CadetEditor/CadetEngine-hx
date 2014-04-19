package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.RigidBodyBehaviour;
import box2d.dynamics.B2Body;import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;class ApplyTorqueBehaviour extends Component implements ISteppableComponent
{public var rigidBodyBehaviour : RigidBodyBehaviour;public var torque : Float;public var targetVelocity : Float;public function new(torque : Float = 50, targetVelocity : Float = 2)
    {
        super();this.torque = torque;this.targetVelocity = targetVelocity;
    }override private function addedToScene() : Void{addSiblingReference(RigidBodyBehaviour, "rigidBodyBehaviour");
    }public function step(dt : Float) : Void{  // If we're not attached to an Entity with a RigidBodyBehaviour, then skip.  if (rigidBodyBehaviour == null)             return  // Calculate a ratio where 0.5 means we're spinning at half the target speed, and 1 means full speed.  ;var ratio : Float = rigidBodyBehaviour.getAngularVelocity() / targetVelocity;  // Scale the torque value by the opposite of the ratio, so as we near the target    // velocity, we reduce the amount of torque applied.  rigidBodyBehaviour.applyTorque((1 - ratio) * torque);
    }
}