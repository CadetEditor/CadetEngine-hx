  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.resources;

import cadet3d.resources.Mesh;
import away3d.entities.Mesh;import core.app.resources.IFactoryResource;class Away3DMeshResource implements IFactoryResource
{private var id : String;private var mesh : Mesh;public function new(id : String, mesh : Mesh)
    {this.id = id;this.mesh = mesh;
    }public function getLabel() : String{return "Away3D Mesh Resource";
    }public function getInstance() : Dynamic{return mesh.clone();
    }public function getInstanceType() : Class<Dynamic>{return Mesh;
    }public function getID() : String{return id;
    }
}