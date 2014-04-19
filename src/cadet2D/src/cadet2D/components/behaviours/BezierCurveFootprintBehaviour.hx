// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.behaviours;

import cadet2d.components.behaviours.BezierCurve;
import cadet2d.components.behaviours.Component;
import cadet2d.components.behaviours.FootprintManagerProcess;
import cadet2d.components.behaviours.IFootprint;
import cadet2d.components.behaviours.Matrix;
import cadet2d.components.behaviours.Point;
import cadet2d.components.behaviours.QuadraticBezier;
import cadet2d.components.behaviours.Rectangle;
import cadet2d.components.behaviours.Transform2D;
import cadet2d.components.behaviours.ValidationEvent;
import cadet2d.components.behaviours.Vertex;
import nme.geom.Matrix;import nme.geom.Point;import nme.geom.Rectangle;import cadet.core.Component;import cadet.events.ValidationEvent;import cadet2d.components.geom.BezierCurve;import cadet2d.components.processes.FootprintManagerProcess;import cadet2d.components.transforms.Transform2D;import cadet2d.geom.QuadraticBezier;import cadet2d.geom.Vertex;import cadet2d.util.QuadraticBezierUtil;import cadet2d.util.VertexUtil;class BezierCurveFootprintBehaviour extends Component implements IFootprint
{
    public var footprintManager(get, set) : FootprintManagerProcess;
    public var curve(get, set) : BezierCurve;
    public var transform(get, set) : Transform2D;
    public var thickness(get, set) : Float;
    public var capEnds(get, set) : Bool;
    public var x(get, never) : Int;
    public var y(get, never) : Int;
    public var sizeX(get, never) : Int;
    public var sizeY(get, never) : Int;
    public var values(get, never) : Array<Dynamic>;
private inline var VALUES : String = "values";private var _thickness : Float;private var _capEnds : Bool = false;private var thicknessSquared : Float;private var _x : Int;private var _y : Int;private var _sizeX : Int;private var _sizeY : Int;private var _values : Array<Dynamic>;private var _footprintManager : FootprintManagerProcess;private var _curve : BezierCurve;private var _transform : Transform2D;public function new()
    {
        super();name = "BezierCurveFootprintBehaviour";thickness = 20;
    }override private function addedToScene() : Void{addSiblingReference(Transform2D, "transform");addSiblingReference(BezierCurve, "curve");addSceneReference(FootprintManagerProcess, "footprintManager");
    }override private function removedFromScene() : Void{if (_footprintManager != null) {_footprintManager.removeFootprint(this);
        }
    }private function set_FootprintManager(value : FootprintManagerProcess) : FootprintManagerProcess{if (_footprintManager != null) {_footprintManager.removeFootprint(this);
        }_footprintManager = value;invalidate(VALUES);
        return value;
    }private function get_FootprintManager() : FootprintManagerProcess{return _footprintManager;
    }override public function validateNow() : Void{if (isInvalid(VALUES)) {validateValues();
        }super.validateNow();
    }private function validateValues() : Void{if (_transform == null)             return;if (_footprintManager == null)             return;if (_curve == null)             return;_footprintManager.removeFootprint(this);var gridSize : Int = _footprintManager.gridSize;var bounds : Rectangle;var x : Int;var y : Int;var m : Matrix = new Matrix();var dx : Float;var dy : Float;var d : Float;  //var segments:Vector.<QuadraticBezier> = QuadraticBezierUtil.clone(_curve.segments);  var segments : Array<Dynamic> = QuadraticBezierUtil.clone(_curve.segments);QuadraticBezierUtil.transform(segments, _transform.matrix);bounds = QuadraticBezierUtil.getBounds(segments);bounds.inflate(thickness, thickness);_x = bounds.x / gridSize;_y = bounds.y / gridSize;_sizeX = Math.ceil(bounds.width / gridSize) + 1;_sizeY = Math.ceil(bounds.height / gridSize) + 1;_values = [];if (_capEnds) {var lastSegment : QuadraticBezier = segments[segments.length - 1];dx = lastSegment.endX - lastSegment.controlX;dy = lastSegment.endY - lastSegment.controlY;d = Math.sqrt(dx * dx + dy * dy);dx /= d;dy /= d;var dx2 : Float = -dy;var dy2 : Float = dx;var v1E : Vertex = new Vertex(lastSegment.endX + dx2 * _thickness, lastSegment.endY + dy2 * _thickness);var v2E : Vertex = new Vertex(lastSegment.endX - dx2 * _thickness, lastSegment.endY - dy2 * _thickness);var v3E : Vertex = new Vertex(v1E.x + dx * _thickness, v1E.y + dy * _thickness);var v4E : Vertex = new Vertex(v2E.x + dx * _thickness, v2E.y + dy * _thickness);var firstSegment : QuadraticBezier = segments[0];dx = firstSegment.startX - firstSegment.controlX;dy = firstSegment.startY - firstSegment.controlY;d = Math.sqrt(dx * dx + dy * dy);dx /= d;dy /= d;dx2 = -dy;dy2 = dx;var v1S : Vertex = new Vertex(firstSegment.startX + dx2 * _thickness, firstSegment.startY + dy2 * _thickness);var v2S : Vertex = new Vertex(firstSegment.startX - dx2 * _thickness, firstSegment.startY - dy2 * _thickness);var v3S : Vertex = new Vertex(v1S.x + dx * _thickness, v1S.y + dy * _thickness);var v4S : Vertex = new Vertex(v2S.x + dx * _thickness, v2S.y + dy * _thickness);m = new Matrix(1, 0, 0, 1, -transform.x, -transform.y);VertexUtil.transform([v1E, v2E, v3E, v4E, v1S, v2S, v3S, v4S], m);
        }var p : Point = new Point();m = _transform.matrix.clone();m.invert();var v : Vertex = new Vertex();for (sizeX){_values[x] = [];for (sizeY){p.x = (x + _x) * gridSize + gridSize * 0.5;p.y = (y + _y) * gridSize + gridSize * 0.5;p = m.transformPoint(p);if (_capEnds) {var base : Bool = VertexUtil.isLeft(v1E, v2E, p.x, p.y) > 0;var left : Bool = VertexUtil.isLeft(v2E, v4E, p.x, p.y) > 0;var right : Bool = VertexUtil.isLeft(v3E, v1E, p.x, p.y) > 0;var tip : Bool = VertexUtil.isLeft(v4E, v3E, p.x, p.y) > 0;if (base && left && right && tip)                         {y++;continue;
                    };base = VertexUtil.isLeft(v1S, v2S, p.x, p.y) > 0;left = VertexUtil.isLeft(v2S, v4S, p.x, p.y) > 0;right = VertexUtil.isLeft(v3S, v1S, p.x, p.y) > 0;tip = VertexUtil.isLeft(v4S, v3S, p.x, p.y) > 0;if (base && left && right && tip)                         {y++;continue;
                    };
                }var closestRatio : Float = QuadraticBezierUtil.getClosestRatio(_curve.segments, p.x, p.y);v = QuadraticBezierUtil.evaluatePosition(_curve.segments, closestRatio, v);dx = v.x - p.x;dy = v.y - p.y;d = dx * dx + dy * dy;_values[x][y] = d < thicknessSquared;
            }
        }_footprintManager.addFootprint(this);
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList"))
private function set_Curve(value : BezierCurve) : BezierCurve{if (_curve != null) {_curve.removeEventListener(ValidationEvent.INVALIDATE, invalidateCurveHandler);
        }_curve = value;if (_curve != null) {_curve.addEventListener(ValidationEvent.INVALIDATE, invalidateCurveHandler);
        }invalidate(VALUES);
        return value;
    }private function get_Curve() : BezierCurve{return _curve;
    }private function set_Transform(value : Transform2D) : Transform2D{if (_transform != null) {_transform.removeEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }_transform = value;if (_transform != null) {_transform.addEventListener(ValidationEvent.INVALIDATE, invalidateTransformHandler);
        }invalidate(VALUES);
        return value;
    }private function get_Transform() : Transform2D{return _transform;
    }@:meta(Serializable())
@:meta(Inspectable(editor="NumericStepper",min="1",max="999"))
private function set_Thickness(value : Float) : Float{_thickness = value;thicknessSquared = _thickness * _thickness;invalidate(VALUES);
        return value;
    }private function get_Thickness() : Float{return _thickness;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_CapEnds(value : Bool) : Bool{_capEnds = value;invalidate(VALUES);
        return value;
    }private function get_CapEnds() : Bool{return _capEnds;
    }private function invalidateCurveHandler(event : ValidationEvent) : Void{invalidate(VALUES);
    }private function invalidateTransformHandler(event : ValidationEvent) : Void{invalidate(VALUES);
    }private function get_X() : Int{return _x;
    }private function get_Y() : Int{return _y;
    }private function get_SizeX() : Int{return _sizeX;
    }private function get_SizeY() : Int{return _sizeY;
    }private function get_Values() : Array<Dynamic>{return _values;
    }
}