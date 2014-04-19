package cadet2d.components.skins;

import cadet2d.components.skins.ITransform2D;
import nme.errors.Error;
import cadet.events.ValidationEvent;import cadet.util.Deg2rad;import cadet2d.components.transforms.ITransform2D;import cadet2d.components.transforms.Transform2D;import nme.geom.Matrix;class TransformableSkin extends AbstractSkin2D implements ITransform2D
{
    public var internalTransform(get, set) : Transform2D;
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var scaleX(get, set) : Float;
    public var scaleY(get, set) : Float;
    public var rotation(get, set) : Float;
    public var matrix(get, set) : Matrix;
    public var globalMatrix(get, never) : Matrix;
    public var parentTransform(get, set) : ITransform2D;
    public var serializedMatrix(get, set) : String;
private var _internalTransform : Transform2D = new Transform2D();public function new(name : String = "AbstractSkin2D")
    {super(name);
    }@:meta(Serializable())
private function set_InternalTransform(value : Transform2D) : Transform2D{if (_internalTransform != null) {_internalTransform.removeEventListener(ValidationEvent.INVALIDATE, onInternalTransformInvalidated);_internalTransform.cleanUpParentTransform();
        }_internalTransform = value;  // don't listen to internal transform's events, if sibling transform is available  if (_internalTransform != null) {if (_transform2D == null)                 _internalTransform.addEventListener(ValidationEvent.INVALIDATE, onInternalTransformInvalidated);if (parentComponent != null) {var parentTransform : Transform2D = Transform2D.findParentTransform(parentComponent.parentComponent);_internalTransform.setupParentTransform(parentTransform);
            }
        }
        return value;
    }private function get_InternalTransform() : Transform2D{return _internalTransform;
    }  // -------------------------------------------------------------------------------------    // ITRANSFORM2D API    // -------------------------------------------------------------------------------------  @:meta(Inspectable(priority="50"))
private function set_X(value : Float) : Float{if (_transform2D != null)             _transform2D.x = value
        else _internalTransform.x = value;invalidate(TRANSFORM);
        return value;
    }private function get_X() : Float{return _transform2D != (null) ? _transform2D.x : _internalTransform.x;
    }@:meta(Inspectable(priority="51"))
private function set_Y(value : Float) : Float{if (_transform2D != null)             _transform2D.y = value
        else _internalTransform.y = value;invalidate(TRANSFORM);
        return value;
    }private function get_Y() : Float{return _transform2D != (null) ? _transform2D.y : _internalTransform.y;
    }@:meta(Inspectable(priority="52"))
private function set_ScaleX(value : Float) : Float{if (_transform2D != null)             _transform2D.scaleX = value
        else _internalTransform.scaleX = value;invalidate(TRANSFORM);
        return value;
    }private function get_ScaleX() : Float{return _transform2D != (null) ? _transform2D.scaleX : _internalTransform.scaleX;
    }@:meta(Inspectable(priority="53"))
private function set_ScaleY(value : Float) : Float{if (_transform2D != null)             _transform2D.scaleY = value
        else _internalTransform.scaleY = value;invalidate(TRANSFORM);
        return value;
    }private function get_ScaleY() : Float{return _transform2D != (null) ? _transform2D.scaleY : _internalTransform.scaleY;
    }@:meta(Inspectable(priority="54",editor="Slider",min="0",max="360",snapInterval="1"))
private function set_Rotation(value : Float) : Float{if (_transform2D != null)             _transform2D.rotation = value
        else _internalTransform.rotation = value;invalidate(TRANSFORM);
        return value;
    }private function get_Rotation() : Float{return _transform2D != (null) ? _transform2D.rotation : _internalTransform.rotation;
    }private function set_Matrix(value : Matrix) : Matrix{if (_transform2D != null)             _transform2D.matrix = value
        else _internalTransform.matrix = value;invalidate(TRANSFORM);
        return value;
    }private function get_Matrix() : Matrix{return _transform2D != (null) ? _transform2D.matrix : _internalTransform.matrix;
    }private function get_GlobalMatrix() : Matrix{return _transform2D != (null) ? _transform2D.globalMatrix : _internalTransform.globalMatrix;
    }private function get_ParentTransform() : ITransform2D{return _transform2D != (null) ? _transform2D.parentTransform : _internalTransform.parentTransform;
    }private function set_ParentTransform(value : ITransform2D) : ITransform2D{throw new Error("setting parentTransform for TransformableSkin instance is not allowed");
        return value;
    }@:meta(Serializable(alias="matrix"))
private function set_SerializedMatrix(value : String) : String{var split : Array<Dynamic> = value.split(",");matrix = new Matrix(split[0], split[1], split[2], split[3], split[4], split[5]);
        return value;
    }private function get_SerializedMatrix() : String{var m : Matrix = matrix;return m.a + "," + m.b + "," + m.c + "," + m.d + "," + m.tx + "," + m.ty;
    }  // -------------------------------------------------------------------------------------  @:meta(Serializable())
override private function set_Transform2D(value : Transform2D) : Transform2D{super.transform2D = value;  // there's a sibling transform - listen to its events instead  if (_transform2D == null) {_internalTransform.removeEventListener(ValidationEvent.INVALIDATE, onInternalTransformInvalidated);_internalTransform.addEventListener(ValidationEvent.INVALIDATE, onInternalTransformInvalidated);_internalTransform.cleanUpParentTransform();if (parentComponent != null) {var parentTransform : Transform2D = Transform2D.findParentTransform(parentComponent.parentComponent);_internalTransform.setupParentTransform(parentTransform);
            }
        }
        else {_internalTransform.removeEventListener(ValidationEvent.INVALIDATE, onInternalTransformInvalidated);_internalTransform.cleanUpParentTransform();
        }
        return value;
    }override private function addedToScene() : Void{if (internalTransform == null)             internalTransform = new Transform2D();var excludedTypes : Array<Class<Dynamic>> = new Array<Class<Dynamic>>();excludedTypes.push(IRenderable);addSiblingReference(Transform2D, "transform2D", excludedTypes);invalidate(TRANSFORM);
    }override private function validateTransform() : Void{if (_transform2D != null) {super.validateTransform();
        }
        else if (_internalTransform.parentTransform != null) {_displayObject.transformationMatrix = _internalTransform.globalMatrix;
        }
        // if this is a top-level transform, simply set the properties (may be faster)
        else {_displayObject.x = _internalTransform.x;_displayObject.y = _internalTransform.y;_displayObject.scaleX = _internalTransform.scaleX;_displayObject.scaleY = _internalTransform.scaleY;_displayObject.rotation = deg2rad(_internalTransform.rotation);
        }
    }private function onInternalTransformInvalidated(event : ValidationEvent) : Void{invalidate(TRANSFORM);
    }
}