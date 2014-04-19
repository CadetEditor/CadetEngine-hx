// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Abstract  package cadet3d.components.materials;

import cadet3d.components.materials.Component;
import cadet3d.components.materials.SinglePassMaterialBase;
import nme.errors.Error;
import away3d.materials.SinglePassMaterialBase;import cadet.core.Component;class AbstractMaterialComponent extends Component
{
    public var material(get, never) : SinglePassMaterialBase;
    public var alphaBlending(get, set) : Bool;
    public var blendMode(get, set) : String;
    public var depthCompareMode(get, set) : String;
    public var ambient(get, set) : Float;
    public var gloss(get, set) : Float;
    public var specular(get, set) : Float;
    public var ambientColor(get, set) : Int;
    public var specularColor(get, set) : Int;
private var _material : SinglePassMaterialBase;public function new()
    {
        super();
    }override public function dispose() : Void{super.dispose();try{_material.dispose();
        }        catch (e : Error){ };
    }private function get_Material() : SinglePassMaterialBase{return _material;
    }  /**
		 * Indicate whether or not the material has transparency. If binary transparency is sufficient, for
		 * example when using textures of foliage, consider using alphaThreshold instead.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="50"))
private function get_AlphaBlending() : Bool{return _material.alphaBlending;
    }private function set_AlphaBlending(value : Bool) : Bool{_material.alphaBlending = value;
        return value;
    }  /**
		 * The blend mode to use when drawing this renderable. The following blend modes are supported:
		 * <ul>
		 * <li>BlendMode.NORMAL</li>
		 * <li>BlendMode.MULTIPLY</li>
		 * <li>BlendMode.ADD</li>
		 * <li>BlendMode.ALPHA</li>
		 * </ul>
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="51",editor="DropDownMenu",dataProvider="[NORMAL,MULTIPLY,ADD,ALPHA]"))
private function get_BlendMode() : String{return _material.blendMode;
    }private function set_BlendMode(value : String) : String{_material.blendMode = value.toLowerCase();
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="52",editor="DropDownMenu",dataProvider="[always,equal,greater,greaterEqual,less,lessEqual,never,notEqual]"))
private function set_DepthCompareMode(value : String) : String{_material.depthCompareMode = value;
        return value;
    }private function get_DepthCompareMode() : String{return _material.depthCompareMode;
    }  /**
		 * The strength of the ambient reflection.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="53",editor="Slider",min="0",max="10",snapInterval="0.01",showMarkers="false"))
private function get_Ambient() : Float{return _material.ambient;
    }private function set_Ambient(value : Float) : Float{_material.ambient = value;
        return value;
    }  /**
		 * The sharpness of the specular highlight.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="54",editor="Slider",min="0",max="100",snapInterval="0.1",showMarkers="false"))
private function set_Gloss(value : Float) : Float{_material.gloss = value;
        return value;
    }private function get_Gloss() : Float{return _material.gloss;
    }  /**
		 * The overall strength of the specular reflection.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="55",editor="Slider",min="0",max="10",snapInterval="0.01",showMarkers="false"))
private function set_Specular(value : Float) : Float{_material.specular = value;
        return value;
    }private function get_Specular() : Float{return _material.specular;
    }  /**
		 * The colour of the ambient reflection.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="56",editor="ColorPicker"))
private function get_AmbientColor() : Int{return _material.ambientColor;
    }private function set_AmbientColor(value : Int) : Int{_material.ambientColor = value;
        return value;
    }  /**
		 * The colour of the specular reflection.
		 */  @:meta(Serializable())
@:meta(Inspectable(priority="57",editor="ColorPicker"))
private function get_SpecularColor() : Int{return _material.specularColor;
    }private function set_SpecularColor(value : Int) : Int{_material.specularColor = value;
        return value;
    }
}