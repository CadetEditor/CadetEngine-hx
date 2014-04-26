// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.PhysicsCollisionEvent;
import nme.geom.Point;
import cadet.core.Component;
import cadet2dbox2d.components.processes.PhysicsProcess;
import cadet2dbox2d.events.PhysicsCollisionEvent;  

/**
 * This behaviour listens to the PhysicsProcess for COLLISION events.
 * When one happens, it calls a virtual function passing through the details. You should extends this class and
 * override the virtual function with custom logic.
 * 
 * This behaviour also makes sure that the onCollision virtual function isn't called until the validation phase.
 * This is required because Box2D 'locks' the ability to create or destroy rigid bodies during a collision callback.
 * Because most behaviours will probably want to make some changes to the physics scene when collisions occur, this behaviour
 * makes sure that the onCollision function is called at a 'safe' point.
 * @author Jonathan
 * 
 */  

class RigidBodyCollisionDetectBehaviour extends Component
{
    public var physicsProcess(never, set) : PhysicsProcess;
    public var collisionsEnabled(get, set) : Bool;
	private static inline var COLLISIONS : String = "collisions";
	private var _physicsProcess : PhysicsProcess;
	public var behaviourA : RigidBodyBehaviour;
	private var collisions : Array<Dynamic>;
	private var _collisionsEnabled : Bool = true;
	
	public function new()
    {
        super();
		name = "RigidBodyCollisionDetectBehaviour";
		collisions = [];
    }
	
	override private function addedToScene() : Void
	{
		addSceneReference(PhysicsProcess, "physicsProcess");
		addSiblingReference(RigidBodyBehaviour, "behaviourA");
    }
	
	private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess
	{
		if (_physicsProcess != null && _collisionsEnabled) {
			_physicsProcess.removeEventListener(PhysicsCollisionEvent.COLLISION, collisionHandler);
        }
		_physicsProcess = value;
		if (_physicsProcess != null && _collisionsEnabled) {
			_physicsProcess.addEventListener(PhysicsCollisionEvent.COLLISION, collisionHandler);
        }
        return value;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_CollisionsEnabled(value : Bool) : Bool
	{
		if (value == _collisionsEnabled) return;
		_collisionsEnabled = value;
		
		if (_physicsProcess == null) return;
		if (_collisionsEnabled) {
			_physicsProcess.addEventListener(PhysicsCollisionEvent.COLLISION, collisionHandler);
        } else {
			_physicsProcess.removeEventListener(PhysicsCollisionEvent.COLLISION, collisionHandler);
        }
        return value;
    }
	
	private function get_CollisionsEnabled() : Bool
	{
		return _collisionsEnabled;
    }
	
	private function collisionHandler(event : PhysicsCollisionEvent) : Void
	{
		if (event.behaviourA == behaviourA) {
			collisions.push([event.behaviourB, event.position, event.normal, event.normalImpulse, event.tangentImpulse]);
			invalidate(COLLISIONS);
        } else if (event.behaviourB == behaviourA) {
			collisions.push([event.behaviourA, event.position, new Point( -event.normal.x, -event.normal.y), event.normalImpulse, event.tangentImpulse]);
			invalidate(COLLISIONS);
        }
    }
	
	override public function validateNow() : Void
	{
		if (isInvalid(COLLISIONS)) {
			validateCollisions();
        }
		super.validateNow();
    }
	
	private function validateCollisions() : Void
	{
		var L : Int = collisions.length;
		while (L-- > 0) {
			var collisionArgs : Array<Dynamic> = collisions.pop();
			onCollision.apply(this, collisionArgs);
        }
    }
	
	private function onCollision(behaviourB : RigidBodyBehaviour, position : Point, normal : Point, normalImpulse : Float, tangentImpulse : Float) : Void
	{
		dispatchEvent(new PhysicsCollisionEvent(PhysicsCollisionEvent.COLLISION, behaviourA, behaviourB, position, normal, normalImpulse, tangentImpulse));
    }
}