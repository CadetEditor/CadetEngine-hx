  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.textures;

import cadet3d.components.textures.BitmapCubeTexture;
import cadet3d.components.textures.BitmapData;
import away3d.textures.BitmapCubeTexture;import cadet.core.Component;import cadet.util.BitmapDataUtil;import cadet.util.NullBitmap;import cadet3d.util.NullBitmapCubeTexture;import nme.display.BitmapData;class BitmapCubeTextureComponent extends AbstractCubeTextureComponent
{
    public var positiveX(get, set) : BitmapData;
    public var negativeX(get, set) : BitmapData;
    public var positiveY(get, set) : BitmapData;
    public var negativeY(get, set) : BitmapData;
    public var positiveZ(get, set) : BitmapData;
    public var negativeZ(get, set) : BitmapData;
private var _bitmapCubeTexture : BitmapCubeTexture;public function new()
    {
        super();_cubeTexture = _bitmapCubeTexture = NullBitmapCubeTexture.getCopy();
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="100",editor="ResourceItemEditor"))
private function set_PositiveX(value : BitmapData) : BitmapData{_bitmapCubeTexture.positiveX = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_PositiveX() : BitmapData{return _bitmapCubeTexture.positiveX;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="101",editor="ResourceItemEditor"))
private function set_NegativeX(value : BitmapData) : BitmapData{_bitmapCubeTexture.negativeX = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_NegativeX() : BitmapData{return _bitmapCubeTexture.negativeX;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="102",editor="ResourceItemEditor"))
private function set_PositiveY(value : BitmapData) : BitmapData{_bitmapCubeTexture.positiveY = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_PositiveY() : BitmapData{return _bitmapCubeTexture.positiveY;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="103",editor="ResourceItemEditor"))
private function set_NegativeY(value : BitmapData) : BitmapData{_bitmapCubeTexture.negativeY = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_NegativeY() : BitmapData{return _bitmapCubeTexture.negativeY;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="104",editor="ResourceItemEditor"))
private function set_PositiveZ(value : BitmapData) : BitmapData{_bitmapCubeTexture.positiveZ = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_PositiveZ() : BitmapData{return _bitmapCubeTexture.positiveZ;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="105",editor="ResourceItemEditor"))
private function set_NegativeZ(value : BitmapData) : BitmapData{_bitmapCubeTexture.negativeZ = BitmapDataUtil.makePowerOfTwo(value, true) || NullBitmap.instance;invalidate("*");
        return value;
    }private function get_NegativeZ() : BitmapData{return _bitmapCubeTexture.negativeZ;
    }
}