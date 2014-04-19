  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.components.geom.CollisionShape;
import cadet2d.components.geom.ICollisionShape;
import cadet2d.components.processes.CollisionDetectionProcess;import cadet.core.Component;class BoundingSphere extends CollisionShape implements ICollisionShape
{@:meta(Serializable())
@:meta(Inspectable())
public var radius : Float = 40;public function new()
    {
        super();name = "Bounding Sphere";
    }
}