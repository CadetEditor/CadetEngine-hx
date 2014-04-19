// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// ABSTRACT CLASS  

package cadet.operations;

import cadet.operations.CompoundOperation;
import cadet.operations.Event;
import cadet.operations.ExternalResourceController;
import cadet.operations.ICadetScene;
import cadet.operations.IResource;
import cadet.operations.LoadManifestsOperation;
import cadet.operations.LocalFileSystemProvider;
import cadet.operations.ReadCadetFileAndDeserializeOperation;
import cadet.operations.URI;
import cadet.operations.URLFileSystemProvider;
import nme.events.Event;
import nme.filesystem.File;
import cadet.core.ICadetScene;
import core.app.util.FileSystemTypes;
import core.app.CoreApp;
import core.app.controllers.ExternalResourceController;
import core.app.entities.URI;
import core.app.managers.filesystemproviders.local.LocalFileSystemProvider;
import core.app.managers.filesystemproviders.url.URLFileSystemProvider;
import core.app.operations.CompoundOperation;
import core.app.operations.LoadManifestsOperation;
import core.app.resources.IResource;

class CadetStartUpOperationBase extends CompoundOperation
{
	private var readAndDeserializeOperation : ReadCadetFileAndDeserializeOperation;
	private var fspURLID : String = "cadet.url";
	private var fspLocalID : String = "cadet.local";
	private var fspLocalFolder : String = "Cadet";
	public var baseURL : String = "files";
	public var cadetFileURL : String;
	public var baseManifestURL : String = "extensions/manifests/";
	public var fileSystemType : String = FileSystemTypes.URL;
	private var _manifests : Array<Dynamic>;
	private var _externalResourceController : ExternalResourceController;
	
	public function new(cadetFileURL : String, fileSystemType : String = "url")
    {
        super();
		this.cadetFileURL = cadetFileURL;
		this.fileSystemType = fileSystemType;  
		// Initialise the CoreApp (resourceManager, fileSystemProvider)  
		CoreApp.init();
		_manifests = [];
		addManifest(baseManifestURL + "Core.xml");
		addManifest(baseManifestURL + "Cadet.xml");
    }
	
	public function addManifest(url : String) : Void
	{
		_manifests.push(url);
    }
	
	public function addResource(resource : IResource) : Void
	{
		CoreApp.resourceManager.addResource(resource);
    }
	
	override public function execute() : Void
	{
		var assetsURI : URI; 
		if (fileSystemType == FileSystemTypes.LOCAL) {
			CoreApp.fileSystemProvider.registerFileSystemProvider(new LocalFileSystemProvider(fspLocalID, fspLocalID, File.applicationDirectory, File.applicationDirectory));
			assetsURI = new URI(fspLocalID + "/" + baseURL + "/" + CoreApp.externalResourceFolderName);
        }
        // Create an ExternalResourceController to monitor external resources
        else if (fileSystemType == FileSystemTypes.URL) {
			CoreApp.fileSystemProvider.registerFileSystemProvider(new URLFileSystemProvider(fspURLID, fspURLID, baseURL));
			assetsURI = new URI(fspURLID + "/" + CoreApp.externalResourceFolderName);
        }
		_externalResourceController = new ExternalResourceController(CoreApp.resourceManager, assetsURI, CoreApp.fileSystemProvider);
		_externalResourceController.addEventListener(Event.COMPLETE, resourcesAddedHandler);
    }
	
	private function resourcesAddedHandler(event : Event) : Void
	{  
		// Specify which manifests to load  
		var config : FastXML = createConfigXML();  
		// Load manifests 
		var loadManifestsOperation : LoadManifestsOperation = new LoadManifestsOperation(config.node.manifest.innerData); 
		addOperation(loadManifestsOperation);
		if (cadetFileURL != null) {  
			// Read and deserialize the Cadet XML into a CadetScene  
			var uri : URI;
			
			if (fileSystemType == FileSystemTypes.LOCAL) uri = new URI(fspLocalID + "/" + baseURL + "/" + cadetFileURL);
            else if (fileSystemType == FileSystemTypes.URL) uri = new URI(fspURLID + cadetFileURL);
			
			readAndDeserializeOperation = new ReadCadetFileAndDeserializeOperation(uri, CoreApp.fileSystemProvider, CoreApp.resourceManager);
			addOperation(readAndDeserializeOperation);
        }
		
		super.execute();
    }
	
	private function createConfigXML() : FastXML
	{
		var configXMLStr : String = "<xml>";
		
		for (i in 0..._manifests.length) {
			var manifestURL : String = _manifests[i];
			configXMLStr += "<manifest><url><![CDATA[" + manifestURL + "]]></url></manifest>";
        }
		
		configXMLStr += "</xml>";
		var config : FastXML = new FastXML(configXMLStr);
		return config;
    }
	
	public function getResult() : ICadetScene
	{
		return (readAndDeserializeOperation != null) ? readAndDeserializeOperation.getResult() : null;
    }
}