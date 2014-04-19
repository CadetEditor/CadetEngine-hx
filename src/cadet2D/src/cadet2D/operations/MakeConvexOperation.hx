  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.operations;

import cadet.components.geom.IGeometry;import cadet.core.IComponentContainer;import cadet2d.components.geom.CompoundGeometry;import cadet2d.components.geom.PolygonGeometry;import cadet2d.util.VertexUtil;import core.app.core.operations.IUndoableOperation;class MakeConvexOperation implements IUndoableOperation
{
    public var label(get, never) : String;
private var polygon : PolygonGeometry;private var childIndex : Int = -1;private var _result : IGeometry;public function new(polygon : PolygonGeometry)
    {this.polygon = polygon;
    }public function execute() : Void{if (polygon.parentComponent) {childIndex = polygon.parentComponent.children.getItemIndex(polygon);
        }if (VertexUtil.isConcave(polygon.vertices) == false) {_result = polygon;return;
        }var compoundGeometry : CompoundGeometry = new CompoundGeometry();compoundGeometry.name = polygon.name;var decomposedVertices : Array<Dynamic> = VertexUtil.makeConvex(VertexUtil.copy(polygon.vertices));for (convexVertices in decomposedVertices){var childPolygon : PolygonGeometry = new PolygonGeometry();childPolygon.vertices = convexVertices;compoundGeometry.children.addItem(childPolygon);
        }_result = compoundGeometry;if (childIndex == -1)             return;var parent : IComponentContainer = polygon.parentComponent;parent.children.removeItem(polygon);parent.children.addItemAt(compoundGeometry, childIndex);
    }public function undo() : Void{if (_result == null)             return;var parent : IComponentContainer = _result.parentComponent;if (childIndex == -1)             return;parent.children.removeItem(_result);parent.children.addItemAt(polygon, childIndex);childIndex = -1;
    }public function getResult() : IGeometry{return _result;
    }private function get_Label() : String{return "Make convex";
    }
}