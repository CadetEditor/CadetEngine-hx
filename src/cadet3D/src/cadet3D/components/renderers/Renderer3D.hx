// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.components.renderers;

import cadet3d.components.renderers.AbstractLightComponent;
import cadet3d.components.renderers.AbstractMaterialComponent;
import cadet3d.components.renderers.Camera3D;
import cadet3d.components.renderers.CameraComponent;
import cadet3d.components.renderers.Component;
import cadet3d.components.renderers.ComponentEvent;
import cadet3d.components.renderers.Dictionary;
import cadet3d.components.renderers.IComponent;
import cadet3d.components.renderers.MaterialBase;
import cadet3d.components.renderers.ObjectContainer3D;
import cadet3d.components.renderers.ObjectContainer3DComponent;
import cadet3d.components.renderers.Renderer3DEvent;
import cadet3d.components.renderers.RendererEvent;
import cadet3d.components.renderers.ShadowMapMethodBase;
import cadet3d.components.renderers.SoftShadowMapMethod;
import cadet3d.components.renderers.Sprite;
import cadet3d.components.renderers.StaticLightPicker;
import cadet3d.components.renderers.View3D;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.display.Stage;
import nme.utils.Dictionary;
import away3d.cameras.Camera3D;
import away3d.containers.ObjectContainer3D;
import away3d.containers.View3D;
import away3d.lights.DirectionalLight;
import away3d.materials.MaterialBase;
import away3d.materials.SinglePassMaterialBase;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.methods.ShadowMapMethodBase;
import away3d.materials.methods.SoftShadowMapMethod;
import cadet.core.Component;
import cadet.core.IComponent;
import cadet.events.ComponentEvent;
import cadet.events.RendererEvent;
import cadet.util.ComponentUtil;
import cadet3d.components.cameras.CameraComponent;
import cadet3d.components.core.ObjectContainer3DComponent;
import cadet3d.components.lights.AbstractLightComponent;
import cadet3d.components.materials.AbstractMaterialComponent;
import cadet3d.events.Renderer3DEvent;

@:meta(Event(name="preRender",type="cadet3D.events.Renderer3DEvent"))
@:meta(Event(name="postRender",type="cadet3D.events.Renderer3DEvent"))
class Renderer3D extends Component implements IRenderer3D
{
	public var cameraComponent(get, set) : CameraComponent;
	public var view3D(get, never) : View3D;
	public var rootContainer(get, never) : ObjectContainer3D;
	public var viewport(get, never) : Sprite;
	public var viewportWidth(get, set) : Float;
	public var viewportHeight(get, set) : Float;
	public var mouseX(get, never) : Float;
	public var mouseY(get, never) : Float;
	public var initialised(get, never) : Bool;
	private var _view3D : View3D;
	private var lightPicker : StaticLightPicker;
	private var lights : Array<Dynamic>;
	private var _cameraComponent : CameraComponent;
	private var _rootContainer : ObjectContainer3D;
	private var _materials : Array<MaterialBase>;
	private var object3DComponentTable : Dictionary;
	private var _shadowMapMethod : ShadowMapMethodBase;
	private var preRenderEvent : Renderer3DEvent;
	private var postRenderEvent : Renderer3DEvent;
	private var _enabled : Bool;
	private var _initialised : Bool;
	private var _parent : DisplayObjectContainer;
	
	public function new()
	{
		super();
		_view3D = new View3D();
		_view3D.antiAlias = 2;
		_materials = new Array<MaterialBase>();
		object3DComponentTable = new Dictionary();
		preRenderEvent = new Renderer3DEvent(Renderer3DEvent.PRE_RENDER);
		postRenderEvent = new Renderer3DEvent(Renderer3DEvent.POST_RENDER);  
		// Away3D 4 doesn't provide a way of accessing a top-level object container    
		// (The Scene3D class isn't an ObjectContainer3D).    
		// We need access to a top-level container to be able to do things like    
		// registering for global mouse events bubbling up.    
		// That's what this root container is for, and we add all entities to this    
		// rather than the scene.  
		_rootContainer = new ObjectContainer3D();
		_view3D.scene.addChild(_rootContainer);
		lights = [];
		lightPicker = new StaticLightPicker(lights);
	}
	
	public function enable(parent : DisplayObjectContainer, depth : Int = -1) : Void
	{
		_parent = parent;
		
		if (depth > -1) parent.addChildAt(viewport, depth)
		else parent.addChild(viewport);
		
		_enabled = true;
		_initialised = true;
		dispatchEvent(new RendererEvent(RendererEvent.INITIALISED));
	}
	
	public function disable(parent : DisplayObjectContainer) : Void
	{
		_enabled = false;
		parent.removeChild(viewport);
	}
	
