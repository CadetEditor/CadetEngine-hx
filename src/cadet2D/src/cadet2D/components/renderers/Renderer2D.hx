// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 50-99  

package cadet2d.components.renderers;

import cadet2d.components.renderers.Component;
import cadet2d.components.renderers.ComponentEvent;
import cadet2d.components.renderers.Dictionary;
import cadet2d.components.renderers.DisplayObjectContainer;
import cadet2d.components.renderers.IAnimatable;
import cadet2d.components.renderers.IComponent;
import cadet2d.components.renderers.IRenderable;
import cadet2d.components.renderers.Overlay;
import cadet2d.components.renderers.Rectangle;
import cadet2d.components.renderers.RendererEvent;
import cadet2d.components.renderers.Sprite;
import cadet2d.components.renderers.Stage;
import cadet2d.components.renderers.Starling;
import cadet2d.components.renderers.Touch;
import cadet2d.components.renderers.TouchEvent;
import cadet2d.components.renderers.ValidationEvent;
import nme.display.DisplayObject;
import nme.display.Stage;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.utils.Dictionary;
import cadet.core.Component;
import cadet.core.IComponent;
import cadet.events.ComponentEvent;
import cadet.events.RendererEvent;
import cadet.events.ValidationEvent;
import cadet.util.ComponentUtil;
import cadet2d.components.skins.IRenderable;
import cadet2d.overlays.Overlay;
import cadet2d.util.RenderablesUtil;
import core.app.util.AsynchronousUtil;
import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;

@:meta(Event(type="cadet.events.RendererEvent",name="initialised"))
class Renderer2D extends Component implements IRenderer2D
{
    public var allowScale(get, set) : Bool;
    public var depthSort(get, set) : Bool;
    public var viewportWidth(get, set) : Float;
    public var viewportHeight(get, set) : Float;
    public var viewport(get, never) : DisplayObjectContainer;
    public var worldContainer(get, never) : Sprite;
    public var mouseX(get, never) : Float;
    public var mouseY(get, never) : Float;
    public var initialised(get, never) : Bool;
    public var viewportX(get, never) : Float;
    public var viewportY(get, never) : Float;
	// Properties  
	private var _viewportWidth : Float;
	private var _viewportHeight : Float;  
	// Display Hierachy  
	private var _viewport : DisplayObjectContainer;
	private var _worldContainer : Sprite;
	private var _viewportOverlayContainer : Sprite;  
	// Misc  
	private var skinTable : Dictionary;
	private var displayListVector : Array<IRenderable>;
	private var identityMatrix : Matrix;
	private var star : Starling;
	private var _parent : DisplayObjectContainer;
	private var _nativeParent : flash.display.DisplayObject;  
	// Required for validateViewport()  
	private var _nativeStage : Stage;
	private var _mouseX : Float;
	private var _mouseY : Float;
	private var _viewportX : Float = 0;
	private var _viewportY : Float = 0;
	private var _enabled : Bool = false;
	private var _initialised : Bool = false;
	private var overlaysTable : Dictionary;
	private var _backgroundColor : Int = 0x303030;
	public var BASELINE : String = "baseline";
	public var BASELINECONSTRAINED : String = "baselineConstrained";
	public var defaultProfile : String = BASELINE;
	private var _depthSort : Bool = false;
	private var _allowScale : Bool = false;
	
	public function new(depthSort : Bool = false, allowScale : Bool = false, name : String = "Starling Renderer")
    {
		super(name);
		_allowScale = allowScale;
		_depthSort = depthSort;
		reset();
    }  
	
	// When adding a Starling renderer to a native scene a reference to the nativeParent's transform is required.  
	public function enable(nativeParent : flash.display.DisplayObject) : Void
	{
		_nativeParent = nativeParent;
		_nativeStage = _nativeParent.stage;
		if (_enabled) return;
		_enabled = true;
		if (_viewportWidth == 0) {
			_viewportWidth = _nativeStage.stageWidth;
        }
		if (_viewportHeight == 0) {
			_viewportHeight = _nativeStage.stageHeight;
        }
		if (!Starling.current) {
			star = new Starling(Sprite, _nativeStage, null, null, "auto", defaultProfile);
			star.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreatedHandler);
			star.antiAliasing = 1;
			star.start();
        } else {
			star = Starling.current;
			AsynchronousUtil.callLater(init);
        }
		
