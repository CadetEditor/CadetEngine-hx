// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.behaviours;

import cadet.core.Component;
import cadet.events.ValidationEvent;
import cadet2d.components.processes.FootprintManagerProcess;
import cadet2d.components.transforms.Transform2D;

class SimpleFootprintBehaviour extends Component implements IFootprint
{
    public var footprintManager(get, set) : FootprintManagerProcess;
    public var transform(get, set) : Transform2D;
    public var x(get, never) : Int;
    public var y(get, never) : Int;
    public var sizeX(get, set) : Int;
    public var sizeY(get, set) : Int;
    public var values(get, never) : Array<Dynamic>;
	private var _x : Int;
	private var _y : Int;
	private var _sizeX : Int = 1;
	private var _sizeY : Int = 1;
	private var _values : Array<Dynamic>;
	private var _footprintManager : FootprintManagerProcess;
	private var _transform : Transform2D;
	
	public function new()
    {
        super();
		name = "SimpleFootprintBehaviour";
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(Transform2D, "transform");
		addSceneReference(FootprintManagerProcess, "footprintManager");
    }
	
	override private function removedFromScene() : Void
	{
		if (_footprintManager != null) {
			_footprintManager.removeFootprint(this);
        }
    }
	
	private function set_FootprintManager(value : FootprintManagerProcess) : FootprintManagerProcess
	{
		if (_footprintManager != null) {
			_footprintManager.removeFootprint(this);
        }
		_footprintManager = value;
		invalidate("values");
        return value;
    }
	
	private function get_FootprintManager() : FootprintManagerProcess
	{
		return _footprintManager;
    }
	
	override public function validateNow() : Void
	{
		if (isInvalid("values")) {
			validateValues();
        }
		super.validateNow();
    }
	
	private function validateValues() : Void
	{
		if (_transform == null) return;
		if (_footprintManager == null) return;
		_x = _transform.x;
		_y = _transform.y;
		_footprintManager.removeFootprint(this);
		_values = [];
		for (x in 0...sizeX) {
			_values[x] = [];
			for (y in 0...sizeY) {
				_values[x][y] = true;
            }
        }
		_footprintManager.addFootprint(this);
    }
	
	private function set_Transform(value : Transform2D) : Transform2D
	{
		if (_transform != null) {
			_transform.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		_transform = value;
		if (_transform != null) {
			_transform.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }
		invalidate("values");
        return value;
    }
	
	private function get_Transform() : Transform2D
	{
		return _transform;
    }
	
	private function invalidateTransformHandler(event : ValidationEvent) : Void
	{
		invalidate("values");
    }
	
	private function get_X() : Int
	{
		return _x;
    }
	
	private function get_Y() : Int
	{
		return _y;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_SizeX(value : Int) : Int
	{
		if (value == _sizeX) return;
		_sizeX = value;
		invalidate("values");
        return value;
    }
	
	private function get_SizeX() : Int
	{
		return _sizeX;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_SizeY(value : Int) : Int
	{
		if (value == _sizeY) return;
		_sizeY = value;
		invalidate("values");
        return value;
    }
	
	private function get_SizeY() : Int
	{
		return _sizeY;
    }
	
	private function get_Values() : Array<Dynamic>
	{
		return _values;
    }
}