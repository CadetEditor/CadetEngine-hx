  // Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com    // All rights reserved.  package cadet3d.resources;

import cadet3d.resources.AssetEvent;
import cadet3d.resources.AssetLoaderContext;
import cadet3d.resources.ByteArray;
import cadet3d.resources.Event;
import cadet3d.resources.IExternalResourceParser;
import cadet3d.resources.IFileSystemProvider;
import cadet3d.resources.IReadFileOperation;
import cadet3d.resources.Loader3D;
import cadet3d.resources.LoaderEvent;
import cadet3d.resources.ResourceManager;
import cadet3d.resources.URI;
import away3d.core.base.Geometry;import away3d.entities.Mesh;import away3d.events.AssetEvent;import away3d.events.LoaderEvent;import away3d.library.assets.AssetType;import away3d.loaders.Loader3D;import away3d.loaders.misc.AssetLoaderContext;import away3d.loaders.parsers.Parsers;import away3d.materials.MaterialBase;import nme.events.Event;import nme.utils.ByteArray;import core.app.controllers.IExternalResourceParser;import core.app.core.managers.filesystemproviders.IFileSystemProvider;import core.app.core.managers.filesystemproviders.operations.IReadFileOperation;import core.app.entities.URI;import core.app.managers.ResourceManager;import core.app.resources.IFactoryResource;class ExternalAway3DResourceParser implements IExternalResourceParser
{private var idPrefix : String;private var resourceArray : Array<Dynamic>;private var resourceManager : ResourceManager;public function new()
    {Parsers.enableAllBundled();
    }public function parse(uri : URI, assetsURI : URI, resourceManager : ResourceManager, fileSystemProvider : IFileSystemProvider) : Array<Dynamic>{idPrefix = uri.getFilename(true);this.resourceManager = resourceManager;resourceArray = [];var readFileOperation : IReadFileOperation = fileSystemProvider.readFile(uri);readFileOperation.addEventListener(Event.COMPLETE, readFileCompleteHandler);readFileOperation.execute();return resourceArray;
    }private function readFileCompleteHandler(event : Event) : Void{var readFileOperation : IReadFileOperation = cast((event.target), IReadFileOperation);var bytes : ByteArray = readFileOperation.bytes;var context : AssetLoaderContext = new AssetLoaderContext(false);var loader : Loader3D = new Loader3D(false);loader.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, loadCompleteHandler);loader.loadData(bytes, context, null);
    }private function assetCompleteHandler(event : AssetEvent) : Void{var resource : IFactoryResource;var id : String = idPrefix + "." + event.asset.name;var _sw0_ = (event.asset.assetType);        

        switch (_sw0_)
        {case AssetType.GEOMETRY:resource = new Away3DGeometryResource(id, cast((event.asset), Geometry));case AssetType.MATERIAL:resource = new Away3DMaterialResource(id, cast((event.asset), MaterialBase));case AssetType.MESH:resource = new Away3DMeshResource(id, cast((event.asset), Mesh));
        }if (resource != null) {resourceArray.push(resource);resourceManager.addResource(resource);
        }
    }private function loadCompleteHandler(event : LoaderEvent) : Void{var loader : Loader3D = cast((event.target), Loader3D);var resource : Away3DContainer3DResource = new Away3DContainer3DResource(idPrefix, loader);resourceArray.push(resource);resourceManager.addResource(resource);resourceManager = null;resourceArray = null;
    }
}