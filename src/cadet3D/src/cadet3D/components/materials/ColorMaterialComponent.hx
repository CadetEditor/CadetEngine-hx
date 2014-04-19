  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.materials;

import cadet3d.components.materials.ColorMaterial;
import away3d.materials.ColorMaterial;import away3d.materials.methods.FilteredShadowMapMethod;import nme.display.BlendMode;class ColorMaterialComponent extends AbstractMaterialComponent
{
    public var color(get, set) : Int;
private var _colorMaterial : ColorMaterial;public function new(material : ColorMaterial = null)
    {
        super();if (material != null) {_material = _colorMaterial = material;
        }
        else {_material = _colorMaterial = new ColorMaterial(0xCCCCCC);
        }
    }  /**
		 * The diffuse color of the surface.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="100",editor="ColorPicker"))
private function get_Color() : Int{return _colorMaterial.color;
    }private function set_Color(value : Int) : Int{_colorMaterial.color = value;
        return value;
    }
}