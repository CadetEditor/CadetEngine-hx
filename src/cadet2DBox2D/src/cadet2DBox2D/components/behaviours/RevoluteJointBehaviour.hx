  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.B2RevoluteJoint;
import cadet2dbox2d.components.behaviours.B2RevoluteJointDef;
import cadet2dbox2d.components.behaviours.B2Vec2;
import cadet2dbox2d.components.behaviours.Pin;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;
import nme.geom.Point;import box2d.common.math.B2Vec2;import box2d.dynamics.joints.B2RevoluteJoint;import box2d.dynamics.joints.B2RevoluteJointDef;import cadet.core.Component;import cadet.events.ComponentEvent;import cadet.events.ValidationEvent;import cadet.util.ComponentUtil;import cadet2d.components.connections.Pin;import cadet2dbox2d.components.processes.PhysicsProcess;class RevoluteJointBehaviour extends Component implements IJoint
{
    public var enableLimit(get, set) : Bool;
    public var lowerAngle(get, set) : Float;
    public var upperAngle(get, set) : Float;
    public var enableMotor(get, set) : Bool;
    public var maxMotorTorque(get, set) : Float;
    public var motorSpeed(get, set) : Float;
    public var pin(get, set) : Pin;
    public var physicsProcess(get, set) : PhysicsProcess;
  // Invalidation types  private static inline var JOINT : String = "joint";private static inline var BEHAVIOURS : String = "behaviours";private static var DEG_TO_RAD : Float = Math.PI / 180;private var _pin : Pin;private var _physicsProcess : PhysicsProcess;private var joint : B2RevoluteJoint;private var physicsBehaviourA : RigidBodyBehaviour;private var physicsBehaviourB : RigidBodyBehaviour;@:meta(Serializable())
@:meta(Inspectable())
public var collideConnected : Bool = false;private var _enableLimit : Bool = false;private var _lowerAngle : Float = 0;private var _upperAngle : Float = 0;private var _enableMotor : Bool = false;private var _maxMotorTorque : Float = 1;private var _motorSpeed : Float = 1;public function new(name)
    {super(name);
    }override private function addedToScene() : Void{addSiblingReference(Pin, "pin");addSceneReference(PhysicsProcess, "physicsProcess");
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_EnableLimit(value : Bool) : Bool{_enableLimit = value;if (joint != null)             joint.EnableLimit(_enableLimit)
        else invalidate(JOINT);
        return value;
    }private function get_EnableLimit() : Bool{return _enableLimit;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_LowerAngle(value : Float) : Float{_lowerAngle = value;if (joint != null)             joint.SetLimits(_lowerAngle * DEG_TO_RAD, _upperAngle * DEG_TO_RAD)
        else invalidate(JOINT);
        return value;
    }private function get_LowerAngle() : Float{return _lowerAngle;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_UpperAngle(value : Float) : Float{_upperAngle = value;if (joint != null)             joint.SetLimits(_lowerAngle * DEG_TO_RAD, _upperAngle * DEG_TO_RAD)
        else invalidate(JOINT);
        return value;
    }private function get_UpperAngle() : Float{return _upperAngle;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_EnableMotor(value : Bool) : Bool{_enableMotor = value;if (joint != null)             joint.EnableMotor(_enableMotor)
        else invalidate(JOINT);
        return value;
    }private function get_EnableMotor() : Bool{return _enableMotor;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_MaxMotorTorque(value : Float) : Float{_maxMotorTorque = value;if (joint != null)             joint.SetMaxMotorTorque(_maxMotorTorque)
        else invalidate(JOINT);
        return value;
    }private function get_MaxMotorTorque() : Float{return _maxMotorTorque;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_MotorSpeed(value : Float) : Float{_motorSpeed = value;if (joint != null)             joint.SetMotorSpeed(_motorSpeed)
        else invalidate(JOINT);
        return value;
    }private function get_MotorSpeed() : Float{return _motorSpeed;
    }private function set_Pin(value : Pin) : Pin{destroyJoint();if (_pin != null) {_pin.removeEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_pin.removeEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
        }_pin = value;if (_pin != null) {_pin.addEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_pin.addEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);
        }invalidate(BEHAVIOURS);invalidate(JOINT);
        return value;
    }private function get_Pin() : Pin{return _pin;
    }private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess{destroyJoint();if (_physicsProcess != null) {_physicsProcess.removeEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }_physicsProcess = value;if (_physicsProcess != null) {_physicsProcess.addEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }invalidate(JOINT);
        return value;
    }private function get_PhysicsProcess() : PhysicsProcess{return _physicsProcess;
    }private function invalidatePhysicsProcessHandler(event : ValidationEvent) : Void{invalidate(JOINT);
    }private function connectionChangeHandler(event : ComponentEvent) : Void{invalidate(BEHAVIOURS);
    }public function getJoint() : B2RevoluteJoint{if (joint == null)             validateNow();return joint;
    }private function destroyJoint() : Void{if (joint == null)             return;if (_physicsProcess == null)             return;_physicsProcess.destroyJoint(joint);joint = null;
    }private function validateBehaviours() : Void{if (_pin == null) {physicsBehaviourA = null;physicsBehaviourB = null;return;
        }if (!_pin.transformA)             return;if (!_pin.transformB)             return;if (!_pin.transformA.parentComponent)             return;if (!_pin.transformB.parentComponent)             return;physicsBehaviourA = ComponentUtil.getChildOfType(_pin.transformA.parentComponent, RigidBodyBehaviour);physicsBehaviourB = ComponentUtil.getChildOfType(_pin.transformB.parentComponent, RigidBodyBehaviour);
    }private function validateJoint() : Void{if (!_scene)             return;if (physicsBehaviourA == null)             return;if (physicsBehaviourB == null)             return;if (_physicsProcess == null)             return;if (_pin == null || !_pin.localPos)             return;physicsBehaviourA.validateNow();physicsBehaviourB.validateNow();var jointDef : B2RevoluteJointDef = new B2RevoluteJointDef();jointDef.collideConnected = collideConnected;jointDef.enableLimit = _enableLimit;jointDef.lowerAngle = _lowerAngle * DEG_TO_RAD;jointDef.upperAngle = _upperAngle * DEG_TO_RAD;jointDef.enableMotor = _enableMotor;jointDef.maxMotorTorque = _maxMotorTorque;jointDef.motorSpeed = _motorSpeed;var pt : Point = _pin.localPos.toPoint();  // needs to be local to the shape not world coords  pt = _pin.transformA.globalMatrix.transformPoint(pt);  //presumes transform = (0,0)  var pos : B2Vec2 = new B2Vec2(pt.x * _physicsProcess.scaleFactor, pt.y * _physicsProcess.scaleFactor);jointDef.Initialize(physicsBehaviourA.getBody(), physicsBehaviourB.getBody(), pos);joint = b2RevoluteJoint(_physicsProcess.createJoint(jointDef));
    }override public function validateNow() : Void{if (isInvalid(BEHAVIOURS)) {validateBehaviours();
        }if (isInvalid(JOINT)) {validateJoint();
        }super.validateNow();
    }
}