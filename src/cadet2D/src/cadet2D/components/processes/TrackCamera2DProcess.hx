  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.processes;

import cadet2d.components.processes.IComponentContainer;
import cadet2d.components.processes.IRenderable;
import cadet2d.components.processes.IRenderer2D;
import cadet2d.components.processes.Rectangle;
import cadet2d.components.processes.WorldBounds2D;
import nme.display.Sprite;import nme.geom.Matrix;import nme.geom.Rectangle;import cadet.core.Component;import cadet.core.IComponentContainer;import cadet.core.ISteppableComponent;import cadet.util.ComponentUtil;import cadet2d.components.processes.WorldBounds2D;import cadet2d.components.renderers.IRenderer2D;import cadet2d.components.renderers.Renderer2D;import cadet2d.components.skins.AbstractSkin2D;import cadet2d.components.skins.IRenderable;import core.app.util.Easing;import starling.display.DisplayObject;class TrackCamera2DProcess extends Component implements ISteppableComponent
{
    public var target(get, set) : IComponentContainer;
    public var renderer(get, set) : IRenderer2D;
    public var worldBounds(get, set) : WorldBounds2D;
    public var debugDrawProcess(get, set) : IDebugDrawProcess;
private var _renderer : IRenderer2D;private var _debugDrawProcess : IDebugDrawProcess;private var _target : IComponentContainer;private var _worldBounds : WorldBounds2D;@:meta(Serializable())
@:meta(Inspectable())
public var ease : Float = 0.2;@:meta(Serializable())
@:meta(Inspectable())
public var maxZoom : Float = 1;@:meta(Serializable())
@:meta(Inspectable())
public var minZoom : Float = 0.25;@:meta(Serializable())
@:meta(Inspectable())
public var minSpeed : Float = 0;@:meta(Serializable())
@:meta(Inspectable())
public var maxSpeed : Float = 100;private var snapTo : Bool = false;private var matrix : Matrix;private var cameraRect : Rectangle;private var oldCameraRect : Rectangle;private var oldObjectX : Float;private var oldObjectY : Float;public function new()
    {
        super();name = "TrackCamera2DProcess";matrix = new Matrix();cameraRect = new Rectangle();oldCameraRect = new Rectangle();
    }override private function addedToScene() : Void{addSceneReference(IRenderer2D, "renderer");addSceneReference(WorldBounds2D, "worldBounds");addSceneReference(IDebugDrawProcess, "debugDrawProcess");
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList"))
private function set_Target(value : IComponentContainer) : IComponentContainer{_target = value;snapTo = true;
        return value;
    }private function get_Target() : IComponentContainer{return _target;
    }private function set_Renderer(value : IRenderer2D) : IRenderer2D{_renderer = value;snapTo = true;
        return value;
    }private function get_Renderer() : IRenderer2D{return _renderer;
    }private function set_WorldBounds(value : WorldBounds2D) : WorldBounds2D{_worldBounds = value;
        return value;
    }private function get_WorldBounds() : WorldBounds2D{return _worldBounds;
    }private function set_DebugDrawProcess(value : IDebugDrawProcess) : IDebugDrawProcess{_debugDrawProcess = value;
        return value;
    }private function get_DebugDrawProcess() : IDebugDrawProcess{return _debugDrawProcess;
    }public function step(dt : Float) : Void{if (_renderer == null || !_renderer.initialised)             return;if (_target == null)             return;var skin : IRenderable = ComponentUtil.getChildOfType(_target, IRenderable, false);if (skin == null)             return  // Calculate the components position relative to the container.  ;var bounds : Rectangle = cast((skin), AbstractSkin2D).displayObject.getBounds(cast((cast((_renderer), Renderer2D).worldContainer), DisplayObject));if (bounds.width == 0)             return;if (bounds.height == 0)             return;var viewportWidth : Float = _renderer.viewportWidth;var viewportHeight : Float = _renderer.viewportHeight;var halfViewportWidth : Float = viewportWidth * 0.5;var halfViewportHeight : Float = viewportHeight * 0.5;var objectX : Float = bounds.left + (bounds.width * 0.5);var objectY : Float = bounds.top + (bounds.height * 0.5);if (snapTo) {cameraRect.left = objectX - halfViewportWidth;cameraRect.right = objectX + halfViewportWidth;cameraRect.top = objectY - halfViewportHeight;cameraRect.bottom = objectY + halfViewportHeight;oldCameraRect = cameraRect.clone();oldObjectX = objectX;oldObjectY = objectY;snapTo = false;
        }  // Based on the speed the camera is moving, calculate a desired zoom level  var objectVX : Float = objectX - oldObjectX;var objectVY : Float = objectY - oldObjectY;var objectSpeed : Float = Math.sqrt(objectVX * objectVX + objectVY * objectVY);var speedRatio : Float = (objectSpeed - minSpeed) / (maxSpeed - minSpeed);speedRatio = speedRatio < (0) ? 0 : speedRatio > (1) ? 1 : speedRatio;speedRatio = Easing.easeOutCubic(speedRatio, 0, 1, 1);var desiredZoom : Float = maxZoom + speedRatio * (minZoom - maxZoom);var newCameraRect : Rectangle = new Rectangle();newCameraRect.left = objectX - halfViewportWidth / desiredZoom;newCameraRect.right = objectX + halfViewportWidth / desiredZoom;newCameraRect.top = objectY - halfViewportHeight / desiredZoom;newCameraRect.bottom = objectY + halfViewportHeight / desiredZoom;  // Now we need to limit this rectangle to the worldBounds (if available)  if (_worldBounds != null) {if (newCameraRect.left < _worldBounds.left) {newCameraRect.x += _worldBounds.left - newCameraRect.left;if (newCameraRect.right > _worldBounds.right) {newCameraRect.right = _worldBounds.right;
                }
            }if (newCameraRect.right > _worldBounds.right) {newCameraRect.x += _worldBounds.right - newCameraRect.right;if (newCameraRect.left < _worldBounds.left) {newCameraRect.left = _worldBounds.left;
                }
            }if (newCameraRect.top < _worldBounds.top) {newCameraRect.y += _worldBounds.top - newCameraRect.top;if (newCameraRect.bottom > _worldBounds.bottom) {newCameraRect.bottom = _worldBounds.bottom;
                }
            }if (newCameraRect.bottom > _worldBounds.bottom) {newCameraRect.y += _worldBounds.bottom - newCameraRect.bottom;if (newCameraRect.top < _worldBounds.top) {newCameraRect.top = _worldBounds.top;
                }
            }
        }  // Now ease the cameraRect towards newCameraRect  cameraRect.left += (newCameraRect.left - cameraRect.left) * ease;cameraRect.right += (newCameraRect.right - cameraRect.right) * ease;cameraRect.top += (newCameraRect.top - cameraRect.top) * ease;cameraRect.bottom += (newCameraRect.bottom - cameraRect.bottom) * ease;var rectZoom : Float = Math.max(viewportWidth / cameraRect.width, viewportHeight / cameraRect.height);var rectX : Float = cameraRect.x + cameraRect.width * 0.5;var rectY : Float = cameraRect.y + cameraRect.height * 0.5;  // Update the Renderer's container position  matrix.identity();matrix.translate(-rectX, -rectY);matrix.scale(rectZoom, rectZoom);matrix.translate(halfViewportWidth, halfViewportHeight);cast((_renderer), Renderer2D).worldContainer.transformationMatrix = matrix;_renderer.invalidate("container");if (_debugDrawProcess != null && _debugDrawProcess.trackCamera) {if (Std.is(_debugDrawProcess.sprite, flash.display.Sprite)) {var flashSprite : flash.display.Sprite = flash.display.Sprite(_debugDrawProcess.sprite);flashSprite.transform.matrix = matrix;
            }
        }oldCameraRect = cameraRect.clone();oldObjectX = objectX;oldObjectY = objectY;
    }
}