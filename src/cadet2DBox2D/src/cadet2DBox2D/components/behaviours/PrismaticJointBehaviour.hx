  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.B2PrismaticJoint;
import cadet2dbox2d.components.behaviours.B2PrismaticJointDef;
import cadet2dbox2d.components.behaviours.B2Vec2;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;
import nme.geom.Point;import box2d.common.math.B2Vec2;import box2d.dynamics.joints.B2PrismaticJoint;import box2d.dynamics.joints.B2PrismaticJointDef;import cadet.core.Component;import cadet.events.ComponentEvent;import cadet.events.ValidationEvent;import cadet.util.ComponentUtil;import cadet2d.components.connections.Connection;import cadet2dbox2d.components.processes.PhysicsProcess;class PrismaticJointBehaviour extends Component implements IJoint
{
    public var maxMotorForce(get, set) : Float;
    public var motorSpeed(get, set) : Float;
    public var lowerLimit(get, set) : Float;
    public var upperLimit(get, set) : Float;
    public var enableLimit(get, set) : Bool;
    public var enableMotor(get, set) : Bool;
    public var collideConnected(get, set) : Bool;
    public var autoCalculateLimits(get, set) : Bool;
    public var connection(get, set) : Connection;
    public var physicsProcess(get, set) : PhysicsProcess;
  // Invalidation types  private static inline var JOINT : String = "joint";private static inline var BEHAVIOURS : String = "behaviours";private var _connection : Connection;private var _physicsProcess : PhysicsProcess;private var joint : B2PrismaticJoint;private var physicsBehaviourA : RigidBodyBehaviour;private var physicsBehaviourB : RigidBodyBehaviour;private var _lowerLimit : Float = 0;private var _upperLimit : Float = 10;private var _enableLimit : Bool = true;private var _enableMotor : Bool = false;private var _maxMotorForce : Float = 1;private var _motorSpeed : Float = 1;private var _autoCalculateLimits : Bool = true;private var _collideConnected : Bool = true;public function new()
    {
        super();name = "PrismaticJointBehaviour";
    }override private function addedToScene() : Void{addSiblingReference(Connection, "connection");addSceneReference(PhysicsProcess, "physicsProcess");
    }override private function removedFromScene() : Void{destroyJoint();
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_MaxMotorForce(value : Float) : Float{_maxMotorForce = value;if (joint != null)             joint.SetMaxMotorForce(_maxMotorForce)
        else invalidate(JOINT);
        return value;
    }private function get_MaxMotorForce() : Float{return _maxMotorForce;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_MotorSpeed(value : Float) : Float{_motorSpeed = value;if (joint != null)             joint.SetMotorSpeed(_motorSpeed)
        else invalidate(JOINT);
        return value;
    }private function get_MotorSpeed() : Float{return _motorSpeed;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_LowerLimit(value : Float) : Float{_lowerLimit = value;if (autoCalculateLimits)             return  // Ignore change if limits are auto-calculated  ;if (joint != null)             joint.SetLimits(_lowerLimit, _upperLimit)
        else invalidate(JOINT);
        return value;
    }private function get_LowerLimit() : Float{return _lowerLimit;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_UpperLimit(value : Float) : Float{_upperLimit = value;if (autoCalculateLimits)             return  // Ignore change if limits are auto-calculated  ;if (joint != null)             joint.SetLimits(_lowerLimit, _upperLimit)
        else invalidate(JOINT);
        return value;
    }private function get_UpperLimit() : Float{return _upperLimit;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_EnableLimit(value : Bool) : Bool{_enableLimit = value;if (joint != null)             joint.EnableLimit(_enableLimit)
        else invalidate(JOINT);
        return value;
    }private function get_EnableLimit() : Bool{return _enableLimit;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_EnableMotor(value : Bool) : Bool{_enableMotor = value;if (joint != null)             joint.EnableMotor(_enableMotor)
        else invalidate(JOINT);
        return value;
    }private function get_EnableMotor() : Bool{return _enableMotor;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_CollideConnected(value : Bool) : Bool{_collideConnected = value;invalidate(JOINT);
        return value;
    }private function get_CollideConnected() : Bool{return _collideConnected;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_AutoCalculateLimits(value : Bool) : Bool{_autoCalculateLimits = value;invalidate(JOINT);
        return value;
    }private function get_AutoCalculateLimits() : Bool{return _autoCalculateLimits;
    }private function set_Connection(value : Connection) : Connection{destroyJoint();if (_connection != null) {_connection.removeEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_connection.removeEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
        }_connection = value;if (_connection != null) {_connection.addEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_connection.addEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
        }invalidate(BEHAVIOURS);invalidate(JOINT);
        return value;
    }private function get_Connection() : Connection{return _connection;
    }private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess{destroyJoint();if (_physicsProcess != null) {_physicsProcess.removeEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }_physicsProcess = value;if (_physicsProcess != null) {_physicsProcess.addEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }invalidate(JOINT);
        return value;
    }private function get_PhysicsProcess() : PhysicsProcess{return _physicsProcess;
    }private function invalidatePhysicsProcessHandler(event : ValidationEvent) : Void{invalidate(JOINT);
    }private function connectionChangeHandler(event : ComponentEvent) : Void{invalidate(BEHAVIOURS);
    }private function destroyJoint() : Void{if (joint == null)             return;if (_physicsProcess == null)             return;_physicsProcess.destroyJoint(joint);joint = null;
    }private function validateBehaviours() : Void{if (_connection == null) {physicsBehaviourA = null;physicsBehaviourB = null;return;
        }if (!_connection.transformA.parentComponent)             return;if (!_connection.transformB.parentComponent)             return;physicsBehaviourA = ComponentUtil.getChildOfType(_connection.transformA.parentComponent, RigidBodyBehaviour);physicsBehaviourB = ComponentUtil.getChildOfType(_connection.transformB.parentComponent, RigidBodyBehaviour);
    }private function validateJoint() : Void{if (!_scene)             return;if (physicsBehaviourA == null)             return;if (physicsBehaviourB == null)             return;if (_physicsProcess == null)             return;physicsBehaviourA.validateNow();physicsBehaviourB.validateNow();var jointDef : B2PrismaticJointDef = new B2PrismaticJointDef();jointDef.collideConnected = _collideConnected;jointDef.enableMotor = _enableMotor;jointDef.motorSpeed = _motorSpeed;jointDef.maxMotorForce = _maxMotorForce;var pt1 : Point = _connection.transformA.matrix.transformPoint(_connection.localPosA.toPoint());var pt2 : Point = _connection.transformB.matrix.transformPoint(_connection.localPosB.toPoint());var posA : B2Vec2 = new B2Vec2(pt1.x * _physicsProcess.scaleFactor, pt1.y * _physicsProcess.scaleFactor);var posB : B2Vec2 = new B2Vec2(pt2.x * _physicsProcess.scaleFactor, pt2.y * _physicsProcess.scaleFactor);var axis : B2Vec2 = new B2Vec2();axis.x = posB.x - posA.x;axis.y = posB.y - posA.y;if (_enableLimit) {jointDef.enableLimit = true;if (!_autoCalculateLimits) {jointDef.lowerTranslation = _lowerLimit * _physicsProcess.scaleFactor;jointDef.upperTranslation = _upperLimit * _physicsProcess.scaleFactor;
            }
            else {jointDef.lowerTranslation = -axis.Length();jointDef.upperTranslation = 0;
            }
        }axis.Normalize();jointDef.Initialize(physicsBehaviourA.getBody(), physicsBehaviourB.getBody(), posA, axis);joint = b2PrismaticJoint(_physicsProcess.createJoint(jointDef));
    }override public function validateNow() : Void{if (isInvalid(BEHAVIOURS)) {validateBehaviours();
        }if (isInvalid(JOINT)) {validateJoint();
        }super.validateNow();
    }
}