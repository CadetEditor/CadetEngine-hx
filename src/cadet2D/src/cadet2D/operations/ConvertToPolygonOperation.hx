  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.operations;

import cadet2d.operations.IUndoableOperation;
import cadet.core.IComponentContainer;import cadet2d.components.geom.PolygonGeometry;import cadet2d.util.VertexUtil;import core.app.core.operations.IUndoableOperation;import core.app.util.IntrospectionUtil;class ConvertToPolygonOperation implements IUndoableOperation
{
    public var label(get, never) : String;
private var polygon : PolygonGeometry;private var result : PolygonGeometry;private var parentComponent : IComponentContainer;private var index : Int;public function new(polygon : PolygonGeometry)
    {this.polygon = polygon;var type : Class<Dynamic> = IntrospectionUtil.getType(polygon);if (type == PolygonGeometry) {result = polygon;
        }
        else {result = new PolygonGeometry();result.name = polygon.name;result.exportTemplateID = polygon.exportTemplateID;result.templateID = polygon.templateID;var clonedVertices : Array<Dynamic> = VertexUtil.copy(polygon.vertices);result.vertices = clonedVertices;
        }
    }public function execute() : Void{parentComponent = polygon.parentComponent;if (parentComponent != null) {index = parentComponent.children.getItemIndex(polygon);parentComponent.children.removeItem(polygon);parentComponent.children.addItem(result);
        }
    }public function undo() : Void{if (result == polygon)             return;if (parentComponent != null) {parentComponent.children.removeItem(result);parentComponent.children.addItemAt(polygon, index);
        }
    }private function get_Label() : String{return "Convert To Polygon";
    }public function getResult() : PolygonGeometry{return result;
    }
}