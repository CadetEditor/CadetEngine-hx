// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.resources;

import cadet3d.resources.IFactoryResource;
import cadet3d.resources.ObjectContainer3D;
import away3d.containers.ObjectContainer3D;import core.app.resources.IFactoryResource;class Away3DContainer3DResource implements IFactoryResource
{private var id : String;private var container3D : ObjectContainer3D;public function new(id : String, container3D : ObjectContainer3D)
    {this.id = id;this.container3D = container3D;
    }public function getLabel() : String{return "Away3D Container3D Resource";
    }public function getInstance() : Dynamic{return container3D.clone();
    }public function getInstanceType() : Class<Dynamic>{return ObjectContainer3D;
    }public function getID() : String{return id;
    }
}