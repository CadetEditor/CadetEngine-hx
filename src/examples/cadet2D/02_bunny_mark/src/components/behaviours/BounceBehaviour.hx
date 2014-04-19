package components.behaviours;

import components.behaviours.Component;
import components.behaviours.ISteppableComponent;
import components.behaviours.ITransform2D;
import components.behaviours.Point;
import components.behaviours.Rectangle;
import nme.geom.Point;import nme.geom.Rectangle;import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet2d.components.transforms.ITransform2D;class BounceBehaviour extends Component implements ISteppableComponent
{public var velocity : Point;public var transform : ITransform2D;public var gravity : Int = 3;public var boundsRect : Rectangle;public function new()
    {
        super();
    }public function step(dt : Float) : Void{transform.x += velocity.x;transform.y += velocity.y;velocity.y += gravity;if (transform.x > boundsRect.right) {velocity.x *= -1;transform.x = boundsRect.right;
        }
        else if (transform.x < boundsRect.left) {velocity.x *= -1;transform.x = boundsRect.left;
        }if (transform.y > boundsRect.bottom) {velocity.y *= -0.8;transform.y = boundsRect.bottom;if (Math.random() > 0.5) {velocity.y -= Math.random() * 12;
            }
        }
        else if (transform.y < boundsRect.top) {velocity.y = 0;transform.y = boundsRect.top;
        }
    }
}