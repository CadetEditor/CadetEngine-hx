  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.materials;

import cadet3d.components.materials.AbstractTexture2DComponent;
import cadet3d.components.materials.EnvMapMethod;
import cadet3d.components.materials.TextureMaterial;
import away3d.materials.TextureMaterial;import away3d.materials.methods.EnvMapMethod;import cadet.events.ValidationEvent;import cadet3d.components.textures.AbstractTexture2DComponent;import cadet3d.components.textures.BitmapCubeTextureComponent;import cadet3d.util.NullBitmapTexture;class TextureMaterialComponent extends AbstractMaterialComponent
{
    public var alphaThreshold(get, set) : Float;
    public var envMapAlpha(get, set) : Float;
    public var ambientTexture(get, set) : AbstractTexture2DComponent;
    public var diffuseTexture(get, set) : AbstractTexture2DComponent;
    public var environmentMap(get, set) : BitmapCubeTextureComponent;
    public var normalMap(get, set) : AbstractTexture2DComponent;
    public var specularMap(get, set) : AbstractTexture2DComponent;
private var _textureMaterial : TextureMaterial;private var _ambientTexture : AbstractTexture2DComponent;private var _diffuseTexture : AbstractTexture2DComponent;private var _normalMap : AbstractTexture2DComponent;private var _specularMap : AbstractTexture2DComponent;private var _environmentMap : BitmapCubeTextureComponent;private var _envMapMethod : EnvMapMethod;private var _envMapAlpha : Float = 1;public function new()
    {
        super();_material = _textureMaterial = new TextureMaterial(NullBitmapTexture.instance, true, true, true);
    }override public function dispose() : Void{diffuseTexture = null;normalMap = null;super.dispose();
    }@:meta(Serializable())
@:meta(Inspectable(priority="100",editor="Slider",min="0",max="1",snapInterval="0.01",showMarkers="false"))
private function set_AlphaThreshold(value : Float) : Float{_material.alphaThreshold = value;
        return value;
    }private function get_AlphaThreshold() : Float{return _material.alphaThreshold;
    }@:meta(Serializable())
@:meta(Inspectable(priority="101",editor="Slider",min="0",max="1",snapInterval="0.01",showMarkers="false"))
private function set_EnvMapAlpha(value : Float) : Float{if (_envMapMethod != null) {_envMapMethod.alpha = value;
        }_envMapAlpha = value;
        return value;
    }private function get_EnvMapAlpha() : Float{return _envMapAlpha;
    }@:meta(Serializable())
@:meta(Inspectable(priority="102",editor="ComponentList",scope="scene"))
private function set_AmbientTexture(value : AbstractTexture2DComponent) : AbstractTexture2DComponent{if (_ambientTexture != null) {_ambientTexture.removeEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseTextureHandler);
        }_ambientTexture = value;if (_ambientTexture != null) {_ambientTexture.addEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseTextureHandler);
        }updateAmbientTexture();
        return value;
    }private function get_AmbientTexture() : AbstractTexture2DComponent{return _ambientTexture;
    }@:meta(Serializable())
@:meta(Inspectable(priority="103",editor="ComponentList",scope="scene"))
private function set_DiffuseTexture(value : AbstractTexture2DComponent) : AbstractTexture2DComponent{if (_diffuseTexture != null) {_diffuseTexture.removeEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseTextureHandler);
        }_diffuseTexture = value;if (_diffuseTexture != null) {_diffuseTexture.addEventListener(ValidationEvent.INVALIDATE, invalidateDiffuseTextureHandler);
        }updateDiffuseTexture();
        return value;
    }private function get_DiffuseTexture() : AbstractTexture2DComponent{return _diffuseTexture;
    }@:meta(Serializable())
@:meta(Inspectable(priority="104",editor="ComponentList",scope="scene"))
private function set_EnvironmentMap(value : BitmapCubeTextureComponent) : BitmapCubeTextureComponent{if (_environmentMap != null) {_environmentMap.removeEventListener(ValidationEvent.INVALIDATE, invalidateEnvironmentMapHandler);
        }_environmentMap = value;if (_environmentMap != null) {_environmentMap.addEventListener(ValidationEvent.INVALIDATE, invalidateEnvironmentMapHandler);
        }updateEnvironmentMap();
        return value;
    }private function get_EnvironmentMap() : BitmapCubeTextureComponent{return _environmentMap;
    }@:meta(Serializable())
@:meta(Inspectable(priority="105",editor="ComponentList",scope="scene"))
private function set_NormalMap(value : AbstractTexture2DComponent) : AbstractTexture2DComponent{if (_normalMap != null) {_normalMap.removeEventListener(ValidationEvent.INVALIDATE, invalidateNormalMapHandler);
        }_normalMap = value;if (_normalMap != null) {_normalMap.addEventListener(ValidationEvent.INVALIDATE, invalidateNormalMapHandler);
        }updateNormalMap();
        return value;
    }private function get_NormalMap() : AbstractTexture2DComponent{return _normalMap;
    }@:meta(Serializable())
@:meta(Inspectable(priority="106",editor="ComponentList",scope="scene"))
private function set_SpecularMap(value : AbstractTexture2DComponent) : AbstractTexture2DComponent{if (_specularMap != null) {_specularMap.removeEventListener(ValidationEvent.INVALIDATE, invalidateSpecularMapHandler);
        }_specularMap = value;if (_specularMap != null) {_specularMap.addEventListener(ValidationEvent.INVALIDATE, invalidateSpecularMapHandler);
        }updateSpecularMap();
        return value;
    }private function get_SpecularMap() : AbstractTexture2DComponent{return _specularMap;
    }private function invalidateDiffuseTextureHandler(event : ValidationEvent) : Void{updateDiffuseTexture();
    }private function invalidateNormalMapHandler(event : ValidationEvent) : Void{updateNormalMap();
    }private function invalidateEnvironmentMapHandler(event : ValidationEvent) : Void{updateEnvironmentMap();
    }private function invalidateSpecularMapHandler(event : ValidationEvent) : Void{updateSpecularMap();
    }private function updateAmbientTexture() : Void{if (_ambientTexture != null) {_textureMaterial.ambientTexture = _ambientTexture.texture2D;
        }
        else {_textureMaterial.ambientTexture = NullBitmapTexture.instance;
        }
    }private function updateDiffuseTexture() : Void{if (_diffuseTexture != null) {_textureMaterial.texture = _diffuseTexture.texture2D;
        }
        else {_textureMaterial.texture = NullBitmapTexture.instance;
        }
    }private function updateEnvironmentMap() : Void{if (_environmentMap != null) {if (_envMapMethod == null) {_envMapMethod = new EnvMapMethod(_environmentMap.cubeTexture);_material.addMethod(_envMapMethod);_envMapMethod.alpha = _envMapAlpha;
            }
            else {_envMapMethod.envMap = _environmentMap.cubeTexture;
            }
        }
        else {if (_envMapMethod != null) {_material.removeMethod(_envMapMethod);_envMapMethod = null;
            }
        }
    }private function updateNormalMap() : Void{if (_normalMap != null) {_textureMaterial.normalMap = _normalMap.texture2D;
        }
        else {_textureMaterial.normalMap = NullBitmapTexture.instance;
        }
    }private function updateSpecularMap() : Void{if (_specularMap != null) {_textureMaterial.specularMap = _specularMap.texture2D;
        }
        else {_textureMaterial.specularMap = NullBitmapTexture.instance;
        }
    }
}