// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // For use when loading CadetScenes outside of the CadetEditor, e.g. in a Flash Builder project.  package cadet3d.operations;

import cadet3d.operations.CadetStartUpOperationBase;
import cadet3d.operations.ExternalResourceParserFactory;
import cadet.operations.CadetStartUpOperationBase;import cadet3d.resources.ExternalAway3DResourceParser;import core.app.CoreApp;import core.app.resources.ExternalResourceParserFactory;class Cadet3DStartUpOperation extends CadetStartUpOperationBase
{public function new(cadetFileURL : String)
    {super(cadetFileURL);  // Add ExternalAway3DResourceParser to handle .3ds & .obj files.  CoreApp.resourceManager.addResource(new ExternalResourceParserFactory(ExternalAway3DResourceParser, "External Away3D Resource Parser", ["obj", "3ds"]));addManifest(baseManifestURL + "Cadet3D.xml");
    }
}