package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.MeshComponent;
import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet3d.components.core.MeshComponent;class AnimateRotationBehaviour extends Component implements ISteppableComponent
{public var mesh : MeshComponent;public var rotationSpeed : Float = 30;public function new(name : String = null)
    {super();
    }override private function addedToParent() : Void{if (Std.is(parentComponent, MeshComponent)) {mesh = cast((parentComponent), MeshComponent);
        }
    }public function step(dt : Float) : Void{if (mesh == null)             return;mesh.rotationX += rotationSpeed * dt;
    }
}