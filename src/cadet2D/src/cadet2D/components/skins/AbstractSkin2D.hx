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

package cadet2d.components.skins;

import cadet2d.components.skins.Component;
import cadet2d.components.skins.DisplayObject;
import cadet2d.components.skins.IComponent;
import cadet2d.components.skins.IComponentContainer;
import cadet2d.components.skins.IRenderable;
import cadet2d.components.skins.Sprite;
import cadet2d.components.skins.Transform2D;
import cadet2d.components.skins.ValidationEvent;
import nme.errors.Error;
import cadet.core.Component;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.events.ValidationEvent;
import cadet.util.Deg2rad;
import cadet2d.components.transforms.Transform2D;
import starling.display.DisplayObject;
import starling.display.Sprite;

class AbstractSkin2D extends Component implements IRenderable
{
    public var displayObject(get, never) : DisplayObject;
    public var indexStr(get, never) : String;
    public var transform2D(get, set) : Transform2D;
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var visible(get, set) : Bool;
    public var touchable(get, set) : Bool;
	private var _displayObject : DisplayObject;
	private static inline var TRANSFORM : String = "transform";
	private static inline var DISPLAY : String = "display";
	private var _transform2D : Transform2D;
	private var _indexStr : String;
	private var _width : Float = 0;
	private var _height : Float = 0;
	
	public function new(name : String = "AbstractSkin2D")
    {
		super(name);
		_displayObject = new Sprite();
    }
	
	override private function addedToScene() : Void
	{
		var excludedTypes : Array<Class<Dynamic>> = new Array<Class<Dynamic>>();
		excludedTypes.push(IRenderable);
		addSiblingReference(Transform2D, "transform2D", excludedTypes);
		invalidate(TRANSFORM);
    }
	
	private function get_DisplayObject() : DisplayObject
	{
		return _displayObject;
    }
	
	override public function toString() : String
	{
		return _indexStr;
    }
	
	private function get_IndexStr() : String
	{  
		// Refresh the indices  
		var component : IComponent = this;
		while (component.parentComponent) {
			component.index = component.parentComponent.children.getItemIndex(component);
			component = component.parentComponent;
        }  
		// Refresh the indexStr  
		var indexArr : Array<Dynamic> = [index];
		var parent : IComponentContainer = parentComponent;
		while (parent) {
			if (parent.index != -1) {
				indexArr.push(parent.index);
            } else {
				break;
            }
			parent = parent.parentComponent;
        }
		indexArr.reverse();
		_indexStr = Std.string(indexArr);
		_indexStr = _indexStr.replace(",", "_");
		return _indexStr;
    }
	
	@:meta(Serializable())
	private function set_Transform2D(value : Transform2D) : Transform2D
	{
		if (_transform2D != null) {
			_transform2D.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		_transform2D = value;
		if (_transform2D != null) {
			_transform2D.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
			_displayObject.transformationMatrix = _transform2D.globalMatrix;
        }
        return value;
    }
	
	private function get_Transform2D() : Transform2D
	{
		return _transform2D;
    }
	
	private function invalidateTransformHandler(event : ValidationEvent) : Void
	{  
		//_displayObject.transformationMatrix = _transform2D.globalMatrix;  
		invalidate(TRANSFORM);
    }
	
	override public function validateNow() : Void
	{
		var displayValidated : Bool = true;
		if (isInvalid(TRANSFORM)) {
			validateTransform();
        }
		if (isInvalid(DISPLAY)) {
			displayValidated = validateDisplay();
        }
		super.validateNow();
		if (!displayValidated) {
			invalidate(DISPLAY);
        }
    }
	
	private function validateTransform() : Void
	{
		if (_transform2D == null) return;
		// if this transform uses parent coords space, copy the global matrix to display object  
		if (_transform2D.parentTransform) {
			_displayObject.transformationMatrix = _transform2D.globalMatrix;
        }
        // if this is a top-level transform, simply set the properties (may be faster)
        else {
			_displayObject.x = _transform2D.x;
			_displayObject.y = _transform2D.y;
			_displayObject.scaleX = _transform2D.scaleX;
			_displayObject.scaleY = _transform2D.scaleY;
			_displayObject.rotation = deg2rad(_transform2D.rotation);
        }
    }
	
	private function validateDisplay() : Bool
	{  
		//_displayObject.width = _width;    
		//_displayObject.height = _height;  
		return true;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="55"))
	private function set_Width(value : Float) : Float
	{
		if (Math.isNaN(value)) {
			throw (new Error("value is not a number"));
        }
		_width = value;invalidate(DISPLAY);
        return value;
    }
	
	private function get_Width() : Float
	{
		return _width;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="56"))
	private function set_Height(value : Float) : Float
	{
		if (Math.isNaN(value)) {
			throw (new Error("value is not a number"));
        }
		_height = value;invalidate(DISPLAY);
        return value;
    }
	
	private function get_Height() : Float
	{
		return _height;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="57"))
	private function get_Visible() : Bool
	{
		return _displayObject.visible;
    }
	
	private function set_Visible(value : Bool) : Bool
	{
		_displayObject.visible = value;
        return value;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="58"))
	private function set_Touchable(value : Bool) : Bool
	{
		_displayObject.touchable = value;
        return value;
    }
	
	private function get_Touchable() : Bool
	{
		return _displayObject.touchable;
    }
	
	public function clone() : IRenderable
	{
		throw (cast(("Abstract method"), Error));
    }
}