package cadet3d.components.lights;

import cadet3d.components.lights.PointLight;
import away3d.lights.PointLight;

class PointLightComponent extends AbstractLightComponent
{
	public function new()
	{
		super();
		_object3D = _light = new PointLight();
		castsShadows = true;
	}
}