// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.cameras;

import cadet3d.components.cameras.Camera3D;
import cadet3d.components.cameras.ObjectContainer3DComponent;
import cadet3d.components.cameras.OrthographicLens;
import cadet3d.components.cameras.PerspectiveLens;
import nme.errors.Error;
import away3d.cameras.Camera3D;import away3d.cameras.lenses.OrthographicLens;import away3d.cameras.lenses.PerspectiveLens;import cadet3d.components.core.ObjectContainer3DComponent;class CameraComponent extends ObjectContainer3DComponent
{
    public var camera(get, never) : Camera3D;
    public var lensFar(get, set) : Int;
    public var lensType(get, set) : String;
public static inline var PERSPECTIVE : String = "perspective";public static inline var ORTHOGRAPHIC : String = "orthographic";private var _camera : Camera3D;private var _lensType : String;public function new()
    {
        super();_object3D = _camera = new Camera3D();_lensType = PERSPECTIVE;
    }private function get_Camera() : Camera3D{return _camera;
    }@:meta(Serializable())
@:meta(Inspectable(priority="150"))
private function set_LensFar(value : Int) : Int{_camera.lens.far = value;
        return value;
    }private function get_LensFar() : Int{return _camera.lens.far;
    }private function set_LensType(value : String) : String{if (value == _lensType)             return;

        switch (value)
        {case PERSPECTIVE:_camera.lens = new PerspectiveLens();case ORTHOGRAPHIC:_camera.lens = new OrthographicLens();default:throw (new Error("Invalid lens type : " + value));return;
        }
        return value;
    }private function get_LensType() : String{return _lensType;
    }
}