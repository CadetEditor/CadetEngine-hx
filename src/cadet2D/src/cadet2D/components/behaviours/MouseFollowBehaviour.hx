package cadet2d.components.behaviours;

import cadet2d.components.behaviours.DisplayObject;
import cadet2d.components.behaviours.IRenderer;
import cadet2d.components.behaviours.ISteppableComponent;
import cadet2d.components.behaviours.Renderer2D;
import cadet2d.components.behaviours.RendererEvent;
import cadet2d.components.behaviours.Touch;
import cadet2d.components.behaviours.TouchEvent;
import cadet.core.Component;import cadet.core.IRenderer;import cadet.core.ISteppableComponent;import cadet.events.RendererEvent;import cadet2d.components.renderers.Renderer2D;import cadet2d.components.transforms.Transform2D;import nme.geom.Matrix;import nme.geom.Point;import starling.display.DisplayObject;import starling.events.Touch;import starling.events.TouchEvent;import starling.events.TouchPhase;import starling.utils.MatrixUtil;class MouseFollowBehaviour extends Component implements ISteppableComponent
{
    public var constrain(get, set) : String;
    public var renderer(get, set) : IRenderer;
private static var helperMatrix : Matrix = new Matrix();public var transform : Transform2D;private var _renderer : Renderer2D;private var _constrain : String;private var targetPoint : Point = new Point(0, 0);public static inline var CONSTRAIN_X : String = "x";public static inline var CONSTRAIN_Y : String = "y";public function new()
    {
        super();name = "MouseFollowBehaviour";
    }override private function addedToScene() : Void{addSiblingReference(Transform2D, "transform");addSceneReference(Renderer2D, "renderer");
    }public function step(dt : Float) : Void{if (transform == null || renderer == null)             return;if (_constrain != CONSTRAIN_X)             transform.x -= (transform.x - targetPoint.x) * 0.1;if (_constrain != CONSTRAIN_Y)             transform.y -= (transform.y - targetPoint.y) * 0.1;
    }@:meta(Serializable())
@:meta(Inspectable(editor="DropDownMenu",dataProvider="[<None>,x,y]"))
private function set_Constrain(value : String) : String{_constrain = value;
        return value;
    }private function get_Constrain() : String{return _constrain;
    }private function set_Renderer(value : IRenderer) : IRenderer{if (!(Std.is(value, Renderer2D)))             return;if (_renderer != null) {_renderer.viewport.stage.removeEventListener(TouchEvent.TOUCH, touchEventHandler);
        }_renderer = cast((value), Renderer2D);if (_renderer != null && _renderer.viewport) {_renderer.viewport.stage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
        }
        else {renderer.addEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }
        return value;
    }private function get_Renderer() : IRenderer{return _renderer;
    }private function rendererInitialisedHandler(event : RendererEvent) : Void{renderer.removeEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);_renderer.viewport.stage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
    }private function touchEventHandler(event : TouchEvent) : Void{if (transform == null)             return;if (_renderer == null)             return;var dispObj : DisplayObject = cast((_renderer.viewport.stage), DisplayObject);var touches : Array<Touch> = event.getTouches(dispObj);for (touch in touches){  // include MOVED for touch screens (where hover isn't available)  if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.MOVED) {if (transform.parentTransform) {helperMatrix.identity();helperMatrix.concat(transform.parentTransform.globalMatrix);  // get parent -> global matrix  helperMatrix.invert();  // and change it to global -> parent  var p : Point = MatrixUtil.transformCoords(helperMatrix, touch.globalX, touch.globalY, targetPoint);
                }
                else {targetPoint.x = touch.globalX;targetPoint.y = touch.globalY;
                }break;
            }
        }
    }
}