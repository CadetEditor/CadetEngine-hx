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

import cadet2dbox2d.components.behaviours.B2DistanceJointDef;
import cadet2dbox2d.components.behaviours.B2Joint;
import cadet2dbox2d.components.behaviours.B2Vec2;
import cadet2dbox2d.components.behaviours.Component;
import cadet2dbox2d.components.behaviours.Connection;
import cadet2dbox2d.components.behaviours.Event;
import cadet2dbox2d.components.behaviours.IJoint;
import cadet2dbox2d.components.behaviours.PhysicsProcess;
import cadet2dbox2d.components.behaviours.Point;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;
import cadet2dbox2d.components.behaviours.ValidationEvent;
import nme.events.Event;
import nme.geom.Point;
import box2d.common.math.B2Vec2;
import box2d.dynamics.joints.B2DistanceJointDef;
import box2d.dynamics.joints.B2Joint;
import cadet.core.Component;
import cadet.events.ComponentEvent;
import cadet.events.ValidationEvent;
import cadet.util.ComponentUtil;
import cadet2d.components.connections.Connection;
import cadet2dbox2d.components.processes.PhysicsProcess;

class DistanceJointBehaviour extends Component implements IJoint
{
    public var connection(get, set) : Connection;
    public var physicsProcess(get, set) : PhysicsProcess;
	// Invalidation types  
	private static inline var JOINT : String = "joint";
	private static inline var BEHAVIOURS : String = "behaviours";
	private var _connection : Connection;
	private var _physicsProcess : PhysicsProcess;
	private var joint : B2Joint;
	private var physicsBehaviourA : RigidBodyBehaviour;
	private var physicsBehaviourB : RigidBodyBehaviour;
	
	@:meta(Serializable())
	public var length : Float = -1;
	
	@:meta(Serializable())
	@:meta(Inspectable())
	public var damping : Float = 0.5;
	
	@:meta(Serializable())
	@:meta(Inspectable())
	public var collideConnected : Bool = true;
	
	public function new()
    {
        super();
		name = "DistanceJointBehaviour";
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(Connection, "connection");
		addSceneReference(PhysicsProcess, "physicsProcess");
    }
	
	override private function removedFromScene() : Void
	{
		destroyJoint();
    }
	
	private function set_Connection(value : Connection) : Connection
	{
		destroyJoint();
		if (_connection != null) {
			_connection.removeEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);
			_connection.removeEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
			_connection.removeEventListener(ValidationEvent.INVALIDATE, connectionChangeHandler);
        }
		_connection = value;
		if (_connection != null) {
			_connection.addEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);
			_connection.addEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
			_connection.addEventListener(ValidationEvent.INVALIDATE, connectionChangeHandler);
        }
		invalidate(BEHAVIOURS);invalidate(JOINT);
        return value;
    }
	
	private function get_Connection() : Connection
	{
		return _connection;
    }
	
	private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess
	{
		destroyJoint();
		if (_physicsProcess != null) {
			_physicsProcess.removeEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }
		_physicsProcess = value;
		if (_physicsProcess != null) {
			_physicsProcess.addEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }
		invalidate(JOINT);
        return value;
    }
	
	private function get_PhysicsProcess() : PhysicsProcess
	{
		return _physicsProcess;
    }
	
	private function invalidatePhysicsProcessHandler(event : ValidationEvent) : Void
	{
		invalidate(JOINT);
    }
	
	private function connectionChangeHandler(event : Event) : Void
	{
		invalidate(BEHAVIOURS);
    }
	
	private function destroyJoint() : Void
	{
		if (joint == null) return;
		if (_physicsProcess == null) return;
		_physicsProcess.destroyJoint(joint);
		joint = null;
    }
	
	private function validateBehaviours() : Void
	{
		if (_connection == null) {
			physicsBehaviourA = null;
			physicsBehaviourB = null;
			return;
        }
		
		if (!_connection.transformA) return;
		if (!_connection.transformB) return;
		if (!_connection.transformA.parentComponent) return;
		if (!_connection.transformB.parentComponent) return;
		physicsBehaviourA = ComponentUtil.getChildOfType(_connection.transformA.parentComponent, RigidBodyBehaviour);
		physicsBehaviourB = ComponentUtil.getChildOfType(_connection.transformB.parentComponent, RigidBodyBehaviour);
    }
	
	private function validateJoint() : Void
	{
		if (!_scene) return;
		if (physicsBehaviourA == null) return;
		if (physicsBehaviourB == null) return;
		if (_physicsProcess == null) return;
		physicsBehaviourA.validateNow(); 
		physicsBehaviourB.validateNow(); 
		var jointDef : B2DistanceJointDef = new B2DistanceJointDef(); 
		jointDef.dampingRatio = damping; 
		jointDef.collideConnected = collideConnected; 
		jointDef.frequencyHz = 0.5; 
		var pt1 : Point = _connection.transformA.matrix.transformPoint(connection.localPosA.toPoint()); 
		var pt2 : Point = _connection.transformB.matrix.transformPoint(connection.localPosB.toPoint()); 
		var posA : B2Vec2 = new B2Vec2(pt1.x * _physicsProcess.scaleFactor, pt1.y * _physicsProcess.scaleFactor); 
		var posB : B2Vec2 = new B2Vec2(pt2.x * _physicsProcess.scaleFactor, pt2.y * _physicsProcess.scaleFactor); 
		jointDef.Initialize(physicsBehaviourA.getBody(), physicsBehaviourB.getBody(), posA, posB); 
		if (length != -1) jointDef.length = length; 
		joint = _physicsProcess.createJoint(jointDef);
    }
	
	override public function validateNow() : Void
	{
		if (isInvalid(BEHAVIOURS)) {
			validateBehaviours();
        }
		
		if (isInvalid(JOINT)) {
			validateJoint();
        }
		
		super.validateNow();
    }
}