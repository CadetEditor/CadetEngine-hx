// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.geom;

import cadet2d.geom.QuadraticBezier;
 /**
 * This class wraps 2 BezierSegment classes and exposes 4 vertex positions (rather than the 6 contained within the 2 segments).
 * This class automatically adjusts the positions of its contained segments when required.
 * This makes dealing with the BezierSegment class much easier when describing a cubic bezier curve.
 * @author Jonathan Pace
 * 
 */  
 
class CubicBezier
{
    public var segmentA(get, set) : QuadraticBezier;
    public var segmentB(get, set) : QuadraticBezier;
    public var startX(get, set) : Float;
    public var startY(get, set) : Float;
    public var endX(get, set) : Float;
    public var endY(get, set) : Float;
    public var controlAX(get, set) : Float;
    public var controlAY(get, set) : Float;
    public var controlBX(get, set) : Float;
    public var controlBY(get, set) : Float;
	private var _segmentA : QuadraticBezier;
	private var _segmentB : QuadraticBezier;
	
	public function new(startX : Float = 0, startY : Float = 0, controlAX : Float = 0, controlAY : Float = 0, controlBX : Float = 0, controlBY : Float = 0, endX : Float = 0, endY : Float = 0)
    {
		_segmentA = new QuadraticBezier(startX, startY, controlAX, controlAY);
		_segmentB = new QuadraticBezier(0, 0, controlBX, controlBY, endX, endY);
		validate();
    }
	
	private function set_SegmentA(value : QuadraticBezier) : QuadraticBezier
	{
		_segmentA = value;
		validate();
        return value;
    }
	
	private function get_SegmentA() : QuadraticBezier
	{
		return _segmentA;
    }
	
	private function set_SegmentB(value : QuadraticBezier) : QuadraticBezier
	{
		_segmentB = value;
		validate();
        return value;
    }
	
	private function get_SegmentB() : QuadraticBezier
	{
		return _segmentB;
    }
	
	private function set_StartX(value : Float) : Float
	{
		_segmentA.startX = value;
        return value;
    }
	
	private function get_StartX() : Float
	{		
		return _segmentA.startX;
    }
	
	private function set_StartY(value : Float) : Float
	{
		_segmentA.startY = value;
        return value;
    }
	
	private function get_StartY() : Float
	{
		return _segmentA.startY;
    }
	
	private function set_EndX(value : Float) : Float
	{
		_segmentB.endX = value;
        return value;
    }
	
	private function get_EndX() : Float
	{
		return _segmentB.endX;
    }
	
	private function set_EndY(value : Float) : Float
	{
		_segmentB.endY = value;
        return value;
    }
	
	private function get_EndY() : Float
	{
		return _segmentB.endY;
    }
	
	private function set_ControlAX(value : Float) : Float
	{
		_segmentA.controlX = value;
		validate();
        return value;
    }
	
	private function get_ControlAX() : Float
	{
		return _segmentA.controlX;
    }
	
	private function set_ControlAY(value : Float) : Float
	{
		_segmentA.controlY = value;
		validate();
        return value;
    }
	
	private function get_ControlAY() : Float
	{
		return _segmentA.controlY;
    }
	
	private function set_ControlBX(value : Float) : Float
	{
		_segmentB.controlX = value;
		validate();
        return value;
    }
	
	private function get_ControlBX() : Float
	{
		return _segmentB.controlX;
    }
	
	private function set_ControlBY(value : Float) : Float
	{
		_segmentB.controlY = value;
		validate();
        return value;
    }
	
	private function get_ControlBY() : Float
	{
		return _segmentB.controlY;
    }
	
	private function validate() : Void
	{
		var dx : Float = segmentA.controlX - _segmentB.controlX;
		var dy : Float = segmentA.controlY - _segmentB.controlY;
		_segmentA.endX = _segmentA.controlX - dx * 0.5;
		_segmentA.endY = _segmentA.controlY - dy * 0.5;
		_segmentB.startX = _segmentA.endX;
		_segmentB.startY = _segmentA.endY;
    }
}