package cadet3d.components.materials;

import cadet3d.components.materials.BitmapCubeTextureComponent;
import cadet3d.components.materials.SkyBoxMaterial;
import cadet3d.components.materials.ValidationEvent;
import away3d.materials.SkyBoxMaterial;import away3d.textures.BitmapCubeTexture;import cadet.core.Component;import cadet.events.ValidationEvent;import cadet3d.components.textures.BitmapCubeTextureComponent;import cadet3d.util.NullBitmapCubeTexture;import nme.display.BitmapData;class SkyBoxMaterialComponent extends Component
{
    public var material(get, never) : SkyBoxMaterial;
    public var cubeTexture(get, set) : BitmapCubeTextureComponent;
private var _skyBoxMaterial : SkyBoxMaterial;private var _bmpCubeTextureComponent : BitmapCubeTextureComponent;  //private var defaultBitmapData	:BitmapData = new BitmapData(256, 256, false, 0xFF0000);  public function new()
    {
        super();_skyBoxMaterial = new SkyBoxMaterial(NullBitmapCubeTexture.getCopy());
    }private function get_Material() : SkyBoxMaterial{return _skyBoxMaterial;
    }@:meta(Serializable())
@:meta(Inspectable(priority="100",editor="ComponentList",scope="scene"))
private function set_CubeTexture(value : BitmapCubeTextureComponent) : BitmapCubeTextureComponent{if (_bmpCubeTextureComponent != null) {_bmpCubeTextureComponent.removeEventListener(ValidationEvent.INVALIDATE, invalidateTextureHandler);
        }_bmpCubeTextureComponent = value;if (_bmpCubeTextureComponent != null) {_bmpCubeTextureComponent.addEventListener(ValidationEvent.INVALIDATE, invalidateTextureHandler);
        }updateCubeTexture();
        return value;
    }private function get_CubeTexture() : BitmapCubeTextureComponent{return _bmpCubeTextureComponent;
    }private function invalidateTextureHandler(event : ValidationEvent) : Void{updateCubeTexture();
    }private function updateCubeTexture() : Void{if (_bmpCubeTextureComponent != null) {_skyBoxMaterial.cubeMap = _bmpCubeTextureComponent.cubeTexture;
        }
        else {_skyBoxMaterial.cubeMap = NullBitmapCubeTexture.getCopy();
        }
    }
}