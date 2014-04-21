// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 100-149  

package cadet2d.components.connections;

import cadet2d.components.connections.Matrix;
import cadet2d.components.connections.Point;
import cadet.core.Component;
import cadet.events.ValidationEvent;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.Vertex;
import nme.geom.Matrix;
import nme.geom.Point;
import starling.utils.MatrixUtil;

class Pin extends Component
{
    public var transform(get, set) : Transform2D;
    public var transformA(get, set) : Transform2D;
    public var transformB(get, set) : Transform2D;
    public var localPos(get, set) : Vertex;
    public var label(get, never) : String;
	private static inline var TRANSFORM : String = "transform";
	private static inline var TRANSFORM_AB : String = "transformAB";
	private static var helperPoint : Point = new Point();
	private static var helperMatrix : Matrix = new Matrix();
	private var _transform : Transform2D;  // The transform sibling of the Pin component  
	private var _transformA : Transform2D;  // Pin uses this transform coordinate system (it's 'inside' this transform)  
	private var _transformB : Transform2D;  // Transform pinned to transformA  
	private var _localPos : Vertex;  // Local point in transform coordinate system.  
	
	public function new(name : String = "Pin")
    {
		super(name);
		_localPos = new Vertex();
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(Transform2D, "transform");
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
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_Transform() : Transform2D
	{
		return _transform;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="100"))
	private function set_TransformA(value : Transform2D) : Transform2D
	{
		if (_transformA != null) {
			_transformA.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformABHandler);
        }
		_transformA = value;
		if (_transformA != null) {
			_transformA.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformABHandler);
        }
		invalidate(TRANSFORM_AB);
        return value;
    }
	
	private function get_TransformA() : Transform2D
	{
		return _transformA;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="101"))
	private function set_TransformB(value : Transform2D) : Transform2D
	{
		if (_transformB != null) {
			_transformB.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformABHandler);
        }
		_transformB = value;
		if (_transformB != null) {
			_transformB.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformABHandler);
        }
		invalidate(TRANSFORM_AB);
        return value;
    }
	
	private function get_TransformB() : Transform2D
	{
		return _transformB;
    }
	
	@:meta(Serializable())
	private function set_LocalPos(value : Vertex) : Vertex
	{
		_localPos = value;
		invalidate(TRANSFORM);
        return value;
    }
	
	private function get_LocalPos() : Vertex
	{
		return _localPos;
    }
	
	private function invalidateTransformHandler(event : ValidationEvent) : Void
	{  
		//trace("INVALIDATE PIN TRANSFORM");  
		invalidate(TRANSFORM);
    }
	
	private function invalidateTransformABHandler(event : ValidationEvent) : Void
	{  
		//trace("INVALIDATE TRANSFORM AB");  
		invalidate(TRANSFORM_AB);
    }
	
	override public function validateNow() : Void
	{
		var skinAValid : Bool = true;
		if (isInvalid(TRANSFORM)) {
			validatePinLocalPosFromTransform();
        }
		if (isInvalid(TRANSFORM_AB)) {
			validatePinTransformFromSkin();
        }
		super.validateNow();
    }  
	
	// When you change the transform of SkinA, set the pin's transform to match the local pos  
	private function validatePinTransformFromSkin() : Void
	{
		if (_transform == null || _transformA == null) return;  
		
		//if (!_renderer || !_renderer.viewport) return;
		//if (!_skinA) return; 
		// Convert the point from local skin space to global (screen) space 
		//offset = _skinA.displayObject.localToGlobal(offset);    
 		
		MatrixUtil.transformCoords(_transformA.globalMatrix, _localPos.x, _localPos.y, helperPoint);
		helperMatrix.identity();
		if (_transform.parentTransform != null) {
			helperMatrix.concat(_transform.parentTransform.globalMatrix);
			helperMatrix.invert();
        }
		MatrixUtil.transformCoords(helperMatrix, helperPoint.x, helperPoint.y, helperPoint);
		_transform.x = helperPoint.x;
		_transform.y = helperPoint.y;
    }  
	
	// When you drag the pin itself around, set the pin's local pos to match its transform  
	
	private function validatePinLocalPosFromTransform() : Void
	{
		if (_transform == null || _transformA == null) return;  
  
		//if (!_renderer || !_renderer.viewport) return;
		//if (!_skinA) return; 
		
		// Get the global origin
		MatrixUtil.transformCoords(_transform.globalMatrix, 0, 0, helperPoint);
		helperMatrix.identity();
		helperMatrix.concat(_transformA.globalMatrix);
		helperMatrix.invert();  
		
		// Convert the point from global (screen) space to local _transformA space  
		MatrixUtil.transformCoords(helperMatrix, helperPoint.x, helperPoint.y, helperPoint);
		_localPos.x = helperPoint.x; 
		_localPos.y = helperPoint.y;
		invalidate(TRANSFORM);
		
		//trace("validatePinLocalPosFromTransform localPos x "+localPos.x+" y "+localPos.y);
    }
	
	private function get_Label() : String
	{
		return "Connection";
    }
}