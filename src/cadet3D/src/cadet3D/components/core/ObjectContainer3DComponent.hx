  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Abstract  package cadet3d.components.core;

import cadet3d.components.core.ComponentContainer;
import cadet3d.components.core.IComponent;
import cadet3d.components.core.Matrix3D;
import cadet3d.components.core.ObjectContainer3D;
import nme.geom.Matrix3D;import away3d.containers.ObjectContainer3D;import cadet.core.ComponentContainer;import cadet.core.IComponent;@:meta(Event(name="object3DAdded",type="cadetAway3D4.events.Object3DComponentEvent"))
@:meta(Event(name="object3DRemoved",type="cadetAway3D4.events.Object3DComponentEvent"))
class ObjectContainer3DComponent extends ComponentContainer
{
    public var object3D(get, never) : ObjectContainer3D;
    public var serializedTransform(get, set) : String;
    public var transform(get, set) : Matrix3D;
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var z(get, set) : Float;
    public var rotationX(get, set) : Float;
    public var rotationY(get, set) : Float;
    public var rotationZ(get, set) : Float;
    public var scaleX(get, set) : Float;
    public var scaleY(get, set) : Float;
    public var scaleZ(get, set) : Float;
private var _object3D : ObjectContainer3D;public function new()
    {
        super();_object3D = new ObjectContainer3D();
    }override public function dispose() : Void{super.dispose();if (_object3D != null) {_object3D.dispose();
        }
    }override private function childAdded(child : IComponent, index : Int) : Void{super.childAdded(child, index);var object3DComponent : ObjectContainer3DComponent = try cast(child, ObjectContainer3DComponent) catch(e:Dynamic) null;if (object3DComponent == null)             return;_object3D.addChild(object3DComponent.object3D);
    }override private function childRemoved(child : IComponent) : Void{super.childRemoved(child);var object3DComponent : ObjectContainer3DComponent = try cast(child, ObjectContainer3DComponent) catch(e:Dynamic) null;if (object3DComponent == null)             return;if (object3DComponent.object3D.parent == null)             return;object3DComponent.object3D.parent.removeChild(object3DComponent.object3D);
    }private function get_Object3D() : ObjectContainer3D{return _object3D;
    }@:meta(Serializable(alias="transform"))
private function set_SerializedTransform(value : String) : String{var split : Array<Dynamic> = value.split(",");var v : Array<Float> = new Array<Float>();for (i in 0...split.length){v.push(Std.parseFloat(split[i]));
        }transform = new Matrix3D(v);
        return value;
    }private function get_SerializedTransform() : String{var m : Matrix3D = transform;var output : String = "";for (i in 0...m.rawData.length){output += m.rawData[i] + (i == m.rawData.length - (1) ? "" : ",");
        }return output;
    }private function get_Transform() : Matrix3D{return _object3D.transform;
    }private function set_Transform(value : Matrix3D) : Matrix3D{_object3D.transform = value;
        return value;
    }  /**
		 * Defines the x coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="100"))
private function get_X() : Float{return _object3D.x;
    }private function set_X(val : Float) : Float{_object3D.x = val;
        return val;
    }  /**
		 * Defines the y coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="101"))
private function get_Y() : Float{return _object3D.y;
    }private function set_Y(val : Float) : Float{_object3D.y = val;
        return val;
    }  /**
		 * Defines the z coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="102"))
private function get_Z() : Float{return _object3D.z;
    }private function set_Z(val : Float) : Float{_object3D.z = val;
        return val;
    }  /**
		 * Defines the euler angle of rotation of the 3d object around the x-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="106"))
private function get_RotationX() : Float{return _object3D.rotationX;
    }private function set_RotationX(val : Float) : Float{_object3D.rotationX = val;
        return val;
    }  /**
		 * Defines the euler angle of rotation of the 3d object around the y-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="107"))
private function get_RotationY() : Float{return _object3D.rotationY;
    }private function set_RotationY(val : Float) : Float{_object3D.rotationY = val;
        return val;
    }  /**
		 * Defines the euler angle of rotation of the 3d object around the z-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */  @:meta(Inspectable(priority="108"))
private function get_RotationZ() : Float{return _object3D.rotationZ;
    }private function set_RotationZ(val : Float) : Float{_object3D.rotationZ = val;
        return val;
    }  /**
		 * Defines the scale of the 3d object along the x-axis, relative to local coordinates.
		 */  @:meta(Inspectable(priority="103"))
private function get_ScaleX() : Float{return _object3D.scaleX;
    }private function set_ScaleX(val : Float) : Float{_object3D.scaleX = val;
        return val;
    }  /**
		 * Defines the scale of the 3d object along the y-axis, relative to local coordinates.
		 */  @:meta(Inspectable(priority="104"))
private function get_ScaleY() : Float{return _object3D.scaleY;
    }private function set_ScaleY(val : Float) : Float{_object3D.scaleY = val;
        return val;
    }  /**
		 * Defines the scale of the 3d object along the z-axis, relative to local coordinates.
		 */  @:meta(Inspectable(priority="105"))
private function get_ScaleZ() : Float{return _object3D.scaleZ;
    }private function set_ScaleZ(val : Float) : Float{_object3D.scaleZ = val;
        return val;
    }
}