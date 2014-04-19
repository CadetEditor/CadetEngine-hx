package cadet2dbox2d.components.processes;

import cadet2dbox2d.components.processes.B2DebugDraw;
import cadet2dbox2d.components.processes.Component;
import cadet2dbox2d.components.processes.IDebugDrawProcess;
import cadet2dbox2d.components.processes.IRenderer2D;
import cadet2dbox2d.components.processes.PhysicsProcess;
import cadet2dbox2d.components.processes.Renderer2D;
import cadet2dbox2d.components.processes.RendererEvent;
import cadet2dbox2d.components.processes.Sprite;
import nme.display.Sprite;import box2d.dynamics.B2DebugDraw;import cadet.core.Component;import cadet.events.RendererEvent;import cadet2d.components.processes.IDebugDrawProcess;import cadet2d.components.renderers.IRenderer2D;import cadet2d.components.renderers.Renderer2D;import cadet2d.components.skins.IRenderable;import starling.display.DisplayObject;class DebugDrawProcess extends Component implements IDebugDrawProcess
{
    public var fillAlpha(get, set) : Float;
    public var lineThickness(get, set) : Float;
    public var drawScale(get, set) : Float;
    public var trackCamera(get, set) : Bool;
    public var renderer(get, set) : IRenderer2D;
    public var physicsProcess(get, set) : PhysicsProcess;
    public var sprite(get, never) : Dynamic;
private static inline var DISPLAY : String = "display";private static inline var RENDERER : String = "renderer";private static inline var PHYSICS : String = "physics";private var _renderer : Renderer2D;private var _physicsProcess : PhysicsProcess;private var _dbgDraw : B2DebugDraw;private var _drawScale : Float = 100;private var _fillAlpha : Float = 0.3;private var _lineThickness : Float = 1;private var _trackCamera : Bool = false;private var _sprite : Sprite;public function new(name : String = "DebugDrawProcess")
    {super(name);_dbgDraw = new B2DebugDraw();_dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);invalidate(DISPLAY);
    }override private function addedToScene() : Void{addSceneReference(Renderer2D, "renderer");addSceneReference(PhysicsProcess, "physicsProcess");
    }@:meta(Serializable())
@:meta(Inspectable(label="Fill alpha",priority="50",editor="Slider",min="0",max="100",snapInterval="1"))
private function set_FillAlpha(value : Float) : Float{_fillAlpha = value;invalidate(DISPLAY);
        return value;
    }private function get_FillAlpha() : Float{return _fillAlpha;
    }@:meta(Serializable())
@:meta(Inspectable(label="Line thickness",priority="51"))
private function set_LineThickness(value : Float) : Float{_lineThickness = value;invalidate(DISPLAY);
        return value;
    }private function get_LineThickness() : Float{return _lineThickness;
    }@:meta(Serializable())
@:meta(Inspectable(label="Draw scale",priority="52",editor="Slider",min="0",max="200",snapInterval="1"))
private function set_DrawScale(value : Float) : Float{_drawScale = value;invalidate(DISPLAY);
        return value;
    }private function get_DrawScale() : Float{return _drawScale;
    }@:meta(Serializable())
@:meta(Inspectable(label="Track camera",priority="53"))
private function set_TrackCamera(value : Bool) : Bool{_trackCamera = value;
        return value;
    }private function get_TrackCamera() : Bool{return _trackCamera;
    }private function set_Renderer(value : IRenderer2D) : IRenderer2D{if (_renderer != null) {_renderer.removeEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }_renderer = cast((value), Renderer2D);if (_renderer != null && !_renderer.initialised) {_renderer.addEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }invalidate(RENDERER);
        return value;
    }private function get_Renderer() : IRenderer2D{return _renderer;
    }private function rendererInitialisedHandler(event : RendererEvent) : Void{invalidate(RENDERER);
    }private function set_PhysicsProcess(value : PhysicsProcess) : PhysicsProcess{_physicsProcess = value;invalidate(PHYSICS);
        return value;
    }private function get_PhysicsProcess() : PhysicsProcess{return _physicsProcess;
    }override public function validateNow() : Void{var physicsIsValid : Bool = true;if (isInvalid(RENDERER)) {validateRenderer();
        }if (isInvalid(PHYSICS)) {physicsIsValid = validatePhysics();
        }if (isInvalid(DISPLAY)) {validateDisplay();
        }super.validateNow();if (!physicsIsValid) {invalidate(PHYSICS);
        }
    }private function validateRenderer() : Void{_sprite = cast((_renderer.getNativeParent()), Sprite);if (_renderer.initialised && _sprite != null) {_dbgDraw.SetSprite(_sprite);
        }
    }private function validatePhysics() : Bool{if (_physicsProcess != null) {if (_renderer != null && _renderer.initialised) {_physicsProcess.world.SetDebugDraw(_dbgDraw);return true;
            }
        }return false;
    }private function validateDisplay() : Void{_dbgDraw.SetDrawScale(_drawScale);_dbgDraw.SetFillAlpha(_fillAlpha);_dbgDraw.SetLineThickness(_lineThickness);
    }private function get_Sprite() : Dynamic{return _sprite;
    }override private function removedFromScene() : Void{super.removedFromScene();_sprite.graphics.clear();  // should be its own sprite  if (_physicsProcess != null) {_physicsProcess.world.SetDebugDraw(null);
        }
    }
}