// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.operations;

import cadet2d.operations.CompoundGeometry;
import cadet2d.operations.ConvertToPolygonOperation;
import nme.geom.Matrix;
import nme.geom.Point;
import cadet.components.geom.IGeometry;
import cadet.core.IComponent;
import cadet.util.ComponentUtil;
import cadet2d.components.connections.Connection;
import cadet2d.components.geom.BezierCurve;
import cadet2d.components.geom.CircleGeometry;
import cadet2d.components.geom.CompoundGeometry;
import cadet2d.components.geom.PolygonGeometry;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.Vertex;
import cadet2d.util.QuadraticBezierUtil;
import cadet2d.util.VertexUtil;
import core.app.operations.ChangePropertyOperation;
import core.app.operations.UndoableCompoundOperation;

class CollapseTransformOperation extends UndoableCompoundOperation
{
	private var geometry : IGeometry;
	private var transform : Transform2D;
	
	public function new(geometry : IGeometry, transform : Transform2D)
    {
        super();
		this.geometry = geometry;
		this.transform = transform; 
		label = "Collapse Transform";
		collapseGeometry(geometry);
    }
	
	private function collapseGeometry(geometry : IGeometry) : Void
	{
		if (Std.is(geometry, CircleGeometry)) {
			collapseCircle(cast((geometry), CircleGeometry));
        } else if (Std.is(geometry, PolygonGeometry)) {
			collapsePolygon(cast((geometry), PolygonGeometry));
        } else if (Std.is(geometry, BezierCurve)) {
			collapseBezierCurve(cast((geometry), BezierCurve));
        } else if (Std.is(geometry, CompoundGeometry)) {
			collapseCompoundGeometry(cast((geometry), CompoundGeometry));
        }
    }
	
	private function collapseCompoundGeometry(compoundGeometry : CompoundGeometry) : Void
	{
		for (childGeometry/* AS3HX WARNING could not determine type for var: childGeometry exp: EField(EIdent(compoundGeometry),children) type: null */ in compoundGeometry.children) {
			collapseGeometry(childGeometry);
        }
    }
	
	private function collapseCircle(circle : CircleGeometry) : Void
	{
		var m : Matrix = transform.matrix;
		m.tx = 0;
		m.ty = 0;
		var pt : Point = new Point(circle.x, circle.y);
		pt = m.transformPoint(pt);
		addOperation(new ChangePropertyOperation(circle, "x", pt.x));
		addOperation(new ChangePropertyOperation(circle, "y", pt.y));
		addOperation(new ChangePropertyOperation(transform, "matrix", new Matrix(1, 0, 0, 1, transform.x, transform.y)));
		transformConnections(m);
    }
	
	private function collapsePolygon(polygon : PolygonGeometry) : Void
	{
		var convertToPolygonOperation : ConvertToPolygonOperation = new ConvertToPolygonOperation(polygon);
		addOperation(convertToPolygonOperation);
		polygon = convertToPolygonOperation.getResult();
		var m : Matrix = transform.matrix;
		m.tx = 0;
		m.ty = 0;
		var newVertices : Array<Dynamic> = VertexUtil.copy(polygon.vertices);
		VertexUtil.transform(newVertices, m);
		addOperation(new ChangePropertyOperation(polygon, "vertices", newVertices));
		addOperation(new ChangePropertyOperation(transform, "matrix", new Matrix(1, 0, 0, 1, transform.x, transform.y)));
		transformConnections(m);
    }
	
	private function collapseBezierCurve(bezierCurve : BezierCurve) : Void
	{
		var m : Matrix = transform.matrix;
		m.tx = 0;
		m.ty = 0;  
		//var newSegments:Vector.<QuadraticBezier> = QuadraticBezierUtil.clone(bezierCurve.segments);  
		var newSegments : Array<Dynamic> = QuadraticBezierUtil.clone(bezierCurve.segments);
		QuadraticBezierUtil.transform(newSegments, m);
		addOperation(new ChangePropertyOperation(bezierCurve, "segments", newSegments));
		addOperation(new ChangePropertyOperation(transform, "matrix", new Matrix(1, 0, 0, 1, transform.x, transform.y)));
		transformConnections(m);
    }
	
	private function transformConnections(m : Matrix) : Void
	{
		if (transform.scene == null) return;
		var connections : Array<IComponent> = ComponentUtil.getChildrenOfType(transform.scene, Connection, true);
		for (connection in connections) {
			var pt : Point;
			if (connection.transformA == transform) {
				pt = connection.localPosA.toPoint();
				pt = m.transformPoint(pt);
				addOperation(new ChangePropertyOperation(connection, "localPosA", new Vertex(pt.x, pt.y)));
            } else if (connection.transformB == transform) {
				pt = connection.localPosB.toPoint();
				pt = m.transformPoint(pt);
				addOperation(new ChangePropertyOperation(connection, "localPosB", new Vertex(pt.x, pt.y)));
            }
        }
    }
}