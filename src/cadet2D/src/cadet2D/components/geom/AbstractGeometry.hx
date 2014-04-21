// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.geom;

import cadet2d.components.geom.Component;
import cadet2d.components.geom.Connection;
import cadet2d.components.geom.IComponent;
import cadet2d.components.geom.IGeometry;
import cadet2d.components.geom.Matrix;
import cadet2d.components.geom.Point;
import cadet2d.components.geom.Transform2D;
import cadet2d.components.geom.Vertex;
import nme.geom.Matrix;
import nme.geom.Point;
import cadet.components.geom.IGeometry;
import cadet.core.Component;
import cadet.core.IComponent;
import cadet.util.ComponentUtil;
import cadet2d.components.connections.Connection;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.Vertex;

class AbstractGeometry extends Component implements IGeometry
{
	public function new(name : String = "AbstractGeometry")
    {
		super(name);
    }
	
	private function transformConnections(m : Matrix, transform : Transform2D) : Void
	{
		if (transform.scene == null) return;
		var connections : Array<IComponent> = ComponentUtil.getChildrenOfType(transform.scene, Connection, true);
		for (connection in connections) {
			var pt : Point;
			if (connection.transformA == transform) {
				pt = connection.localPosA.toPoint();
				pt = m.transformPoint(pt);
				connection.localPosA = new Vertex(pt.x, pt.y);
            } else if (connection.transformB == transform) {
				pt = connection.localPosB.toPoint();
				pt = m.transformPoint(pt);
				connection.localPosB = new Vertex(pt.x, pt.y);
            }
        }
    }
}