  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.behaviours;

import cadet2d.components.behaviours.CircleGeometry;
import cadet2d.components.behaviours.IFootprint;
import cadet2d.components.behaviours.IGeometry;
import cadet2d.components.behaviours.PolygonGeometry;
import cadet2d.components.behaviours.RectangleGeometry;
import cadet.components.geom.IGeometry;import cadet.core.Component;import cadet.events.ValidationEvent;import cadet2d.components.geom.CircleGeometry;import cadet2d.components.geom.PolygonGeometry;import cadet2d.components.geom.RectangleGeometry;import cadet2d.components.processes.FootprintManagerProcess;import cadet2d.components.transforms.Transform2D;import cadet2d.util.VertexUtil;import nme.geom.Matrix;import nme.geom.Point;import nme.geom.Rectangle;class GeometryFootprintBehaviour extends Component implements IFootprint
{
    public var footprintManager(get, set) : FootprintManagerProcess;
    public var geometry(get, set) : IGeometry;
    public var transform(get, set) : Transform2D;
    public var x(get, never) : Int;
    public var y(get, never) : Int;
    public var sizeX(get, never) : Int;
    public var sizeY(get, never) : Int;
    public var values(get, never) : Array<Dynamic>;
private var _x : Int;private var _y : Int;private var _sizeX : Int;private var _sizeY : Int;private var _values : Array<Dynamic>;private var _footprintManager : FootprintManagerProcess;private var _geometry : IGeometry;private var _transform : Transform2D;public function new()
    {
        super();name = "GeometryFootprintBehaviour";
    }override private function addedToScene() : Void{addSiblingReference(Transform2D, "transform");addSiblingReference(IGeometry, "geometry");addSceneReference(FootprintManagerProcess, "footprintManager");
    }override private function removedFromScene() : Void{if (_footprintManager != null) {_footprintManager.removeFootprint(this);
        }
    }private function set_FootprintManager(value : FootprintManagerProcess) : FootprintManagerProcess{if (_footprintManager != null) {_footprintManager.removeFootprint(this);
        }_footprintManager = value;invalidate("values");
        return value;
    }private function get_FootprintManager() : FootprintManagerProcess{return _footprintManager;
    }override public function validateNow() : Void{if (isInvalid("values")) {validateValues();
        }super.validateNow();
    }private function validateValues() : Void{if (_transform == null)             return;if (_footprintManager == null)             return;if (_geometry == null)             return;_footprintManager.removeFootprint(this);if (Std.is(_geometry, PolygonGeometry)) {generatePolygonFootprint(cast((geometry), PolygonGeometry));
        }
        else if (Std.is(_geometry, CircleGeometry)) {generateCircleFootprint(cast((_geometry), CircleGeometry));
        }_footprintManager.addFootprint(this);
    }private function generateCircleFootprint(circleGeometry : CircleGeometry) : Void{var gridSize : Int = _footprintManager.gridSize;var gridSize2 : Int = gridSize >> 1;var r : Float = circleGeometry.radius;var r2 : Float = r * r;var position : Point = _transform.matrix.transformPoint(new Point(circleGeometry.x, circleGeometry.y));var bounds : Rectangle = new Rectangle(position.x - r, position.y - r, r * 2, r * 2);_x = bounds.x / gridSize;_y = bounds.y / gridSize;_sizeX = Math.ceil(bounds.width / gridSize) + 1;_sizeY = Math.ceil(bounds.height / gridSize) + 1;_values = [];for (x in 0...sizeX){_values[x] = [];for (y in 0...sizeY){var px : Float = (_x * gridSize) + (x * gridSize) + gridSize2;var py : Float = (_y * gridSize) + (y * gridSize) + gridSize2;var dx : Float = px - position.x;var dy : Float = py - position.y;var d : Float = dx * dx + dy * dy;_values[x][y] = d < r2;
            }
        }
    }private function generatePolygonFootprint(polygon : PolygonGeometry) : Void{var gridSize : Int = _footprintManager.gridSize;var bounds : Rectangle;var x : Int;var y : Int;var m : Matrix = new Matrix();  //var polygon:PolygonGeometry = PolygonGeometry( _geometry );  polygon = cast((_geometry), PolygonGeometry);var transformedVertices : Array<Dynamic> = VertexUtil.copy(polygon.vertices);VertexUtil.transform(transformedVertices, _transform.matrix);bounds = VertexUtil.getBounds(transformedVertices);_x = bounds.x / gridSize;_y = bounds.y / gridSize;_sizeX = Math.ceil(bounds.width / gridSize) + 1;_sizeY = Math.ceil(bounds.height / gridSize) + 1;_values = [];var rectangle : RectangleGeometry = new RectangleGeometry();rectangle.width = gridSize;rectangle.height = gridSize;rectangle.validateNow();var originalSquareVertices : Array<Dynamic> = rectangle.vertices;for (sizeX){_values[x] = [];for (sizeY){var squareVertices : Array<Dynamic> = VertexUtil.copy(originalSquareVertices);m.tx = (_x * gridSize) + (x * gridSize);m.ty = (_y * gridSize) + (y * gridSize);VertexUtil.transform(squareVertices, m);var intersections : Array<Dynamic> = VertexUtil.getIntersections(squareVertices, transformedVertices);if (intersections.length == 0) {_values[x][y] = VertexUtil.hittest(m.tx + (gridSize >> 1), m.ty + (gridSize >> 1), transformedVertices);
                }
                else {_values[x][y] = true;
                }
            }
        }
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList"))
private function set_Geometry(value : IGeometry) : IGeometry{if (_geometry != null) {_geometry.removeEventListener(ValidationEvent.INVALIDATE, invalidateGeometryHandler);
        }_geometry = value;if (_geometry != null) {_geometry.addEventListener(ValidationEvent.INVALIDATE, invalidateGeometryHandler);
        }invalidate("values");
        return value;
    }private function get_Geometry() : IGeometry{return _geometry;
    }private function set_Transform(value : Transform2D) : Transform2D{if (_transform != null) {_transform.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }_transform = value;if (_transform != null) {_transform.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }invalidate("values");
        return value;
    }private function get_Transform() : Transform2D{return _transform;
    }private function invalidateGeometryHandler(event : ValidationEvent) : Void{invalidate("values");
    }private function invalidateTransformHandler(event : ValidationEvent) : Void{invalidate("values");
    }private function get_X() : Int{return _x;
    }private function get_Y() : Int{return _y;
    }private function get_SizeX() : Int{return _sizeX;
    }private function get_SizeY() : Int{return _sizeY;
    }private function get_Values() : Array<Dynamic>{return _values;
    }
}