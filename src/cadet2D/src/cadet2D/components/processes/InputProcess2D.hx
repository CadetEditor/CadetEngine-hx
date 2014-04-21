package cadet2d.components.processes;

import cadet2d.components.processes.DisplayObject;
import cadet2d.components.processes.Event;
import cadet2d.components.processes.IInputMapping;
import cadet2d.components.processes.InputProcess;
import cadet2d.components.processes.Renderer2D;
import cadet2d.components.processes.Touch;
import cadet2d.components.processes.TouchEvent;
import nme.events.Event;
import cadet.components.processes.IInputMapping;
import cadet.components.processes.InputProcess;
import cadet2d.components.renderers.Renderer2D;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;  

// InputProcess with a notion of Touches (via Starling)  
class InputProcess2D extends InputProcess
{
	private var _renderer2D : Renderer2D;
	public function new()
    {
        super();
    }
	
	override private function addedToStageHandler(event : Event = null) : Void
	{
		super.addedToStageHandler(event); 
		_renderer2D = cast((_renderer), Renderer2D);
		_renderer2D.viewport.stage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
    }
	
	override private function removedFromStageHandler(event : Event = null) : Void
	{
		super.removedFromStageHandler(event);
		_renderer2D = cast((_renderer), Renderer2D);
		_renderer2D.viewport.stage.removeEventListener(TouchEvent.TOUCH, touchEventHandler);
    }
	
	private function touchEventHandler(event : TouchEvent) : Void
	{
		if (!_renderer) return;
		
		// Clear touches  
		clearTouches();
		_renderer2D = cast((_renderer), Renderer2D);
		var dispObj : DisplayObject = cast((_renderer2D.viewport.stage), DisplayObject);
		var touches : Array<Touch> = event.getTouches(dispObj);
		for (touch in touches) {
			var mapping : IInputMapping = getMappingForInput(touch.phase);
			if (mapping != null) {
				inputTable[mapping.name] = true;
            }
        }
    }
}