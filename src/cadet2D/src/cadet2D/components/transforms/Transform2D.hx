  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Inspectable Priority range 50-99  package cadet2d.components.transforms;

import cadet2d.components.transforms.Component;
import cadet2d.components.transforms.DisplayObject;
import cadet2d.components.transforms.DisplayObjectContainer;
import cadet2d.components.transforms.IComponentContainer;
import cadet2d.components.transforms.PropertyChangeEvent;
import cadet2d.components.transforms.Shape;
import cadet2d.components.transforms.ValidationEvent;
import nme.errors.Error;
import cadet.core.Component;import cadet.core.IComponentContainer;import cadet.events.ValidationEvent;import cadet.util.ComponentUtil;import cadet.util.Deg2rad;import cadet.util.Rad2deg;import core.events.PropertyChangeEvent;import nme.geom.Matrix;import starling.display.DisplayObject;import starling.display.DisplayObjectContainer;import starling.display.Shape;@:meta(Cadet(inheritFromTemplate="false"))
class Transform2D extends Component implements ITransform2D
{
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var scaleX(get, set) : Float;
    public var scaleY(get, set) : Float;
    public var rotation(get, set) : Float;
    public var matrix(get, set) : Matrix;
    public var globalMatrix(get, never) : Matrix;
    public var parentTransform(get, set) : ITransform2D;
    public var serializedMatrix(get, set) : String;
private var _x : Float = 0;private var _y : Float = 0;private var _scaleX : Float = 1;private var _scaleY : Float = 1;  // Rotation values are stored in degrees for ease of hand editing, then converted    // to radians when passed to Starling DisplayObject  private var _rotation : Float = 0;private var _globalMatrix : Matrix = new Matrix();private var _displayObject : DisplayObject;private var _parentTransform : Transform2D = null;public var dispatchEvents : Bool = false;  // Added as a speed optimisation  private static inline var TRANSFORM : String = "transform";public static inline var PROPERTY_CHANGE_X : String = "propertyChange_x";public static inline var PROPERTY_CHANGE_Y : String = "propertyChange_y";public static inline var PROPERTY_CHANGE_SCALEX : String = "propertyChange_scaleX";public static inline var PROPERTY_CHANGE_SCALEY : String = "propertyChange_scaleY";public static inline var PROPERTY_CHANGE_ROTATION : String = "propertyChange_rotation";public static function findParentTransform(parent : IComponentContainer) : Transform2D{var transform : Transform2D = null;while (parent != null){transform = ComponentUtil.getChildOfType(parent, Transform2D);if (transform != null)                 break;parent = parent.parentComponent;
        }return transform;
    }public function new(x : Float = 0, y : Float = 0, rotation : Float = 0, scaleX : Float = 1, scaleY : Float = 1)
    {super("Transform2D");_displayObject = new Shape();this.x = x;this.y = y;this.rotation = rotation;this.scaleX = scaleX;this.scaleY = scaleY;
    }@:meta(Inspectable(priority="50"))
private function set_X(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_x = value;invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_X, null, value));
        }
        return value;
    }private function get_X() : Float{return _x;
    }@:meta(Inspectable(priority="51"))
private function set_Y(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_y = value;invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_Y, null, value));
        }
        return value;
    }private function get_Y() : Float{return _y;
    }@:meta(Inspectable(priority="52"))
private function set_ScaleX(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_scaleX = value;invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_SCALEX, null, value));
        }
        return value;
    }private function get_ScaleX() : Float{return _scaleX;
    }@:meta(Inspectable(priority="53"))
private function set_ScaleY(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_scaleY = value;invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_SCALEY, null, value));
        }
        return value;
    }private function get_ScaleY() : Float{return _scaleY;
    }@:meta(Inspectable(priority="54",editor="Slider",min="0",max="360",snapInterval="1"))
private function set_Rotation(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_rotation = value;invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_ROTATION, null, value));
        }
        return value;
    }private function get_Rotation() : Float{return _rotation;
    }private function set_Matrix(value : Matrix) : Matrix{_displayObject.transformationMatrix = value;_x = _displayObject.x;_y = _displayObject.y;_scaleX = _displayObject.scaleX;_scaleY = _displayObject.scaleY;_rotation = rad2deg(_displayObject.rotation);invalidate(TRANSFORM);if (dispatchEvents) {dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_X, null, _displayObject.x));dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_Y, null, _displayObject.y));dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_SCALEX, null, _displayObject.scaleX));dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_SCALEY, null, _displayObject.scaleY));dispatchEvent(new PropertyChangeEvent(PROPERTY_CHANGE_ROTATION, null, _displayObject.rotation));
        }
        return value;
    }private function get_Matrix() : Matrix{if (isInvalid(TRANSFORM)) {validateTransform();
        }return _displayObject.transformationMatrix;
    }private function get_GlobalMatrix() : Matrix{if (isInvalid(TRANSFORM)) {validateTransform();
        }return _globalMatrix;
    }@:meta(Serializable())
private function set_ParentTransform(value : ITransform2D) : ITransform2D{cleanUpParentTransform();setupParentTransform(cast((value), Transform2D));
        return value;
    }private function get_ParentTransform() : ITransform2D{return _parentTransform;
    }@:meta(Serializable(alias="matrix"))
private function set_SerializedMatrix(value : String) : String{var split : Array<Dynamic> = value.split(",");matrix = new Matrix(split[0], split[1], split[2], split[3], split[4], split[5]);
        return value;
    }private function get_SerializedMatrix() : String{var m : Matrix = matrix;return m.a + "," + m.b + "," + m.c + "," + m.d + "," + m.tx + "," + m.ty;
    }public function setupParentTransform(transform : Transform2D) : Void{if (parentTransform != null)             throw new Error("parentTransform already set, call cleanUpParentTransform() first");if (transform != null) {_parentTransform = transform;var container : DisplayObjectContainer = cast((_parentTransform._displayObject), DisplayObjectContainer);container.addChild(_displayObject);invalidate(TRANSFORM);_parentTransform.addEventListener(ValidationEvent.INVALIDATE, onParentTransformInvalidated);
        }
    }public function cleanUpParentTransform() : Void{if (_parentTransform != null) {_parentTransform.removeEventListener(ValidationEvent.INVALIDATE, onParentTransformInvalidated);_displayObject.removeFromParent();_parentTransform = null;invalidate(TRANSFORM);
        }
    }override public function validateNow() : Void{if (isInvalid(TRANSFORM)) {validateTransform();
        }super.validateNow();
    }private function validateTransform() : Void{_displayObject.x = _x;_displayObject.y = _y;_displayObject.scaleX = _scaleX;_displayObject.scaleY = _scaleY;_displayObject.rotation = deg2rad(_rotation);_displayObject.getTransformationMatrix(null, _globalMatrix);
    }override private function addedToScene() : Void{  // it's already set when deserializing  if (_parentTransform == null) {var transform : Transform2D = findParentTransform(parentComponent.parentComponent);setupParentTransform(transform);
        }
    }override private function removedFromScene() : Void{cleanUpParentTransform();
    }private function onParentTransformInvalidated(event : ValidationEvent) : Void{invalidate(TRANSFORM);
    }
}