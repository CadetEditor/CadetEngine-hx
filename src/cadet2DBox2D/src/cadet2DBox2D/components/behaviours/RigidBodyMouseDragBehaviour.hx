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

import cadet2dbox2d.components.behaviours.AbstractSkin2D;
import cadet2dbox2d.components.behaviours.B2Body;
import cadet2dbox2d.components.behaviours.B2MouseJoint;
import cadet2dbox2d.components.behaviours.B2MouseJointDef;
import cadet2dbox2d.components.behaviours.B2Vec2;
import cadet2dbox2d.components.behaviours.DisplayObject;
import cadet2dbox2d.components.behaviours.IRenderable;
import cadet2dbox2d.components.behaviours.IRenderer;
import cadet2dbox2d.components.behaviours.Renderer2D;
import cadet2dbox2d.components.behaviours.RendererEvent;
import cadet2dbox2d.components.behaviours.Touch;
import cadet2dbox2d.components.behaviours.TouchEvent;
import nme.geom.Point;
import box2d.common.math.B2Vec2;
import box2d.dynamics.B2Body;
import box2d.dynamics.joints.B2MouseJoint;
import box2d.dynamics.joints.B2MouseJointDef;
import cadet.core.Component;
import cadet.core.IRenderer;
import cadet.core.ISteppableComponent;
import cadet.events.RendererEvent;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.skins.AbstractSkin2D;
import cadet2d.components.skins.IRenderable;
import cadet2dbox2d.components.processes.PhysicsProcess;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

class RigidBodyMouseDragBehaviour extends Component implements ISteppableComponent
{
    public var skin(get, set) : IRenderable;
    public var rigidBodyBehaviour(get, set) : RigidBodyBehaviour;
    public var physicsProcess(get, set) : PhysicsProcess;
    public var renderer(get, set) : IRenderer;
	private var _skin : AbstractSkin2D;
	private var _rigidBodyBehaviour : RigidBodyBehaviour;
	private var _physicsProcess : PhysicsProcess;
	private var _renderer : Renderer2D;
	private var dragJoint : B2MouseJoint;  
	// Local vars  
	private var mousePos : Point;
	private var mouseTargetVec : B2Vec2;
	
	public function new()
    {
        super();
		name = "RigidBodyMouseDragBehaviour";
		mousePos = new Point();
		mouseTargetVec = new B2Vec2();
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(IRenderable, "skin");
		addSiblingReference(RigidBodyBehaviour, "rigidBodyBehaviour");
		addSceneReference(PhysicsProcess, "physicsProcess");
		addSceneReference(IRenderer, "renderer");
    }
	
	override private function removedFromScene() : Void
	{
		destroyJoint();
    }
	
	private function set_Skin(value : IRenderable) : IRenderable
	{
		destroyJoint();
		if (!(Std.is(value, AbstractSkin2D))) return;
		_skin = cast((value), AbstractSkin2D);
        return value;
    }
	
	private function get_Skin() : IRenderable
	{
		return _skin;
    }
	
	private function set_RigidBodyBehaviour(value : RigidBodyBehaviour) : RigidBodyBehaviour
	{
		destroyJoint();
		_rigidBodyBehaviour = value;
        return value;
    }
	
	private function get_RigidBodyBehaviour() : RigidBodyBehaviour
	{
		return _rigidBodyBehaviour;
    }
	
	private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess
	{
		destroyJoint();
		_physicsProcess = value;
        return value;
    }
	
	private function get_PhysicsProcess() : PhysicsProcess
	{
		return _physicsProcess;
    }
	
	private function set_Renderer(value : IRenderer) : IRenderer
	{
		if (!(Std.is(value, Renderer2D))) return;
		if (_renderer != null) {
			_renderer.viewport.stage.removeEventListener(TouchEvent.TOUCH, touchEventHandler);
        }
		_renderer = cast((value), Renderer2D);
		if (_renderer != null && _renderer.viewport) {
			_renderer.viewport.stage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
        } else {
			renderer.addEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }
        return value;
    }
	
	private function get_Renderer() : IRenderer
	{
		return _renderer;
    }
	
	private function rendererInitialisedHandler(event : RendererEvent) : Void
	{
		renderer.removeEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
		_renderer.viewport.stage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
    }
	
	private function createJoint() : Void
	{
		var body : B2Body = _rigidBodyBehaviour.getBody();
		if (body == null) return;
		var mousePos : Point = _renderer.viewportToWorld(new Point(_renderer.mouseX, _renderer.mouseY));
		mousePos.x *= _physicsProcess.scaleFactor;
		mousePos.y *= _physicsProcess.scaleFactor;
		var jointDef : B2MouseJointDef = new B2MouseJointDef();
		jointDef.body1 = _physicsProcess.getGroundBody();
		jointDef.body2 = body; 
		jointDef.frequencyHz = 2;
		jointDef.target.Set(mousePos.x, mousePos.y); 
		jointDef.maxForce = 300 * body.GetMass();
		dragJoint = b2MouseJoint(_physicsProcess.createJoint(jointDef));
    }
	
	private function destroyJoint() : Void
	{
		if (dragJoint == null) return;
		_physicsProcess.destroyJoint(dragJoint);
		dragJoint = null;
    }
	
	private function touchEventHandler(event : TouchEvent) : Void
	{
		if (_rigidBodyBehaviour == null) return;
		if (_physicsProcess == null) return;
		if (_renderer == null) return;
		var body : B2Body = _rigidBodyBehaviour.getBody();
		if (body == null) return;
		var dispObj : DisplayObject = cast((_skin.displayObject), DisplayObject);
		var touches : Array<Touch> = event.getTouches(dispObj);
		if (touches == null || touches.length == 0) return;
		
		for (i in 0...touches.length) {
			var touch : Touch = touches[i];  
			//trace("RB onTouch x "+renderer.mouseX+" y "+renderer.mouseY+" phase "+touch.phase);  
			if (touch.phase == TouchPhase.ENDED) {
				destroyJoint();break;
            } else if (touch.phase == TouchPhase.BEGAN) {
				createJoint();break;
            }
        }
    }
	
	public function step(dt : Float) : Void
	{
		if (dragJoint == null) return;
		if (_physicsProcess == null) return;
		if (_renderer == null) return;
		mousePos.x = _renderer.mouseX;
		mousePos.y = _renderer.mouseY;
		mousePos = _renderer.viewportToWorld(mousePos);
		mousePos.x *= _physicsProcess.scaleFactor;
		mousePos.y *= _physicsProcess.scaleFactor;
		mouseTargetVec.Set(mousePos.x, mousePos.y);
		dragJoint.SetTarget(mouseTargetVec);
    }
}