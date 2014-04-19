  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.operations;

import cadet2d.operations.BezierCurve;
import cadet2d.operations.ChangePropertyOperation;
import cadet2d.operations.CircleGeometry;
import cadet2d.operations.Connection;
import cadet2d.operations.ConvertToPolygonOperation;
import cadet2d.operations.IComponent;
import cadet2d.operations.IGeometry;
import cadet2d.operations.Matrix;
import cadet2d.operations.Point;
import cadet2d.operations.PolygonGeometry;
import cadet2d.operations.Rectangle;
import cadet2d.operations.Transform2D;
import cadet2d.operations.UndoableCompoundOperation;
import cadet2d.operations.Vertex;
import nme.geom.Matrix;import nme.geom.Point;import nme.geom.Rectangle;import cadet.components.geom.IGeometry;import cadet.core.IComponent;import cadet.util.ComponentUtil;import cadet2d.components.connections.Connection;import cadet2d.components.geom.BezierCurve;import cadet2d.components.geom.CircleGeometry;import cadet2d.components.geom.PolygonGeometry;import cadet2d.components.transforms.Transform2D;import cadet2d.geom.Vertex;import cadet2d.util.QuadraticBezierUtil;import cadet2d.util.VertexUtil;import core.app.operations.ChangePropertyOperation;import core.app.operations.UndoableCompoundOperation;class CenterOriginOperation extends UndoableCompoundOperation
{private var geometry : IGeometry;private var transform : Transform2D;private var useCentroid : Bool;public function new(geometry : IGeometry, transform : Transform2D, useCentroid : Bool = false)
    {
        super();this.geometry = geometry;this.transform = transform;this.useCentroid = useCentroid;label = "Center Origin";if (Std.is(geometry, CircleGeometry)) {centerCircle(cast((geometry), CircleGeometry));
        }
        else if (Std.is(geometry, PolygonGeometry)) {centerPolygon(cast((geometry), PolygonGeometry));
        }
        else if (Std.is(geometry, BezierCurve)) {centerBezierCurve(cast((geometry), BezierCurve));
        }
    }private function centerCircle(circle : CircleGeometry) : Void{addOperation(new ChangePropertyOperation(circle, "x", 0));addOperation(new ChangePropertyOperation(circle, "y", 0));var m : Matrix = new Matrix(transform.matrix.a, transform.matrix.b, transform.matrix.c, transform.matrix.d);var pt : Point = new Point(circle.x, circle.y);pt = m.transformPoint(pt);addOperation(new ChangePropertyOperation(transform, "x", transform.x + pt.x));addOperation(new ChangePropertyOperation(transform, "y", transform.y + pt.y));transformConnections(m);
    }private function centerPolygon(polygon : PolygonGeometry) : Void{var convertToPolygonOperation : ConvertToPolygonOperation = new ConvertToPolygonOperation(polygon);addOperation(convertToPolygonOperation);polygon = convertToPolygonOperation.getResult();var centerX : Float;var centerY : Float;if (useCentroid) {var center : Vertex = VertexUtil.computeCentroid(polygon.vertices);centerX = center.x;centerY = center.y;
        }
        else {var bounds : Rectangle = VertexUtil.getBounds(polygon.vertices);centerX = bounds.x + bounds.width * 0.5;centerY = bounds.y + bounds.height * 0.5;
        }var newVertices : Array<Dynamic> = VertexUtil.copy(polygon.vertices);var m : Matrix = new Matrix(1, 0, 0, 1, -centerX, -centerY);VertexUtil.transform(newVertices, m);transformConnections(m);addOperation(new ChangePropertyOperation(polygon, "vertices", newVertices));m = new Matrix(transform.matrix.a, transform.matrix.b, transform.matrix.c, transform.matrix.d);var pt : Point = new Point(centerX, centerY);pt = m.transformPoint(pt);addOperation(new ChangePropertyOperation(transform, "x", transform.x + pt.x));addOperation(new ChangePropertyOperation(transform, "y", transform.y + pt.y));
    }private function centerBezierCurve(bezierCurve : BezierCurve) : Void{var bounds : Rectangle = QuadraticBezierUtil.getBounds(bezierCurve.segments);var centerX : Float = bounds.x + bounds.width * 0.5;var centerY : Float = bounds.y + bounds.height * 0.5;  //var newSegments:Vector.<QuadraticBezier> = QuadraticBezierUtil.clone(bezierCurve.segments);  var newSegments : Array<Dynamic> = QuadraticBezierUtil.clone(bezierCurve.segments);var m : Matrix = new Matrix(1, 0, 0, 1, -centerX, -centerY);QuadraticBezierUtil.transform(newSegments, m);transformConnections(m);addOperation(new ChangePropertyOperation(bezierCurve, "segments", newSegments));m = new Matrix(transform.matrix.a, transform.matrix.b, transform.matrix.c, transform.matrix.d);var pt : Point = new Point(centerX, centerY);pt = m.transformPoint(pt);addOperation(new ChangePropertyOperation(transform, "x", transform.x + pt.x));addOperation(new ChangePropertyOperation(transform, "y", transform.y + pt.y));
    }private function transformConnections(m : Matrix) : Void{if (transform.scene == null)             return;var connections : Array<IComponent> = ComponentUtil.getChildrenOfType(transform.scene, Connection, true);for (connection in connections){var pt : Point;if (connection.transformA == transform) {pt = connection.localPosA.toPoint();pt = m.transformPoint(pt);addOperation(new ChangePropertyOperation(connection, "localPosA", new Vertex(pt.x, pt.y)));
            }
            else if (connection.transformB == transform) {pt = connection.localPosB.toPoint();pt = m.transformPoint(pt);addOperation(new ChangePropertyOperation(connection, "localPosB", new Vertex(pt.x, pt.y)));
            }
        }
    }
}