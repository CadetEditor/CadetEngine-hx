// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  
  
package cadet2d.components.skins;

import cadet2d.components.skins.Pin;
import cadet.events.ValidationEvent;
import cadet2d.components.connections.Pin;
import nme.geom.Point;
import starling.core.Starling;
import starling.display.Graphics;
import starling.display.Shape;  

//	[CadetEditor( transformable="false" )]  
class PinSkin extends AbstractSkin2D
{
    public var pin(get, set) : Pin;
    public var fillColor(get, set) : Int;
    public var fillAlpha(get, set) : Float;
    public var radius(get, set) : Float;
	private static inline var DISPLAY : String = "display";
	private static var helperPoint : Point = new Point();
	private var _fillColor : Int;
	private var _fillAlpha : Float;
	private var _radius : Float;
	private var _pin : Pin;
	private var _shape : Shape;
	
	public function new(fillColor : Int = 0xFFFFFF, fillAlpha : Float = 0.5, radius : Float = 5)
    {
        super();
		name = "PinSkin";
		this.fillColor = fillColor;
		this.fillAlpha = fillAlpha;
		this.radius = radius;
		_displayObject = new Shape();
		_shape = cast((_displayObject), Shape);
    }
	
	override private function addedToScene() : Void
	{
		super.addedToScene();
		addSiblingReference(Pin, "pin");
    }
	
	private function set_Pin(value : Pin) : Pin
	{
		if (_pin != null) {
			_pin.removeEventListener(ValidationEvent.INVALIDATE, invalidatePinHandler);
        }
		_pin = value;
		if (_pin != null) {
			_pin.addEventListener(ValidationEvent.INVALIDATE, invalidatePinHandler);
        }
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_Pin() : Pin
	{
		return _pin;
    }
	
	private function invalidatePinHandler(event : ValidationEvent) : Void
	{
		invalidate(DISPLAY);
    }
	
	override public function validateNow() : Void
	{
		if (isInvalid(DISPLAY)) {
			validateDisplay();
        }
		super.validateNow();
    }
	
	override private function validateDisplay() : Bool
	{
		if (!Starling.current) return false;
		var graphics : Graphics = _shape.graphics;
		graphics.clear();
		graphics.beginFill(_fillColor, _fillAlpha);
		graphics.drawCircle(0, 0, radius);
		super.validateDisplay();
		return true;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ColorPicker"))
	private function set_FillColor(value : Int) : Int
	{
		_fillColor = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_FillColor() : Int
	{
		return _fillColor;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_FillAlpha(value : Float) : Float
	{
		_fillAlpha = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_FillAlpha() : Float
	{
		return _fillAlpha;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_Radius(value : Float) : Float
	{
		_radius = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_Radius() : Float
	{
		return _radius;
    }
}