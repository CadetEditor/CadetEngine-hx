// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// For use when loading CadetScenes outside of the CadetEditor, e.g. in a Flash Builder project.  

package cadet2d.operations;

import cadet2d.operations.CadetStartUpOperationBase;
import cadet.operations.CadetStartUpOperationBase;

class Cadet2DStartUpOperation extends CadetStartUpOperationBase
{
	public function new(cadetFileURL : String = null, fileSystemType : String = "url")
    {
		super(cadetFileURL, fileSystemType);
		addManifest(baseManifestURL + "Cadet2D.xml");
    }
}