package cadet3d.components.core;

import cadet3d.components.core.Sprite3D;
import cadet3d.components.core.TextureMaterial;
import away3d.entities.Sprite3D;import away3d.materials.TextureMaterial;import cadet3d.components.materials.AbstractMaterialComponent;import cadet3d.util.NullBitmapTexture;class Sprite3DComponent extends ObjectContainer3DComponent
{
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var materialComponent(get, set) : AbstractMaterialComponent;
private var _sprite3D : Sprite3D;private var _materialComponent : AbstractMaterialComponent;public function new()
    {
        super();_object3D = _sprite3D = new Sprite3D(new TextureMaterial(NullBitmapTexture.instance, true, true, true), 128, 128);
    }@:meta(Serializable())
@:meta(Inspectable(priority="150"))
private function get_Width() : Float{return _sprite3D.width;
    }private function set_Width(value : Float) : Float{_sprite3D.width = value;
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="151"))
private function get_Height() : Float{return _sprite3D.height;
    }private function set_Height(value : Float) : Float{_sprite3D.height = value;
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="152",editor="ComponentList",scope="scene"))
private function get_MaterialComponent() : AbstractMaterialComponent{return _materialComponent;
    }private function set_MaterialComponent(value : AbstractMaterialComponent) : AbstractMaterialComponent{_materialComponent = value;if (_materialComponent != null) {_sprite3D.material = _materialComponent.material;
        }
        else {_sprite3D.material = null;
        }
        return value;
    }
}