	override public function dispose() : Void
	{
		_view3D.dispose();
		_view3D = null;
		scene.removeEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler); 
		scene.removeEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedFromSceneHandler);
		lightPicker = null;
		lights = null;
		super.dispose();
	}
	
	public function getComponentForObject3D(object3D : ObjectContainer3D) : ObjectContainer3DComponent
	{
		return Reflect.field(object3DComponentTable, Std.string(object3D));
	}
	
	@:meta(Serializable())
	private function set_cameraComponent(value : CameraComponent) : CameraComponent
	{
		_cameraComponent = value;
		if (_cameraComponent != null) {
			_view3D.camera = _cameraComponent.camera;
		} else {
			_view3D.camera = new Camera3D();
		}
		return value;
	}
	
	private function get_cameraComponent() : CameraComponent
	{
		return _cameraComponent;
	}
	
	override public function validateNow() : Void
	{
		if (_view3D.stage == null) return;
		dispatchEvent(preRenderEvent);
		_view3D.render();
		dispatchEvent(postRenderEvent);
		super.validateNow();
	}
	
	private function get_view3D() : View3D
	{
		return _view3D;
	}
	
	private function get_rootContainer() : ObjectContainer3D
	{
		return _rootContainer;
	}
	
	private function get_viewport() : Sprite
	{
		return _view3D;
	}
	
	private function set_viewportWidth(value : Float) : Float
	{
		_view3D.width = value;
		return value;
	}
	
	private function get_viewportWidth() : Float
	{
		return _view3D.width;
	}
	
	private function set_viewportHeight(value : Float) : Float
	{
		_view3D.height = value;
		return value;
	}
	
	private function get_viewportHeight() : Float
	{
		return _view3D.height;
	}
	
	private function get_mouseX() : Float
	{
		return _view3D.mouseX;
	}
	
	private function get_mouseY() : Float
	{
		return _view3D.mouseY;
	}
	
	override private function addedToScene() : Void
	{
		scene.addEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler); 
		scene.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedFromSceneHandler);
		var allEntityComponents : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, ObjectContainer3DComponent, true);
		for (entityComponent in allEntityComponents) {
			addObject3DComponent(entityComponent);
		}
		var allLightComponents : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, AbstractLightComponent, true);
		for (lightComponent in allLightComponents) {
			addLightComponent(lightComponent);
		}
		var allMaterialComponents : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, AbstractMaterialComponent, true);
		for (materialComponent in allMaterialComponents) {
			addMaterialComponent(materialComponent);
		}
		if (_cameraComponent == null) {
			cameraComponent = ComponentUtil.getChildOfType(scene, CameraComponent, true);
		}
	}
	
	override private function removedFromScene() : Void
	{
		if (lightPicker != null) {
			lightPicker.lights = lights = [];
		}
		for (material in _materials) {
			material.lightPicker = null;
		}
		_materials = new Array<MaterialBase>();
	}
	
	private function componentAddedToSceneHandler(event : ComponentEvent) : Void
	{
		if (Std.is(event.component, ObjectContainer3DComponent)) {
			addObject3DComponent(cast((event.component), ObjectContainer3DComponent));
		}
		if (Std.is(event.component, AbstractLightComponent)) {
			addLightComponent(cast((event.component), AbstractLightComponent));
		}
		if (Std.is(event.component, AbstractMaterialComponent)) {
			addMaterialComponent(cast((event.component), AbstractMaterialComponent));
		}
		if (_cameraComponent == null && Std.is(event.component, CameraComponent)) {
			cameraComponent = cast((event.component), CameraComponent);
		}
	}
	
	private function componentRemovedFromSceneHandler(event : ComponentEvent) : Void
	{
		if (Std.is(event.component, ObjectContainer3DComponent)) {
			removeObject3DComponent(cast((event.component), ObjectContainer3DComponent));
		}
		if (Std.is(event.component, AbstractLightComponent)) {
			removeLightComponent(cast((event.component), AbstractLightComponent));
		}
		if (Std.is(event.component, AbstractMaterialComponent)) {
			removeMaterialComponent(cast((event.component), AbstractMaterialComponent));
		}
		if (event.component == _cameraComponent) {
			cameraComponent = null;
		}
	}
	
	private function addObject3DComponent(entityComponent : ObjectContainer3DComponent) : Void
	{
		object3DComponentTable[entityComponent.object3D] = entityComponent;
		if (entityComponent.parentComponent == _scene) {
			_rootContainer.addChild(entityComponent.object3D);
		}
	}
	
	private function removeObject3DComponent(entityComponent : ObjectContainer3DComponent) : Void
	{
		if (entityComponent.object3D.parent == _rootContainer) {
			_rootContainer.removeChild(entityComponent.object3D);
		}
	}
	
	private function addLightComponent(lightComponent : AbstractLightComponent) : Void
	{
		lights.push(lightComponent.light); lightPicker.lights = lights.substring();
		if (_shadowMapMethod == null && Std.is(lightComponent.light, DirectionalLight)) {
			_shadowMapMethod = new SoftShadowMapMethod(cast((lightComponent.light), DirectionalLight));
			for (material in _materials) {
				if (Std.is(material, SinglePassMaterialBase)) {
					cast((material), SinglePassMaterialBase).shadowMethod = _shadowMapMethod;
				}
			}
		}
	}
	
	private function removeLightComponent(lightComponent : AbstractLightComponent) : Void
	{
		lights.splice(Lambda.indexOf(lights, lightComponent.light));
		lightPicker.lights = lights;
		if (_shadowMapMethod != null && _shadowMapMethod.castingLight == lightComponent.light) {
			for (material in _materials) {
				if (Std.is(material, SinglePassMaterialBase)) {
					cast((material), SinglePassMaterialBase).shadowMethod = null;
				}
			}
			_shadowMapMethod.dispose();
		}
	}
	
	private function addMaterialComponent(materialComponent : AbstractMaterialComponent) : Void
	{
		materialComponent.material.lightPicker = lightPicker;
		_materials.push(materialComponent.material);
		if (_shadowMapMethod != null) {
			materialComponent.material.shadowMethod = _shadowMapMethod;
		}
	}
	
	private function removeMaterialComponent(materialComponent : AbstractMaterialComponent) : Void
	{  
		//materialComponent.material.lightPicker = null;  
		_materials.splice(Lambda.indexOf(_materials, materialComponent.material), 1);
	}
	
	public function getNativeStage() : flash.display.Stage
	{
		return _parent.stage;
	}
	
	private function get_initialised() : Bool
	{
		return _initialised;
	}
}