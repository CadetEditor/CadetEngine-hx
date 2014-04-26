package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.Rectangle;
import components.behaviours.Sprite3DComponent;
import components.behaviours.Vector3D;
import nme.geom.Rectangle;
import nme.geom.Vector3D;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet3d.components.core.Sprite3DComponent;

class BounceBehaviour extends Component implements ISteppableComponent
{
	public var velocity : Vector3D;
	public var sprite3D : Sprite3DComponent;
	public var gravity : Int = 3;
	public var screenRect : Rectangle;
	
	public function new()
	{
		super();
	}
	
	public function step(dt : Float) : Void
	{
		sprite3D.x += velocity.x;
		sprite3D.y += velocity.y;
		sprite3D.z += velocity.z;
		velocity.y -= gravity;
		
		if (sprite3D.x > screenRect.right) {
			velocity.x *= -1;
			sprite3D.x = screenRect.right;
		} else if (sprite3D.x < screenRect.left) {
			velocity.x *= -1;
			sprite3D.x = screenRect.left;
		}
		if (sprite3D.z > screenRect.right) {
			velocity.z *= -1;
			sprite3D.z = screenRect.right;
		}
		// Ceiling
		else if (sprite3D.z < screenRect.left) {
			velocity.z *= -1;
			sprite3D.z = screenRect.left;
		}
		if (sprite3D.y > screenRect.bottom) {
			velocity.y = 0;
			sprite3D.y = screenRect.bottom;
		}
		// Floor
		else if (sprite3D.y < screenRect.top) {
			velocity.y *= -0.8;
			sprite3D.y = screenRect.top;
			if (Math.random() > 0.5) {
				velocity.y += Math.random() * 12;
			}
		}
	}
}