  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.operations;

import cadet.operations.DeserializeOperation;
import cadet.operations.GetTemplatesAndMergeXMLOperation;
import cadet.operations.IReadFileOperation;
import cadet.operations.ISerializationPlugin;
import cadet.operations.ResourceManager;
import cadet.operations.ResourceSerializerPlugin;
import cadet.operations.ValidateAsyncOperation;
import nme.errors.Error;
import cadet.core.ICadetScene;import cadet.operations.GetTemplatesAndMergeXMLOperation;import cadet.operations.ValidateAsyncOperation;import cadet.util.ComponentUtil;import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.core.operations.IAsynchronousOperation;import core.app.core.serialization.ISerializationPlugin;import core.app.core.serialization.ResourceSerializerPlugin;import core.app.entities.URI;import core.app.events.OperationProgressEvent;import core.app.managers.ResourceManager;import core.app.operations.DeserializeOperation;class ReadCadetFileAndDeserializeOperation extends EventDispatcher implements IAsynchronousOperation
{
    public var label(get, never) : String;
private var uri : URI;private var fileSystemProvider : IFileSystemProvider;private var resourceManager : ResourceManager;private var xml : FastXML;private var scene : ICadetScene;public function new(uri : URI, fileSystemProvider : IFileSystemProvider, resourceManager : ResourceManager)
    {
        super();this.uri = uri;this.fileSystemProvider = fileSystemProvider;this.resourceManager = resourceManager;
    }public function execute() : Void{var readFileOperation : IReadFileOperation = fileSystemProvider.readFile(uri);readFileOperation.addEventListener(Event.COMPLETE, readFileCompleteHandler);readFileOperation.addEventListener(OperationProgressEvent.PROGRESS, readFileProgressHandler);readFileOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);readFileOperation.execute();
    }private function passThroughHandler(event : Event) : Void{dispatchEvent(event);
    }private function readFileProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, event.progress * 0.1));
    }private function getTemplatesAndMergeProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, 0.1 + event.progress * 0.2));
    }private function deserializeProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, 0.3 + event.progress * 0.3));
    }private function validateProgressHandler(event : OperationProgressEvent) : Void{dispatchEvent(new OperationProgressEvent(OperationProgressEvent.PROGRESS, 0.9 + event.progress * 0.1));
    }private function readFileCompleteHandler(event : Event) : Void{var readFileOperation : IReadFileOperation = cast((event.target), IReadFileOperation);if (readFileOperation.bytes.length == 0) {dispatchEvent(new Event(Event.COMPLETE));return;
        }  /*			try
			{*/  var xmlString : String = readFileOperation.bytes.readUTFBytes(readFileOperation.bytes.length);xml = cast((xmlString), XML);if (xml == null) {throw (new Error("Invalid xml"));
        }  /*			}
			catch ( e:Error )
			{
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, e.message ) )
				return;
			}*/  var getTemplatesAndMergeOperation : GetTemplatesAndMergeXMLOperation = new GetTemplatesAndMergeXMLOperation(xml, fileSystemProvider);getTemplatesAndMergeOperation.addEventListener(OperationProgressEvent.PROGRESS, getTemplatesAndMergeProgressHandler);getTemplatesAndMergeOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);getTemplatesAndMergeOperation.addEventListener(Event.COMPLETE, getTemplatesAndMergeCompleteHandler);getTemplatesAndMergeOperation.execute();
    }private function getTemplatesAndMergeCompleteHandler(event : Event) : Void{var plugins : Array<ISerializationPlugin> = new Array<ISerializationPlugin>();if (resourceManager != null) {plugins.push(new ResourceSerializerPlugin(resourceManager));
        }var deserializeOperation : DeserializeOperation = new DeserializeOperation(xml, plugins);deserializeOperation.addEventListener(OperationProgressEvent.PROGRESS, deserializeProgressHandler);deserializeOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);deserializeOperation.addEventListener(Event.COMPLETE, deserializeCompleteHandler);deserializeOperation.execute();
    }private function deserializeCompleteHandler(event : Event) : Void{var deserializeOperation : DeserializeOperation = cast((event.target), DeserializeOperation);try{scene = cast((deserializeOperation.getResult()), ICadetScene);
        }        catch (e : Error){dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));return;
        }var validateAsyncOperation : ValidateAsyncOperation = new ValidateAsyncOperation(scene);validateAsyncOperation.addEventListener(OperationProgressEvent.PROGRESS, validateProgressHandler);validateAsyncOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);validateAsyncOperation.addEventListener(Event.COMPLETE, validateCompleteHandler);validateAsyncOperation.execute();
    }private function validateCompleteHandler(event : Event) : Void{dispatchEvent(new Event(Event.COMPLETE));
    }public function getResult() : ICadetScene{return scene;
    }private function get_Label() : String{return "Read Cadet File : " + uri.path;
    }
}