  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.B2Body;
import cadet2dbox2d.components.behaviours.B2BodyDef;
import cadet2dbox2d.components.behaviours.B2CircleDef;
import cadet2dbox2d.components.behaviours.B2FilterData;
import cadet2dbox2d.components.behaviours.B2PolygonDef;
import cadet2dbox2d.components.behaviours.B2Shape;
import cadet2dbox2d.components.behaviours.B2Vec2;
import cadet2dbox2d.components.behaviours.CircleGeometry;
import cadet2dbox2d.components.behaviours.CompoundGeometry;
import cadet2dbox2d.components.behaviours.IGeometry;
import cadet2dbox2d.components.behaviours.ISteppableComponent;
import cadet2dbox2d.components.behaviours.Matrix;
import cadet2dbox2d.components.behaviours.PolygonGeometry;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviourEvent;
import cadet2dbox2d.components.behaviours.Transform2D;
import cadet2dbox2d.components.behaviours.Vertex;
import box2d.collision.shapes.B2CircleDef;import box2d.collision.shapes.B2FilterData;import box2d.collision.shapes.B2PolygonDef;import box2d.collision.shapes.B2Shape;import box2d.common.math.B2Vec2;import box2d.dynamics.B2Body;import box2d.dynamics.B2BodyDef;import cadet.components.geom.IGeometry;import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet.events.ValidationEvent;import cadet2d.components.geom.CircleGeometry;import cadet2d.components.geom.CompoundGeometry;import cadet2d.components.geom.PolygonGeometry;import cadet2d.components.transforms.Transform2D;import cadet2d.geom.Vertex;import cadet2d.util.VertexUtil;import cadet2dbox2d.components.processes.PhysicsProcess;import cadet2dbox2d.events.RigidBodyBehaviourEvent;import nme.geom.Matrix;import nme.geom.Point;@:meta(Event(type="cadet2DBox2D.events.RigidBodyBehaviourEvent",name="destroyRigidBody"))
class RigidBodyBehaviour extends Component implements ISteppableComponent
{
    public var transform(get, set) : Transform2D;
    public var geometry(get, set) : IGeometry;
    public var physicsProcess(get, set) : PhysicsProcess;
    public var density(get, set) : Float;
    public var friction(get, set) : Float;
    public var restitution(get, set) : Float;
    public var fixed(get, set) : Bool;
    public var angularDamping(get, set) : Float;
    public var linearDamping(get, set) : Float;
    public var categoryBits(get, set) : Int;
    public var maskBits(get, set) : Int;
  // Invalidation  types  private static inline var BODY : String = "body";private static inline var SHAPES : String = "shapes";private static var helperMatrix : Matrix = new Matrix();private var _density : Float = 1;private var _friction : Float = 0.8;private var _restitution : Float = 0.5;private var _fixed : Bool = false;private var _angularDamping : Float = 0.1;private var _linearDamping : Float = 0.1;private var _categoryBits : Int = 1;private var _maskBits : Int = Int.MAX_VALUE;private var _geometry : IGeometry;private var _transform : Transform2D;private var _physicsProcess : PhysicsProcess;private var body : B2Body;private var storedTranslateX : Float;private var storedTranslateY : Float;private var storedScaleX : Float;private var storedScaleY : Float;private var matrix : Matrix;private var tempVecA : B2Vec2;private var tempVecB : B2Vec2;public function new(fixed : Bool = false, density : Float = 1, friction : Float = 0.8, restitution : Float = 0.5)
    {
        super();name = "RigidBodyBehaviour";this.fixed = fixed;this.density = density;this.friction = friction;this.restitution = restitution;matrix = new Matrix();tempVecA = new B2Vec2();tempVecB = new B2Vec2();
    }override private function addedToScene() : Void{addSiblingReference(Transform2D, "transform");addSiblingReference(IGeometry, "geometry");addSceneReference(PhysicsProcess, "physicsProcess");
    }override private function removedFromScene() : Void{destroyBody();
    }private function set_Transform(value : Transform2D) : Transform2D{_transform = value;destroyBody();invalidate(BODY);
        return value;
    }private function get_Transform() : Transform2D{return _transform;
    }private function set_Geometry(value : IGeometry) : IGeometry{destroyBody();_geometry = value;invalidate(BODY);
        return value;
    }private function get_Geometry() : IGeometry{return _geometry;
    }private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess{destroyBody();if (_physicsProcess != null) {_physicsProcess.removeEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }_physicsProcess = value;if (_physicsProcess != null) {_physicsProcess.addEventListener(ValidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);
        }invalidate(BODY);
        return value;
    }private function get_PhysicsProcess() : PhysicsProcess{return _physicsProcess;
    }private function invalidatePhysicsProcessHandler(event : ValidationEvent) : Void{destroyBody();invalidate(BODY);
    }public function step(dt : Float) : Void{if (body == null)             return;if (_transform == null)             return;var globalScaleX : Float = 1;var globalScaleY : Float = 1;if (transform.parentTransform) {var m : Matrix = _transform.parentTransform.globalMatrix;globalScaleX = Math.sqrt(m.a * m.a + m.b * m.b);globalScaleY = Math.sqrt(m.c * m.c + m.d * m.d);
        }matrix.identity();matrix.scale(globalScaleX * storedScaleX, globalScaleY * storedScaleY);matrix.rotate(body.GetAngle());matrix.translate(body.GetPosition().x * _physicsProcess.invScaleFactor, body.GetPosition().y * _physicsProcess.invScaleFactor);if (transform.parentTransform) {helperMatrix.identity();helperMatrix.concat(_transform.parentTransform.globalMatrix);helperMatrix.invert();matrix.concat(helperMatrix);
        }_transform.matrix = matrix;
    }override public function validateNow() : Void{if (isInvalid(BODY)) {validateBody();
        }if (isInvalid(SHAPES)) {validateShapes();
        }super.validateNow();
    }public function getBody() : B2Body{if (body == null) {validateNow();
        }return body;
    }public function setPosition(x : Float, y : Float) : Void{var body : B2Body = getBody();if (body == null)             return;tempVecA.Set(x * _physicsProcess.scaleFactor, y * _physicsProcess.scaleFactor);body.SetPosition(tempVecA);
    }public function setVelocity(vx : Float, vy : Float) : Void{var body : B2Body = getBody();if (body == null)             return;tempVecA.Set(vx, vy);body.SetLinearVelocity(tempVecA);
    }public function getPosition() : Point{var body : B2Body = getBody();if (body == null)             return null;return new Point(body.GetPosition().x * _physicsProcess.invScaleFactor, body.GetPosition().y * _physicsProcess.invScaleFactor);
    }public function getAngularVelocity() : Float{var body : B2Body = getBody();if (body == null)             return 0;return body.GetAngularVelocity();
    }public function applyTorque(torque : Float) : Void{var body : B2Body = getBody();if (body == null)             return;body.ApplyTorque(torque);
    }public function applyImpulse(impulseX : Float, impulseY : Float) : Void{var body : B2Body = getBody();if (body == null)             return;tempVecA.Set(impulseX, impulseY);body.ApplyImpulse(tempVecA, body.GetPosition());
    }public function applyImpulseAt(impulseX : Float, impulseY : Float, worldPosX : Float, worldPosY : Float) : Void{var body : B2Body = getBody();if (body == null)             return;tempVecA.Set(impulseX, impulseY);tempVecB.Set(worldPosX * _physicsProcess.scaleFactor, worldPosY * _physicsProcess.scaleFactor);body.ApplyImpulse(tempVecA, tempVecB);
    }private function validateBody() : Void{destroyBody();if (_transform == null)             return;if (_geometry == null)             return;if (_physicsProcess == null)             return;var bodyDef : B2BodyDef = new B2BodyDef();if (_transform.parentTransform) {var m : Matrix = _transform.globalMatrix;bodyDef.position.x = m.tx * _physicsProcess.scaleFactor;bodyDef.position.y = m.ty * _physicsProcess.scaleFactor;bodyDef.angle = Math.atan(m.b / m.a);
        }
        else {bodyDef.position.x = _transform.x * _physicsProcess.scaleFactor;bodyDef.position.y = _transform.y * _physicsProcess.scaleFactor;bodyDef.angle = _transform.rotation * (Math.PI / 180);
        }  // this is always in local coords  storedScaleX = _transform.scaleX;storedScaleY = _transform.scaleY;body = _physicsProcess.createRigidBody(this, bodyDef);buildShape(_geometry, body);body.SetMassFromShapes();body.SetAngularDamping(_angularDamping);body.SetLinearDamping(_linearDamping);body.AllowSleeping(true);
    }private function validateShapes() : Void{if (body == null)             return;var filterData : B2FilterData = new B2FilterData();filterData.categoryBits = _categoryBits;filterData.maskBits = _maskBits;var shape : B2Shape = body.GetShapeList();while (shape){shape.SetFilterData(filterData);shape.SetRestitution(_restitution);shape.SetFriction(_friction);shape = shape.GetNext();
        }
    }private function destroyBody() : Void{if (body != null) {  /// First, let any listening components know that the rigid body is about to be destroyed.    // This is so joints and other behaviours that depend on the rigid body can destroy their resources first.  dispatchEvent(new RigidBodyBehaviourEvent(RigidBodyBehaviourEvent.DESTROY_RIGID_BODY));_physicsProcess.destroyRigidBody(this, body);body = null;
        }
    }private function buildShape(geometry : IGeometry, body : B2Body) : Void{geometry.validateNow();var globalMatrix : Matrix = _transform.globalMatrix;var globalScaleX : Float = Math.sqrt(globalMatrix.a * globalMatrix.a + globalMatrix.b * globalMatrix.b);var globalScaleY : Float = Math.sqrt(globalMatrix.c * globalMatrix.c + globalMatrix.d * globalMatrix.d);if (Std.is(geometry, CircleGeometry)) {  // Take the scale transform of the circle into account  var scale : Float = globalScaleX > (globalScaleY != 0) ? globalScaleX : globalScaleY;var circle : CircleGeometry = cast((geometry), CircleGeometry);var circleShapeDef : B2CircleDef = new B2CircleDef();circleShapeDef.radius = circle.radius * _physicsProcess.scaleFactor * scale;circleShapeDef.friction = friction;circleShapeDef.restitution = restitution;circleShapeDef.density = (fixed) ? 0 : density;circleShapeDef.localPosition = new B2Vec2(circle.x * _physicsProcess.scaleFactor, circle.y * _physicsProcess.scaleFactor);body.CreateShape(circleShapeDef);
        }
        else if (Std.is(geometry, PolygonGeometry)) {var polygon : PolygonGeometry = cast((geometry), PolygonGeometry);var vertices : Array<Dynamic> = VertexUtil.copy(polygon.vertices);if (globalScaleX != 1 || globalScaleY != 1) {helperMatrix.identity();helperMatrix.scale(globalScaleX, globalScaleY);  // Transform the vertices to world space  VertexUtil.transform(vertices, helperMatrix);
            }  // Simplify the vertices so vertices on, or very near, a straight line get removed.  vertices = VertexUtil.simplify(vertices);var allVertices : Array<Dynamic> = [vertices];  // Check if the poylgon is concave, if so, then collapse down to convex shapes first  if (VertexUtil.isConcave(vertices)) {allVertices = VertexUtil.makeConvex(vertices);
            }for (vertices in allVertices){var polygonShapeDef : B2PolygonDef = new B2PolygonDef();polygonShapeDef.density = (fixed) ? 0 : density;polygonShapeDef.friction = friction;polygonShapeDef.restitution = restitution;for (i in 0...vertices.length){var vertex : Vertex = vertices[i];polygonShapeDef.vertices[i] = new B2Vec2(vertex.x * _physicsProcess.scaleFactor, vertex.y * _physicsProcess.scaleFactor);polygonShapeDef.vertexCount++;
                }body.CreateShape(polygonShapeDef);
            }
        }
        else if (Std.is(geometry, CompoundGeometry)) {var compoundGeometry : CompoundGeometry = cast((geometry), CompoundGeometry);for (childData/* AS3HX WARNING could not determine type for var: childData exp: EField(EIdent(compoundGeometry),children) type: null */ in compoundGeometry.children){buildShape(childData, body);
            }
        }
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Density(value : Float) : Float{_density = value;invalidate(BODY);
        return value;
    }private function get_Density() : Float{return _density;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Friction(value : Float) : Float{_friction = value;if (body != null) {invalidate(SHAPES);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_Friction() : Float{return _friction;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Restitution(value : Float) : Float{_restitution = value;if (body != null) {invalidate(SHAPES);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_Restitution() : Float{return _restitution;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Fixed(value : Bool) : Bool{_fixed = value;invalidate(BODY);
        return value;
    }private function get_Fixed() : Bool{return _fixed;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_AngularDamping(value : Float) : Float{_angularDamping = value;if (body != null) {body.SetAngularDamping(_angularDamping);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_AngularDamping() : Float{return _angularDamping;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_LinearDamping(value : Float) : Float{_linearDamping = value;if (body != null) {body.SetLinearDamping(_linearDamping);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_LinearDamping() : Float{return _linearDamping;
    }@:meta(Serializable())
private function set_CategoryBits(value : Int) : Int{_categoryBits = value;if (body != null) {invalidate(SHAPES);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_CategoryBits() : Int{return _categoryBits;
    }@:meta(Serializable())
private function set_MaskBits(value : Int) : Int{_maskBits = value;if (body != null) {invalidate(SHAPES);
        }
        else {invalidate(BODY);
        }
        return value;
    }private function get_MaskBits() : Int{return _maskBits;
    }
}