  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.textures;

import away3d.textures.Texture2DBase;import cadet.core.Component;class AbstractTexture2DComponent extends Component
{
    public var texture2D(get, never) : Texture2DBase;
private var _texture2D : Texture2DBase;public function new()
    {
        super();
    }override public function dispose() : Void{_texture2D.dispose();super.dispose();
    }private function get_Texture2D() : Texture2DBase{return _texture2D;
    }
}