  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.B2Body;
import cadet2dbox2d.components.behaviours.B2Joint;
import cadet2dbox2d.components.behaviours.B2Vec2;
import box2d.common.math.B2Vec2;import box2d.dynamics.joints.B2Joint;import box2d.dynamics.B2Body;import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet.events.ComponentEvent;import cadet.events.ValidationEvent;import cadet.util.ComponentUtil;import cadet2d.components.connections.Connection;import cadet2dbox2d.components.processes.PhysicsProcess;import cadet2dbox2d.events.RigidBodyBehaviourEvent;import nme.events.Event;import nme.geom.Point;class SpringBehaviour extends Component implements ISteppableComponent
{
    public var connection(get, set) : Connection;
  // Invalidation types  private static inline var BEHAVIOURS : String = "behaviours";  // Component references  private var _connection : Connection;public var physicsProcess : PhysicsProcess;private var joint : B2Joint;private var _rigidBodyBehaviourA : RigidBodyBehaviour;private var _rigidBodyBehaviourB : RigidBodyBehaviour;@:meta(Serializable())
@:meta(Inspectable())
public var length : Float = 100;  //-1;  @:meta(Serializable())
@:meta(Inspectable())
public var stiffness : Float = 0.5;private var len : Float = -1;  // Local vars  private var posA : B2Vec2;private var posB : B2Vec2;private var diff : B2Vec2;public function new()
    {
        super();name = "SpringBehaviour";posA = new B2Vec2();posB = new B2Vec2();diff = new B2Vec2();
    }override private function addedToScene() : Void{addSiblingReference(Connection, "connection");addSceneReference(PhysicsProcess, "physicsProcess");
    }private function set_Connection(value : Connection) : Connection{if (_connection != null) {_connection.removeEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_connection.removeEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);_connection.removeEventListener(ValidationEvent.INVALIDATE, connectionChangeHandler);
        }_connection = value;if (_connection != null) {_connection.addEventListener(ComponentEvent.ADDED_TO_PARENT, connectionChangeHandler);_connection.addEventListener(ComponentEvent.REMOVED_FROM_PARENT, connectionChangeHandler);_connection.addEventListener(ValidationEvent.INVALIDATE, connectionChangeHandler);
        }invalidate(BEHAVIOURS);
        return value;
    }private function get_Connection() : Connection{return _connection;
    }private function connectionChangeHandler(event : Event) : Void{invalidate(BEHAVIOURS);
    }private function validateBehaviours() : Void{if (_connection == null) {_rigidBodyBehaviourA = null;_rigidBodyBehaviourB = null;return;
        }if (!_connection.transformA.parentComponent)             return;if (!_connection.transformB.parentComponent)             return;_rigidBodyBehaviourA = ComponentUtil.getChildOfType(_connection.transformA.parentComponent, RigidBodyBehaviour);_rigidBodyBehaviourB = ComponentUtil.getChildOfType(_connection.transformB.parentComponent, RigidBodyBehaviour);len = -1;
    }public function step(dt : Float) : Void{applySpringForce();
    }private function applySpringForce() : Void{if (physicsProcess == null)             return;var friction : Float = 0.2;var k : Float = stiffness * 100;var pt1 : Point = _connection.transformA.matrix.transformPoint(connection.localPosA.toPoint());var pt2 : Point = _connection.transformB.matrix.transformPoint(connection.localPosB.toPoint());posA.Set(pt1.x * physicsProcess.scaleFactor, pt1.y * physicsProcess.scaleFactor);posB.Set(pt2.x * physicsProcess.scaleFactor, pt2.y * physicsProcess.scaleFactor);diff.Set(posB.x, posB.y);diff.Subtract(posA);var bA : B2Body;var vA : B2Vec2;if (_rigidBodyBehaviourA != null) {bA = _rigidBodyBehaviourA.getBody();if (bA == null)                 return;vA = bA.GetLinearVelocityFromWorldPoint(posA);
        }
        else {vA = new B2Vec2();
        }var bB : B2Body;var vB : B2Vec2;if (_rigidBodyBehaviourB != null) {bB = _rigidBodyBehaviourB.getBody();if (bB == null)                 return;vB = bB.GetLinearVelocityFromWorldPoint(posB);
        }
        else {vB = new B2Vec2();
        }var vDiff : B2Vec2 = vB.Copy();vDiff.Subtract(vA);if (len == -1) {if (length != -1) {len = length * physicsProcess.scaleFactor;
            }
            else {len = diff.Length();
            }
        }var dx : Float = diff.Normalize();var vRel : Float = vDiff.x * diff.x + vDiff.y * diff.y;var forceMag : Float = -k * (dx - len) - friction * vRel;diff.Multiply(forceMag);if (bB != null) {bB.ApplyForce(diff, posA);bB.WakeUp();
        }diff.Multiply(-1);if (bA != null) {bA.ApplyForce(diff, posB);bA.WakeUp();
        }
    }override public function validateNow() : Void{if (isInvalid("behaviours")) {validateBehaviours();
        }super.validateNow();
    }
}