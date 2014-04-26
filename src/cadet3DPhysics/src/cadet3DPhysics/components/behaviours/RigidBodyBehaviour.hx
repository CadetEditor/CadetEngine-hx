// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3dphysics.components.behaviours;

import cadet3dphysics.components.behaviours.AWPBoxShape;
import cadet3dphysics.components.behaviours.AWPCollisionShape;
import cadet3dphysics.components.behaviours.AWPRigidBody;
import cadet3dphysics.components.behaviours.AWPSphereShape;
import cadet3dphysics.components.behaviours.AWPStaticPlaneShape;
import cadet3dphysics.components.behaviours.Component;
import cadet3dphysics.components.behaviours.CubeGeometryComponent;
import cadet3dphysics.components.behaviours.IGeometry;
import cadet3dphysics.components.behaviours.ISteppableComponent;
import cadet3dphysics.components.behaviours.Mesh;
import cadet3dphysics.components.behaviours.PhysicsProcess;
import cadet3dphysics.components.behaviours.PlaneGeometryComponent;
import cadet3dphysics.components.behaviours.SphereGeometryComponent;
import cadet3dphysics.components.behaviours.Vector3D;
import away3d.entities.Mesh;
import away3d.primitives.ConeGeometry;
import awayphysics.collision.shapes.AWPBoxShape;
import awayphysics.collision.shapes.AWPCollisionShape;
import awayphysics.collision.shapes.AWPConeShape;
import awayphysics.collision.shapes.AWPCylinderShape;
import awayphysics.collision.shapes.AWPSphereShape;
import awayphysics.collision.shapes.AWPStaticPlaneShape;
import awayphysics.dynamics.AWPRigidBody;
import cadet.components.geom.IGeometry;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet3d.components.core.MeshComponent;
import cadet3d.components.geom.CubeGeometryComponent;
import cadet3d.components.geom.PlaneGeometryComponent;
import cadet3d.components.geom.SphereGeometryComponent;
import cadet3dphysics.components.processes.PhysicsProcess;
import nme.geom.Vector3D;

class RigidBodyBehaviour extends Component implements ISteppableComponent
{
	public var geometry(get, set) : IGeometry;
	public var physicsProcess(get, set) : PhysicsProcess;
	private var _geometry : IGeometry;
	private var _physicsProcess : PhysicsProcess;
	private var _mesh : Mesh;
	private var body : AWPRigidBody;
	private var mass : Float = 1;
	private static inline var BODY : String = "body";
	
	public function new()
	{
		super();
		name = "RigidBodyBehaviour";
	}
	
	override private function addedToScene() : Void
	{  
		//addSiblingReference(Transform2D, "transform");  
		addSiblingReference(IGeometry, "geometry");
		addSceneReference(PhysicsProcess, "physicsProcess");
		_mesh = cast((parentComponent), MeshComponent).mesh;
		invalidate(BODY);
	}
	
	public function step(dt : Float) : Void
	{
	}
	
	override public function validateNow() : Void
	{
		if (isInvalid(BODY)) {
			validateBody();
		}  
		//if ( isInvalid(SHAPES) )
		//{
		//	validateShapes();
		//}
	}
	
	private function validateBody() : Void
	{
		destroyBody();  
		//if ( !_transform ) return;  
		if (_geometry == null) return;
		if (_physicsProcess == null) return;
		var shape : AWPCollisionShape = buildShape(geometry);
		body = new AWPRigidBody(shape, _mesh, mass);
		if (mass != 0) {
			body.friction = .9;
			body.ccdSweptSphereRadius = 0.5;
			body.ccdMotionThreshold = 1;
		}
		var mRX : Float = _mesh.rotationX;
		var mRY : Float = _mesh.rotationY;
		var mRZ : Float = _mesh.rotationZ;
		body.position = new Vector3D(_mesh.x, _mesh.y, _mesh.z);
		body.rotation = new Vector3D(mRX, mRY, mRZ);  
		//body.scale = new Vector3D(_mesh.scaleX, _mesh.scaleY, _mesh.scaleZ);  
		_physicsProcess.addRigidBody(this, body);
	}
	
	private function buildShape(geometry : IGeometry) : AWPCollisionShape
	{
		geometry.validateNow();
		var shape : AWPCollisionShape;
		if (Std.is(geometry, SphereGeometryComponent)) {
			var sphereGeom : SphereGeometryComponent = cast((geometry), SphereGeometryComponent);
			shape = new AWPSphereShape(sphereGeom.radius);
		} else if (Std.is(geometry, CubeGeometryComponent)) {
			var cubeGeom : CubeGeometryComponent = cast((geometry), CubeGeometryComponent);
			shape = new AWPBoxShape(cubeGeom.width, cubeGeom.height, cubeGeom.depth);
		}
		/*
			else if ( geometry is CylinderGeometryComponent ) {
				shape = new AWPCylinderShape(100, 200);
			} else if ( geometry is ConeGeometryComponent ) {
				shape = new AWPConeShape(100, 200);
			}
			*/
		else if (Std.is(geometry, PlaneGeometryComponent)) {
			mass = 0; 
			var planeGeom : PlaneGeometryComponent = cast((geometry), PlaneGeometryComponent);
			shape = new AWPStaticPlaneShape(new Vector3D(0, 1, 0));
		}
		return shape;
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene"))
	private function set_geometry(value : IGeometry) : IGeometry
	{
		destroyBody();
		_geometry = value;
		invalidate(BODY);
		return value;
	}
	
	private function get_geometry() : IGeometry
	{
		return _geometry;
	}
	
	private function set_physicsProcess(value : PhysicsProcess) : PhysicsProcess
	{
		destroyBody();
		if (_physicsProcess != null) {  
			//_physicsProcess.removeEventListener(InvalidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);  
		}
		_physicsProcess = value;
		if (_physicsProcess != null) {  
			//_physicsProcess.addEventListener(InvalidationEvent.INVALIDATE, invalidatePhysicsProcessHandler);  
		}
		invalidate(BODY);
		return value;
	}
	
	private function get_physicsProcess() : PhysicsProcess
	{
		return _physicsProcess;
	}
	
	private function destroyBody() : Void
	{
		if (body != null) { 
			// First, let any listening components know that the rigid body is about to be destroyed.    
			// This is so joints and other behaviours that depend on the rigid body can destroy their resources first.    
			//dispatchEvent( new RigidBodyBehaviourEvent( RigidBodyBehaviourEvent.DESTROY_RIGID_BODY ) ); 
			_physicsProcess.removeRigidBody(body);
			body = null;
		}
	}
	
	public function getAngularVelocity() : Vector3D
	{
		if (body == null) return null;
		return body.angularVelocity;
	}
	
	public function applyTorque(torque : Vector3D) : Void
	{
		if (body == null) return;
		body.applyTorque(torque);
	}
}