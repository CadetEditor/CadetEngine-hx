// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.textures;

import cadet3d.components.textures.Component;
import cadet3d.components.textures.CubeTextureBase;
import away3d.textures.CubeTextureBase;import away3d.textures.Texture2DBase;import cadet.core.Component;class AbstractCubeTextureComponent extends Component
{
    public var cubeTexture(get, never) : CubeTextureBase;
private var _cubeTexture : CubeTextureBase;public function new()
    {
        super();
    }override public function dispose() : Void{_cubeTexture.dispose();super.dispose();
    }private function get_CubeTexture() : CubeTextureBase{return _cubeTexture;
    }
}