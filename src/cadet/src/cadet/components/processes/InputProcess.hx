  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.components.processes;

import cadet.components.processes.ComponentContainer;
import cadet.components.processes.Event;
import cadet.components.processes.IRenderer;
import cadet.components.processes.InputProcessEvent;
import cadet.components.processes.KeyboardEvent;
import cadet.components.processes.KeyboardInputMapping;
import cadet.components.processes.RendererEvent;
import cadet.components.processes.Stage;
import nme.display.Stage;import nme.events.Event;import nme.events.KeyboardEvent;import cadet.core.ComponentContainer;import cadet.core.IComponent;import cadet.core.IRenderer;import cadet.events.InputProcessEvent;import cadet.events.RendererEvent;@:meta(Event(type="cadet.events.InputProcessEvent",name="inputDown"))
@:meta(Event(type="cadet.events.InputProcessEvent",name="inputUp"))
class InputProcess extends ComponentContainer
{
    public var renderer(get, set) : IRenderer;
private var _renderer : IRenderer;private var inputTable : Dynamic;public function new()
    {
        super();name = "InputProcess";inputTable = { };
    }override private function addedToScene() : Void{addSceneReference(IRenderer, "renderer");
    }private function set_Renderer(value : IRenderer) : IRenderer{if (_renderer != null) {if (_renderer.initialised) {removedFromStageHandler();
            }
        }_renderer = value;if (_renderer != null) {if (_renderer.initialised) {addedToStageHandler();
            }
            else {_renderer.addEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
            }
        }
        return value;
    }private function get_Renderer() : IRenderer{return _renderer;
    }private function rendererInitialisedHandler(event : RendererEvent) : Void{addedToStageHandler();
    }private function addedToStageHandler(event : Event = null) : Void{var stage : Stage = _renderer.getNativeStage();stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
    }private function removedFromStageHandler(event : Event = null) : Void{var stage : Stage = _renderer.getNativeStage();stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
    }public function isInputDown(name : String) : Bool{return Reflect.field(inputTable, name);
    }private function keyDownHandler(event : KeyboardEvent) : Void{var mapping : IInputMapping = getMappingForKeyCode(event.keyCode);if (mapping == null)             return;inputTable[mapping.name] = true;dispatchEvent(new InputProcessEvent(InputProcessEvent.INPUT_DOWN, mapping.name));
    }private function keyUpHandler(event : KeyboardEvent) : Void{var mapping : IInputMapping = getMappingForKeyCode(event.keyCode);if (mapping == null)             return;inputTable[mapping.name] = null;dispatchEvent(new InputProcessEvent(InputProcessEvent.INPUT_UP, mapping.name));
    }private function getMappingForKeyCode(keyCode : Int) : IInputMapping{for (child/* AS3HX WARNING could not determine type for var: child exp: EIdent(_children) type: null */ in _children){if (Std.is(child, KeyboardInputMapping)) {var kim : KeyboardInputMapping = cast((child), KeyboardInputMapping);if (kim.getKeyCode() == keyCode)                     return child;
            }
        }return null;
    }private function getMappingForInput(input : String) : IInputMapping{for (child/* AS3HX WARNING could not determine type for var: child exp: EIdent(_children) type: null */ in _children){if (Std.is(child, IInputMapping) == false)                 continue;if (cast((child), IInputMapping).input == input)                 return cast((child), IInputMapping);
        }return null;
    }private function clearTouches() : Void{for (mapping/* AS3HX WARNING could not determine type for var: mapping exp: EField(EIdent(TouchInputMapping),mappings) type: null */ in TouchInputMapping.mappings){if (inputTable[mapping]) {inputTable[mapping] = false;
            }
        }
    }
}