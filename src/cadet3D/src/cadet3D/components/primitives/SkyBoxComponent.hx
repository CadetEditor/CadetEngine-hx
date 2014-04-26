package cadet3d.components.primitives;

import cadet3d.components.primitives.ObjectContainer3DComponent;
import cadet3d.components.primitives.SkyBox;
import cadet3d.components.primitives.SkyBoxMaterial;
import cadet3d.components.primitives.SkyBoxMaterialComponent;
import away3d.materials.SkyBoxMaterial;
import cadet3d.components.core.ObjectContainer3DComponent;
import cadet3d.components.materials.SkyBoxMaterialComponent;
import cadet3d.primitives.SkyBox;
import cadet3d.util.NullBitmapCubeTexture;

class SkyBoxComponent extends ObjectContainer3DComponent
{
	public var materialComponent(get, set) : SkyBoxMaterialComponent;
	private var _skyBox : SkyBox;private var _materialComponent : SkyBoxMaterialComponent;  
	//private var defaultBitmapData	:BitmapData = new BitmapData(256, 256, false, 0xFF0000);  
	
	public function new()
	{
		super();
		_object3D = _skyBox = new SkyBox(NullBitmapCubeTexture.getCopy());
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="150",editor="ComponentList",scope="scene"))
	private function get_materialComponent() : SkyBoxMaterialComponent
	{
		return _materialComponent;
	}
	
	private function set_materialComponent(value : SkyBoxMaterialComponent) : SkyBoxMaterialComponent
	{
		_materialComponent = value;
		if (_materialComponent != null) {
			_skyBox.material = _materialComponent.material;
		} else {
			_skyBox.material = new SkyBoxMaterial(NullBitmapCubeTexture.getCopy());
		}
		return value;
	}
}