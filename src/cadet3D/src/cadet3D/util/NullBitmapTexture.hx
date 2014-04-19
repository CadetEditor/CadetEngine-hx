  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.util;

import cadet3d.util.BitmapTexture;
import away3d.textures.BitmapTexture;import cadet.util.NullBitmap;class NullBitmapTexture
{
    public static var instance(get, never) : BitmapTexture;
private static var _instance : BitmapTexture;private static function get_Instance() : BitmapTexture{if (_instance == null) {_instance = new BitmapTexture(NullBitmap.instance);
        }return _instance;
    }

    public function new()
    {
    }
}