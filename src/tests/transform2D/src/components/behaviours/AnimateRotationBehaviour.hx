package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.Transform2D;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet2d.components.transforms.Transform2D;

class AnimateRotationBehaviour extends Component implements ISteppableComponent
{
	public var transform2D : Transform2D;
	public var rotationSpeed : Float = 15;
	
	public function new(name : String = null)
	{
		super();
	}
	
	override private function addedToParent() : Void
	{
		addSiblingReference(Transform2D, "transform2D");
	}
	
	public function step(dt : Float) : Void
	{
		if (transform2D == null) return;
		transform2D.rotation += rotationSpeed * dt;
	}
}