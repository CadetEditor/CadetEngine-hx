// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.operations;

import nme.events.Event;
import nme.events.EventDispatcher;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.util.ComponentUtil;
import core.app.core.operations.IAsynchronousOperation;
import core.app.events.OperationProgressEvent;
import core.app.util.AsynchronousUtil;

class ValidateAsyncOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
	private var scene : IComponentContainer;
	private var components : Array<IComponent>;
	private var totalComponents : Int;
	
	public function new(scene : IComponentContainer)
    {
        super();
		this.scene = scene;
    }
	
	public function execute() : Void
	{
		components = ComponentUtil.getChildren(scene, true);
		components = components.reverse();
		totalComponents = components.length;
		checkQueue();
    }
	
	private function checkQueue() : Void
	{
		if (components.length == 0) {
			dispatchEvent(new Event(Event.COMPLETE));
			return;
        }
		
		var start : Int = Math.round(haxe.Timer.stamp() * 1000);
		
		while (components.length > 0) {
			var component : IComponent = cast((components.pop()), IComponent);
			component.validateNow();
			if ((Math.round(haxe.Timer.stamp() * 1000) - start) > 15) break;
        }
		
		dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, (totalComponents - components.length) / totalComponents));
		AsynchronousUtil.callLater(checkQueue);
    }
	
	private function get_Label() : String
	{
		return "Validate Async";
    }
}