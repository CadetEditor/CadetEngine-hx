package cadet3d.components.processes;

import cadet3d.components.processes.Component;
import cadet3d.components.processes.HoverController;
import cadet3d.components.processes.ISteppableComponent;
import cadet3d.components.processes.InputProcess;
import cadet3d.components.processes.ObjectContainer3DComponent;
import cadet3d.components.processes.Renderer3D;
import away3d.containers.ObjectContainer3D;import away3d.entities.Entity;import cadet.components.processes.InputProcess;import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet.util.ComponentUtil;import cadet3d.components.core.ObjectContainer3DComponent;import cadet3d.components.renderers.Renderer3D;import cadet3d.controllers.HoverController;class HoverCamProcess extends Component implements ISteppableComponent
{
    public var currentPanAngle(get, set) : Float;
    public var currentTiltAngle(get, set) : Float;
    public var distance(get, set) : Float;
    public var lookAtComponent(get, set) : ObjectContainer3DComponent;
    public var targetComponent(get, set) : ObjectContainer3DComponent;
@:meta(Serializable())
@:meta(Inspectable())
public var inputMapping : String = "MOVED";private var _controller : HoverController;private var _targetComponent : ObjectContainer3DComponent;private var _lookAtComponent : ObjectContainer3DComponent;private var lastPanAngle : Float;private var lastTiltAngle : Float;private var lastMouseX : Float;private var lastMouseY : Float;public var inputProcess : InputProcess;private var _active : Bool;public function new()
    {
        super();_controller = new HoverController();
    }override private function addedToScene() : Void{addSceneReference(InputProcess, "inputProcess");
    }@:meta(Serializable())
@:meta(Inspectable(priority="50"))
private function set_CurrentPanAngle(value : Float) : Float{_controller.currentPanAngle = value;
        return value;
    }private function get_CurrentPanAngle() : Float{return _controller.currentPanAngle;
    }@:meta(Serializable())
@:meta(Inspectable(priority="51"))
private function set_CurrentTiltAngle(value : Float) : Float{_controller.currentTiltAngle = value;
        return value;
    }private function get_CurrentTiltAngle() : Float{return _controller.currentTiltAngle;
    }@:meta(Serializable())
@:meta(Inspectable(priority="52"))
private function set_Distance(value : Float) : Float{_controller.distance = value;
        return value;
    }private function get_Distance() : Float{return _controller.distance;
    }@:meta(Serializable())
@:meta(Inspectable(priority="53",editor="ComponentList",scope="scene"))
private function set_LookAtComponent(target : ObjectContainer3DComponent) : ObjectContainer3DComponent{_lookAtComponent = target;if (_lookAtComponent != null) {_controller.lookAtObject = cast((target.object3D), ObjectContainer3D);
        }
        else {_controller.lookAtObject = null;
        }
        return target;
    }private function get_LookAtComponent() : ObjectContainer3DComponent{return _lookAtComponent;
    }@:meta(Serializable())
@:meta(Inspectable(priority="54",editor="ComponentList",scope="scene"))
private function set_TargetComponent(target : ObjectContainer3DComponent) : ObjectContainer3DComponent{_targetComponent = target;if (_targetComponent != null) {_controller.targetObject = cast((target.object3D), Entity);
        }
        else {_controller.targetObject = null;
        }
        return target;
    }private function get_TargetComponent() : ObjectContainer3DComponent{return _targetComponent;
    }public function step(dt : Float) : Void{if (inputProcess == null)             return;var renderer : Renderer3D = ComponentUtil.getChildOfType(scene, Renderer3D);if (renderer == null)             return;if (inputProcess.isInputDown(inputMapping)) {if (!_active) {lastPanAngle = _controller.panAngle;lastTiltAngle = _controller.tiltAngle;lastMouseX = renderer.viewport.stage.mouseX;lastMouseY = renderer.viewport.stage.mouseY;
            }_active = true;_controller.panAngle = 0.3 * (renderer.viewport.stage.mouseX - lastMouseX) + lastPanAngle;_controller.tiltAngle = 0.3 * (renderer.viewport.stage.mouseY - lastMouseY) + lastTiltAngle;
        }
        else {_active = false;
        }if (_targetComponent != null && _lookAtComponent != null) {_controller.update();
        }
    }
}