package cadet3d.components.processes;

import cadet3d.components.processes.Event;
import cadet3d.components.processes.IInputMapping;
import cadet3d.components.processes.MouseEvent;
import cadet3d.components.processes.Stage;
import nme.display.DisplayObjectContainer;
import nme.display.Stage;
import nme.events.Event;
import nme.events.MouseEvent;
import cadet.components.processes.IInputMapping;
import cadet.components.processes.InputProcess;
import cadet.components.processes.TouchInputMapping;
import cadet3d.components.renderers.Renderer3D;

class InputProcess3D extends InputProcess
{
	private var _mouseDown : Bool;
	private var _renderer3D : Renderer3D;
	
	public function new()
	{
		super();
	}
	
	override private function addedToStageHandler(event : Event = null) : Void
	{
		super.addedToStageHandler(event);
		var stage : Stage = _renderer.getNativeStage();
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	override private function removedFromStageHandler(event : Event = null) : Void
	{
		super.removedFromStageHandler(event);
		var stage : Stage = _renderer.getNativeStage();
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	private function mouseDownHandler(event : MouseEvent) : Void
	{
		clearTouches();
		_mouseDown = true;
		var mapping : IInputMapping = getMappingForInput(TouchInputMapping.BEGAN);
		if (mapping != null) inputTable[mapping.name] = true;
	}
	
	private function mouseUpHandler(event : MouseEvent) : Void
	{
		clearTouches();
		_mouseDown = false;
		var mapping : IInputMapping = getMappingForInput(TouchInputMapping.ENDED);
		if (mapping != null) inputTable[mapping.name] = true;
	}
	
	private function mouseMoveHandler(event : MouseEvent) : Void
	{
		clearTouches();
		var mapping : IInputMapping;
		if (_mouseDown) {
			mapping = getMappingForInput(TouchInputMapping.MOVED);
			if (mapping != null) inputTable[mapping.name] = true;
		} else {
			mapping = getMappingForInput(TouchInputMapping.HOVER);
			if (mapping != null) inputTable[mapping.name] = true;
		}
	}
}