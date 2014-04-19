// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.util;

import cadet3d.util.BitmapCubeTexture;
import away3d.textures.BitmapCubeTexture;import cadet.util.NullBitmap;class NullBitmapCubeTexture
{
    public static var instance(get, never) : BitmapCubeTexture;
private static var _instance : BitmapCubeTexture;private static function get_Instance() : BitmapCubeTexture{if (_instance == null) {_instance = getCopy();
        }return _instance;
    }public static function getCopy() : BitmapCubeTexture{return new BitmapCubeTexture(NullBitmap.instance, NullBitmap.instance, NullBitmap.instance, NullBitmap.instance, NullBitmap.instance, NullBitmap.instance);
    }

    public function new()
    {
    }
}