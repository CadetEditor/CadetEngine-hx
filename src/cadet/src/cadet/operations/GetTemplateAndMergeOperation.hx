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

import cadet.operations.EventDispatcher;
import cadet.operations.GetTemplateOperation;
import cadet.operations.IAsynchronousOperation;
import cadet.operations.IComponent;
import cadet.operations.IFileSystemProvider;
import cadet.operations.IUndoableOperation;
import cadet.operations.MergeWithTemplateOperation;
import nme.events.ErrorEvent;
import nme.events.Event;
import nme.events.EventDispatcher;
import core.app.util.AsynchronousUtil;
import cadet.core.IComponent;
import cadet.operations.GetTemplateOperation;
import cadet.operations.MergeWithTemplateOperation;
import core.app.core.managers.filesystemproviders.IFileSystemProvider;
import core.app.core.operations.IAsynchronousOperation;
import core.app.core.operations.IUndoableOperation;
import core.app.events.OperationProgressEvent;

class GetTemplateAndMergeOperation extends EventDispatcher implements IAsynchronousOperation implements IUndoableOperation
{
    public var label(get, never) : String;
	private var templatePath : String;
	private var component : IComponent;
	private var fileSystemProvider : IFileSystemProvider;
	private var domTable : Dynamic;
	private var template : IComponent;
	private var mergeWithTemplateOperation : MergeWithTemplateOperation;
	
	public function new(templatePath : String, component : IComponent, fileSystemProvider : IFileSystemProvider, domTable : Dynamic = null)
    {
        super();
		this.templatePath = templatePath;
		this.component = component;
		this.fileSystemProvider = fileSystemProvider;
		this.domTable = domTable;  
		// It's a local template  
		if (templatePath.indexOf("#") == -1) {
			templatePath = "local#" + templatePath;
        }
		if (domTable == null) {
			domTable = { };
        }
    }
	
	public function execute() : Void
	{
		AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));  
		// This will be true if the operation has already executed once    
		// We simply skip to merging the template with the component as we've    
		// already fetched the template.  
		if (mergeWithTemplateOperation != null) {
			mergeWithTemplateOperation.execute();
        } else {
			var getTemplateOperation : GetTemplateOperation = new GetTemplateOperation(templatePath, fileSystemProvider, domTable); getTemplateOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);
			getTemplateOperation.addEventListener(OperationProgressEvent.PROGRESS, passThroughHandler);
			getTemplateOperation.addEventListener(Event.COMPLETE, getTemplateCompleteHandler);
			getTemplateOperation.execute();
        }
    }
	
	private function passThroughHandler(event : Event) : Void
	{
		dispatchEvent(event.clone());
    }
	
	private function getTemplateCompleteHandler(event : Event) : Void
	{
		var getTemplateOperation : GetTemplateOperation = cast((event.target), GetTemplateOperation);
		template = getTemplateOperation.getResult();
		mergeWithTemplateOperation = new MergeWithTemplateOperation(component, template, true);
		mergeWithTemplateOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);
		mergeWithTemplateOperation.addEventListener(OperationProgressEvent.PROGRESS, passThroughHandler);
		mergeWithTemplateOperation.addEventListener(Event.COMPLETE, mergeCompleteHandler);
		mergeWithTemplateOperation.execute();
    }
	
	private function mergeCompleteHandler(event : Event) : Void
	{
		dispatchEvent(new Event(Event.COMPLETE));
    }
	
	public function undo() : Void
	{
		mergeWithTemplateOperation.undo();
    }
	
	private function get_Label() : String
	{
		return "Get template and merge";
    }
}