		invalidate(RendererInvalidationTypes.VIEWPORT);
    }  
	
	// When we know this isn't the only Starling instance and we want to render into a specific starling.display.DisplayObjectContainer  
	public function enableToExisting(parent : DisplayObjectContainer) : Void
	{
		star = Starling.current;
		_parent = parent;
		_nativeStage = star.nativeStage;
		if (_enabled) return;
		_enabled = true;
		if (_viewportWidth == 0) {
			_viewportWidth = _parent.stage.stageWidth;
        }
		if (_viewportHeight == 0) {
			_viewportHeight = _parent.stage.stageHeight;
        }
		AsynchronousUtil.callLater(init);
		invalidate(RendererInvalidationTypes.VIEWPORT);
    }
	
	public function disable() : Void
	{
		_enabled = false;
		_initialised = false;
		_viewport.stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
		_viewport.removeChildren();
    }
	
	private function onTouchHandler(e : TouchEvent) : Void
	{
		var dispObj : starling.display.DisplayObject = starling.display.DisplayObject(_viewport.stage);
		var touches : Array<Touch> = e.getTouches(dispObj);
		for (touch in touches) {
			var location : Point = touch.getLocation(dispObj);
			_mouseX = location.x;
			_mouseY = location.y;
			var local : Point = _viewport.globalToLocal(location);
			break;
        }
    }
	
	private function onRootCreatedHandler(event : starling.events.Event) : Void
	{
		init();
    }
	
	private function reset() : Void
	{
		identityMatrix = new Matrix();
		skinTable = new Dictionary();
		displayListVector = new Array<IRenderable>();
		overlaysTable = new Dictionary();
    }
	
	private function init() : Void 
	{ 
		reset();
		_initialised = true;
		if (_parent != null) _viewport = _parent
        else _viewport = cast((star.root), DisplayObjectContainer);
		_viewport.stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
		_worldContainer = new Sprite();
		_viewport.addChild(_worldContainer);
		_viewportOverlayContainer = new Sprite();
		_viewport.addChild(_viewportOverlayContainer);
		addRenderables();
		addOverlays();
		dispatchEvent(new RendererEvent(RendererEvent.INITIALISED));
		invalidate(RendererInvalidationTypes.VIEWPORT);
    }  
	
	//===== INSPECTABLE API ===================================================  
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="50"))
	private function set_AllowScale(value : Bool) : Bool
	{
		_allowScale = value;
        return value;
    }
	
	private function get_AllowScale() : Bool
	{
		return _allowScale;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="51"))
	private function set_DepthSort(value : Bool) : Bool
	{
		_depthSort = value;
        return value;
    }
	
	private function get_DepthSort() : Bool
	{
		return _depthSort;
    }
	
	@:meta(Inspectable(priority="52"))
	//[Serializable]  
	private function set_ViewportWidth(value : Float) : Float
	{
		if (_viewportWidth == value) return;
		_viewportWidth = value;
		invalidate(RendererInvalidationTypes.VIEWPORT);
        return value;
    }
	
	private function get_ViewportWidth() : Float
	{
		return _viewportWidth;
    }
	
	@:meta(Inspectable(priority="53"))
	//[Serializable]  
	private function set_ViewportHeight(value : Float) : Float
	{
		if (_viewportHeight == value) return;
		_viewportHeight = value;
		invalidate(RendererInvalidationTypes.VIEWPORT);
        return value;
    }
	
	private function get_ViewportHeight() : Float
	{
		return _viewportHeight;
    }  
	
	//==============================================================================  
	public function addToJuggler(object : IAnimatable) : Void
	{
		Starling.juggler.add(object);
    }
	
	public function removeFromJuggler(object : IAnimatable) : Void
	{
		Starling.juggler.remove(object);
    }
	
	override public function validateNow() : Void
	{
		if (isInvalid(RendererInvalidationTypes.VIEWPORT)) {
			validateViewport();
        }  
		
		//TODO: commented out for now as TouchEvents require start() to be used... 
		//if (star)	star.nextFrame();    
		 
		if (isInvalid(RendererInvalidationTypes.OVERLAYS)) {
			validateOverlays();
        }
		super.validateNow();
    }
	
	private function validateViewport() : Void
	{  
		// If _parent then enableToExisting() was called, meaning the renderer is embedded within a wider Starling scene,    
		// instead of the CadetScene being the only Starling content. If this is the case, the Renderer shouldn't update the    
		// Starling viewport as this can cause problems.  
		if (_parent != null) return;
		
		if (_nativeParent == null) return;
		
		var pt : Point; 
		pt = _nativeParent.localToGlobal(new Point(0, 0));
		_viewportX = pt.x;
		_viewportY = pt.y;
		var viewportRect : Rectangle = new Rectangle(_viewportX, _viewportY, _viewportWidth, _viewportHeight);star.viewPort = viewportRect;  
		// retain the original proportions of the stage content  
		if (!_allowScale) {
			star.stage.stageWidth = _viewportWidth;
			star.stage.stageHeight = _viewportHeight;
        }
    }
	
	private function validateOverlays() : Void
	{
		for (key in Reflect.fields(overlaysTable)) {
			var overlay : Overlay = cast((key), Overlay);
			overlay.validateNow();
        }
    }
	
	override private function addedToScene() : Void
	{
		scene.addEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler);
		scene.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedFromSceneHandler);
    }
	
	private function addRenderables() : Void
	{
		var allRenderables : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, IRenderable, true);
		for (renderable in allRenderables) {
			addRenderable(renderable);
        }
    }  
	
	/*	private function removeSkins():void
	{
		var allSkins:Vector.<IComponent> = ComponentUtil.getChildrenOfType( scene, IRenderable, true );
		for each ( var skin:IRenderable in allSkins )
		{
			removeSkin( skin );
		}
	}*/  
	
	private function componentAddedToSceneHandler(event : ComponentEvent) : Void
	{
		if (Std.is(event.component, IRenderable) == false) return;
		addRenderable(cast((event.component), IRenderable));
    }
	
	private function componentRemovedFromSceneHandler(event : ComponentEvent) : Void
	{
		if (Std.is(event.component, IRenderable) == false) return;
		removeRenderable(cast((event.component), IRenderable));
    }
	
	private function addRenderable(renderable : IRenderable) : Void
	{
		addRenderableToDisplayList(renderable);
		var displayObject : starling.display.DisplayObject = renderable.displayObject;
		renderable.invalidate("*");
		renderable.validateNow();
		renderable.addEventListener(ValidationEvent.INVALIDATE, invalidateRenderableHandler);
		Reflect.setField(skinTable, Std.string(displayObject), renderable);
    }
	
	private function removeRenderable(renderable : IRenderable) : Void
	{
		var displayObject : starling.display.DisplayObject = renderable.displayObject;
		removeRenderableFromDisplayList(renderable);
		renderable.removeEventListener(ValidationEvent.INVALIDATE, invalidateRenderableHandler);
    }
	
	private function invalidateRenderableHandler(event : ValidationEvent) : Void
	{  
		//var renderable:IRenderable = IRenderable(event.target);    
		//			var displayObject:starling.display.DisplayObject = AbstractSkin2D(renderable).displayObject;    
		/*			if ( displayObject.parent == null )
		{
			addRenderableToDisplayList(skin);
		}*/    // The the layer index, or containerID on a ISkin2D has changed, then re-add them    // to the displaylist at the appropriate place    
		/*			if ( event.invalidationType == "layer" || event.invalidationType == "container" )
		{
			addRenderableToDisplayList(skin);
		}*/  
    }
	
	private function addRenderableToDisplayList(renderable : IRenderable) : Void
	{
		if (_worldContainer == null) return;
		var displayObject : starling.display.DisplayObject = renderable.displayObject;
		if (depthSort) {
			var indexStr : String = renderable.indexStr;displayListVector.push(renderable);  
			//displayListVector.sortOn("indexStr");  
			displayListVector.sort(RenderablesUtil.sortSkinsById);
			var index : Int = Lambda.indexOf(displayListVector, renderable);  
			//trace("ADD SKIN INDEX "+indexStr+" at index "+index+" dlArray "+displayListVector);  
			_worldContainer.addChildAt(displayObject, index);
        } else {
			_worldContainer.addChild(displayObject);
        }
    }
	
	private function removeRenderableFromDisplayList(renderable : IRenderable) : Void
	{  
		//var indexStr:String = indexStrTable[skin];  
		var index : Int = Lambda.indexOf(displayListVector, renderable);  //indexStr);  
		displayListVector.splice(index, 1);  
		//trace("REMOVE SKIN INDEX "+skin.indexStr+" at index "+index+" dlArray "+displayListVector);  
		var displayObject : starling.display.DisplayObject = renderable.displayObject;
		if (displayObject.parent) {
			displayObject.parent.removeChild(displayObject);
        }
    }
	
	override private function removedFromScene() : Void
	{
		super.removedFromScene();
		while (_worldContainer.numChildren > 0) {
			var displayObject : starling.display.DisplayObject = _worldContainer.getChildAt(0);
			var skin : IRenderable = Reflect.field(skinTable, Std.string(displayObject));
			_worldContainer.removeChildAt(0);;
        }
    }
	
	public function addOverlay(overlay : Overlay, layerIndex : Int = 0) : Void
	{
		if (_viewportOverlayContainer == null) return;
		Reflect.setField(overlaysTable, Std.string(overlay), layerIndex);
		_viewportOverlayContainer.addChild(overlay);
    }
	
	public function removeOverlay(overlay : Overlay) : Void
	{
		var layerIndex : Int = Reflect.field(overlaysTable, Std.string(overlay));
		if (_viewportOverlayContainer.contains(overlay)) {
			_viewportOverlayContainer.removeChild(overlay);
        }
    }
	
	private function addOverlays() : Void
	{
		for (key in Reflect.fields(overlaysTable)) {
			var overlay : Overlay = cast((key), Overlay);
			addOverlay(overlay);
        }
    }
	
	private function removeOverlays() : Void
	{
		for (key in Reflect.fields(overlaysTable)) {
			var overlay : Overlay = cast((key), Overlay);
			removeOverlay(overlay);
        }
    }
	
	public function getOverlayOfType(type : Class<Dynamic>) : starling.display.DisplayObject
	{
		for (overlay/* AS3HX WARNING could not determine type for var: overlay exp: EIdent(overlaysTable) type: Dictionary */ in overlaysTable) {
			if (Std.is(overlay, type)) {
				return overlay;
            }
        }
		return null;
    }
	
	private function get_Viewport() : DisplayObjectContainer
	{
		return _viewport;
    }
	
	private function get_WorldContainer() : Sprite
	{
		return _worldContainer;
    }
	
	private function get_MouseX() : Float
	{
		return _mouseX;
    }
	
	private function get_MouseY() : Float
	{
		return _mouseY;
    }
	
	public function worldToViewport(pt : Point) : Point
	{
		if (_worldContainer == null) return null;
		pt = _worldContainer.localToGlobal(pt);
		return _viewport.globalToLocal(pt);
    }
	
	public function viewportToWorld(pt : Point) : Point
	{
		if (_viewport == null) return null;
		pt = _viewport.localToGlobal(pt);
		return _worldContainer.globalToLocal(pt);
    }
	
	public function setWorldContainerTransform(m : Matrix) : Void
	{
		if (_worldContainer == null) return;
		_worldContainer.transformationMatrix = m;
    }
	
	public function getNativeStage() : flash.display.Stage
	{
		return _nativeStage;
    }
	
	public function getNativeParent() : flash.display.DisplayObject
	{
		return _nativeParent;
    }
	
	private function get_Initialised() : Bool
	{
		return _initialised;
    }
	
	private function get_ViewportX() : Float
	{
		return _viewportX;
    }
	
	private function get_ViewportY() : Float
	{
		return _viewportY;
    }  
	
	//public function getWorldToViewportMatrix():Matrix { return identityMatrix.clone(); }    
	//public function getViewportToWorldMatrix():Matrix { return identityMatrix.clone(); }  
}