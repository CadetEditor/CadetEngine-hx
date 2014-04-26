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

import cadet2dbox2d.components.processes.B2AABB;
import cadet2dbox2d.components.processes.B2Body;
import cadet2dbox2d.components.processes.B2BodyDef;
import cadet2dbox2d.components.processes.B2Joint;
import cadet2dbox2d.components.processes.B2JointDef;
import cadet2dbox2d.components.processes.B2Vec2;
import cadet2dbox2d.components.processes.B2World;
import cadet2dbox2d.components.processes.Dictionary;
import cadet2dbox2d.components.processes.ISteppableComponent;
import cadet2dbox2d.components.processes.PhysicsProcessContactListener;
import cadet2dbox2d.components.processes.PhysicsProcessDestructionListener;
import cadet2dbox2d.components.processes.RigidBodyBehaviour;
import nme.utils.Dictionary;
import box2d.collision.B2AABB;
import box2d.common.math.B2Vec2;
import box2d.dynamics.B2Body;
import box2d.dynamics.B2BodyDef;
import box2d.dynamics.B2World;
import box2d.dynamics.joints.B2Joint;
import box2d.dynamics.joints.B2JointDef;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;

@:meta(Event(type="cadet.box2D.events.PhysicsCollisionEvent",name="collision"))
class PhysicsProcess extends Component implements ISteppableComponent
{
    public var gravity(get, set) : Float;
    public var scaleFactor(get, set) : Float;
    public var invScaleFactor(get, never) : Float;
    public var world(get, never) : B2World;
	private var _box2D : B2World;
	private var _scaleFactor : Float;
	private var _invScaleFactor : Float;
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="NumericStepper",label="Global iterations",min="1",max="10"))
	public var numIterations : Int = 2;
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="NumericStepper",label="Velocity Iterations",min="1",max="10"))
	public var numVelocityIterations : Int = 2;
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="NumericStepper",label="Position Iterations",min="1",max="10"))
	public var numPositionIterations : Int = 2;
	private var _gravity : Float;
	private var behaviourTable : Dictionary;
	private var jointTable : Dictionary;
	
	public function new(name : String = "PhysicsProcess")
    {
		super(name);
		init();
    }
	
	private function init() : Void
	{
		scaleFactor = 0.01;
		var bounds : B2AABB = new B2AABB();
		bounds.lowerBound = new B2Vec2( -10000, -10000);
		bounds.upperBound = new B2Vec2(10000, 10000);
		_box2D = new B2World(bounds, new B2Vec2(0, 0), true);
		_box2D.SetContactListener(new PhysicsProcessContactListener(this));
		_box2D.SetDestructionListener(new PhysicsProcessDestructionListener(this));
		gravity = 6;
		behaviourTable = new Dictionary(true);
		jointTable = new Dictionary(true);
    }
	
	public function createRigidBody(behaviour : RigidBodyBehaviour, def : B2BodyDef) : B2Body
	{
		var rigidBody : B2Body = _box2D.CreateBody(def);
		Reflect.setField(behaviourTable, Std.string(rigidBody), behaviour);
		return rigidBody;
    }
	
	public function destroyRigidBody(behaviour : RigidBodyBehaviour, rigidBody : B2Body) : Void
	{
		_box2D.DestroyBody(rigidBody);
    }
	
	public function createJoint(jointDef : B2JointDef) : B2Joint
	{
		var joint : B2Joint = _box2D.CreateJoint(jointDef);
		Reflect.setField(jointTable, Std.string(joint), true);
		return joint;
    }
	
	public function destroyJoint(joint : B2Joint) : Void
	{
		// Don't try to destroy the joint if Box2D has already automatically destroyed it    
		// (as Box2D gets screwed up if you destroy a joint twice)  
		if (!Reflect.field(jointTable, Std.string(joint))) return;
		_box2D.DestroyJoint(joint);
    }
	
	@:allow(cadet2dbox2d.components.processes)
    private function jointDestroyed(joint : B2Joint) : Void
	{
    }
	
	public function getBehaviourForRigidBody(rigidBody : B2Body) : RigidBodyBehaviour
	{
		return Reflect.field(behaviourTable, Std.string(rigidBody));
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="NumericStepper",label="Gravity",stepSize="0.01"))
	private function set_Gravity(value : Float) : Float
	{
		_gravity = value;
		_box2D.SetGravity(new B2Vec2(0, _gravity));
        return value;
    }
	
	private function get_Gravity() : Float
	{
		return _gravity;
    }
	
	public function step(dt : Float) : Void
	{
		//var time:int = flash.utils.getTimer(); 
		for (i in 0...numIterations) {
			_box2D.Step(dt * (1 / numIterations), numVelocityIterations, numPositionIterations);
        }  
		//trace( flash.utils.getTimer() - time );  
    }
	
	public function getGroundBody() : B2Body
	{
		return _box2D.GetGroundBody();
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="NumericStepper",min="0.01",max="1000",stepSize="0.01",label="Meters per pixel"))
	private function set_ScaleFactor(value : Float) : Float
	{
		_scaleFactor = value;
		_invScaleFactor = 1 / _scaleFactor;invalidate("scaleFactor");
        return value;
    }
	
	private function get_ScaleFactor() : Float
	{
		return _scaleFactor;
    }
	
	private function get_InvScaleFactor() : Float
	{
		return _invScaleFactor;
    }
	
	private function get_World() : B2World
	{
		return _box2D;
    }
}