  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.util;

import cadet2d.util.VertexList;
import nme.geom.Matrix;import nme.geom.Point;import nme.geom.Rectangle;import cadet2d.geom.Vertex;import cadet2d.geom.VertexList;class VertexUtil
{public static function weld(vertices : Array<Dynamic>, minimumDistance : Float) : Void{var L : Int = vertices.length;var dis : Float = minimumDistance * minimumDistance;for (i in 0...L){var vertexA : Vertex = vertices[i];for (j in (i + 1)...L){var vertexB : Vertex = vertices[j];var dx : Float = vertexB.x - vertexA.x;var dy : Float = vertexB.y - vertexA.y;var d : Float = dx * dx + dy * dy;if (d > dis)                     {j++;continue;
                };vertexA.x += dx * 0.5;vertexA.y += dy * 0.5;vertices.splice(j, 1);L--;break;
            }
        }
    }  /**
		 * Selectively removes vertices from the supplied array that lie on or very near (below the tolerance) a straight line.
		 *  
		 * @param vertices
		 * @param tolerance
		 * @return 
		 * 
		 */  public static function simplify(vertices : Array<Dynamic>, tolerance : Float = 1) : Array<Dynamic>{var marks : Array<Dynamic> = [];marks[0] = marks[vertices.length - 1] = true;simplifyRecur(vertices, tolerance, 0, vertices.length - 1, marks);var newVertices : Array<Dynamic> = [];var m : Int = 0;for (i in 0...vertices.length){if (!marks[i])                 {i++;continue;
            };newVertices[m++] = vertices[i];
        }return newVertices;
    }private static function simplifyRecur(vertices : Array<Dynamic>, tolerance : Float, j : Int, k : Int, marks : Array<Dynamic>) : Void{if (k <= j + 1)             return;var maxi : Int = j;var maxd2 : Float = 0;var tol2 : Float = tolerance * tolerance;var s0 : Vertex = vertices[j];var s1 : Vertex = vertices[k];var u : Vertex = new Vertex(s1.x - s0.x, s1.y - s0.y);var cu : Float = u.x * u.x + u.y * u.y;var w : Vertex;var Pb : Vertex;var b : Float;var cw : Float;var dv2 : Float;var dx : Float;var dy : Float;for (i in j + 1...k){var v : Vertex = vertices[i];w = new Vertex(v.x - s0.x, v.y - s0.y);cw = w.x * u.x + w.y * u.y;if (cw <= 0) {dv2 = w.x * w.x + w.y * w.y;
            }
            else if (cu <= cw) {dx = v.x - s1.x;dy = v.y - s1.y;dv2 = dx * dx + dy * dy;
            }
            else {b = cw / cu;Pb = new Vertex(s0.x + b * u.x, s0.y + b * u.y);dx = v.x - Pb.x;dy = v.y - Pb.y;dv2 = dx * dx + dy * dy;
            }if (dv2 <= maxd2)                 {i++;continue;
            };maxi = i;maxd2 = dv2;
        }if (maxd2 > tol2) {marks[maxi] = true;simplifyRecur(vertices, tolerance, j, maxi, marks);simplifyRecur(vertices, tolerance, maxi, k, marks);
        }
    }public static function transform(vertices : Array<Dynamic>, matrix : Matrix) : Void{for (vertex in vertices){var p : Point = matrix.transformPoint(new Point(vertex.x, vertex.y));vertex.x = p.x;vertex.y = p.y;
        }
    }public static function copy(vertices : Array<Dynamic>) : Array<Dynamic>{var newVertices : Array<Dynamic> = [];for (i in 0...vertices.length){newVertices[i] = new Vertex(vertices[i].x, vertices[i].y);
        }return newVertices;
    }public static function getBounds(vertices : Array<Dynamic>, rect : Rectangle = null) : Rectangle{var minX : Float = Float.POSITIVE_INFINITY;var minY : Float = Float.POSITIVE_INFINITY;var maxX : Float = Float.NEGATIVE_INFINITY;var maxY : Float = Float.NEGATIVE_INFINITY;for (vertex in vertices){minX = vertex.x < (minX != 0) ? vertex.x : minX;minY = vertex.y < (minY != 0) ? vertex.y : minY;maxX = vertex.x > (maxX != 0) ? vertex.x : maxX;maxY = vertex.y > (maxY != 0) ? vertex.y : maxY;
        }if (rect == null)             return new Rectangle(minX, minY, maxX - minX, maxY - minY);rect.left = minX;rect.right = maxX;rect.top = minY;rect.bottom = maxY;return rect;
    }public static function hittest(px : Float, py : Float, vertices : Array<Dynamic>) : Bool{return windingNumber(px, py, vertices) != 0;
    }public static function windingNumber(px : Float, py : Float, vertices : Array<Dynamic>) : Int{var wn : Int = 0;var L : Int = vertices.length;for (i in 0...L){var vertex : Vertex = vertices[i];var nextVertex : Vertex = i == ((L - 1)) ? vertices[0] : vertices[i + 1];if (vertex.y <= py) {if (nextVertex.y > py) {if (isLeft(vertex, nextVertex, px, py) == false) {++wn;
                    }
                }
            }
            else {if (nextVertex.y <= py) {if (isLeft(vertex, nextVertex, px, py) == true) {--wn;
                    }
                }
            }
        }return wn;
    }public static function isConvex(vertices : Array<Dynamic>) : Bool{return !isConcave(vertices);
    }public static function isConcave(vertices : Array<Dynamic>, clockwise : Bool = true) : Bool{var n : Int = vertices.length;if (n < 3)             return false;for (i in 0...n){var j : Int = (i + 1) % n;var k : Int = (i + 2) % n;var z : Float = (vertices[j].x - vertices[i].x) * (vertices[k].y - vertices[j].y);z -= (vertices[j].y - vertices[i].y) * (vertices[k].x - vertices[j].x);if (z < 0) {if (clockwise) {return true;
                }
            }if (z > 0) {if (!clockwise) {return true;
                }
            }
        }return false;
    }public static function getArea(vertices : Array<Dynamic>) : Float{var n : Int = vertices.length;var a : Float = 0;for (i in 0...n - 1){a += vertices[i].x * vertices[i + 1].y - vertices[i + 1].x * vertices[i].y;
        }return a * 0.5;
    }public static function computeCentroid(vertices : Array<Dynamic>) : Vertex{var c : Vertex = new Vertex();var area : Float = 0;var p1X : Float = 0;var p1Y : Float = 0;var inv3 : Float = 1.0 / 3.0;var length : Int = vertices.length;for (i in 0...length){var p2 : Vertex = vertices[i];var p3 : Vertex = i + 1 >= (length != 0) ? vertices[0] : vertices[i + 1];var e1X : Float = p2.x - p1X;var e1Y : Float = p2.y - p1Y;var e2X : Float = p3.x - p1X;var e2Y : Float = p3.y - p1Y;var D : Float = (e1X * e2Y - e1Y * e2X);var triangleArea : Float = 0.5 * D;area += triangleArea;c.x += triangleArea * inv3 * (p1X + p2.x + p3.x);c.y += triangleArea * inv3 * (p1Y + p2.y + p3.y);
        }c.x *= 1.0 / area;c.y *= 1.0 / area;return c;
    }public static function getClosestVertex(x : Float, y : Float, vertices : Array<Dynamic>) : Vertex{var closestDistance : Float = Float.MAX_VALUE;var closestVertex : Vertex;for (vertex in vertices){var dx : Float = vertex.x - x;var dy : Float = vertex.y - y;var d : Float = dx * dx + dy * dy;if (d < closestDistance) {closestDistance = d;closestVertex = vertex;
            }
        }return closestVertex;
    }public static function getIntersections(verticesA : Array<Dynamic>, verticesB : Array<Dynamic>) : Array<Dynamic>{var intersections : Array<Dynamic> = [];for (i in 0...verticesA.length){var vertexA_1 : Vertex = verticesA[i];var vertexA_2 : Vertex = verticesA[i == verticesA.length - (1) ? 0 : i + 1];for (j in 0...verticesB.length){var vertexB_1 : Vertex = verticesB[j];var vertexB_2 : Vertex = verticesB[j == verticesB.length - (1) ? 0 : j + 1];var isect : Vertex = intersection(vertexA_1, vertexA_2, vertexB_1, vertexB_2);if (isect != null) {intersections.push(isect);
                }
            }
        }return intersections;
    }private static inline var EPSILON : Float = 0.0000001;public static function intersection(a0 : Vertex, a1 : Vertex, b0 : Vertex, b1 : Vertex, limit : Bool = true) : Vertex{var u : Vertex = new Vertex((a1.x + EPSILON) - (a0.x + EPSILON), (a1.y + EPSILON) - (a0.y + EPSILON));var v : Vertex = new Vertex((b1.x + EPSILON) - (b0.x + EPSILON), (b1.y + EPSILON) - (b0.y + EPSILON));var w : Vertex = new Vertex((a0.x + EPSILON) - (b0.x + EPSILON), (a0.y + EPSILON) - (b0.y + EPSILON));var D : Float = u.x * v.y - u.y * v.x;if (Math.abs(D) < EPSILON)             return null;var sI : Float = (v.x * w.y - v.y * w.x) / D;if (limit) {if (sI < 0 || sI > 1)                 return null;var tI : Float = (u.x * w.y - u.y * w.x) / D;if (tI < 0 || tI > 1)                 return null;
        }return new Vertex(a0.x + sI * u.x, a0.y + sI * u.y);
    }  /**
		 * Returns true if [px,py] is to the left of the line created by v0->v1, and false if it lies to the right
		 * @param v0
		 * @param v1
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */  public static function isLeft(v0 : Vertex, v1 : Vertex, px : Float, py : Float) : Bool{return ((v1.x - v0.x) * (py - v0.y) - (px - v0.x) * (v1.y - v0.y)) < 0;
    }@:allow(cadet2d.util)
    private static function toVertexList(vertices : Array<Dynamic>) : VertexList{if (vertices.length == 0)             return null;var firstVertex : VertexList = new VertexList(vertices[0].x, vertices[0].y);var vertexList : VertexList = firstVertex;for (i in 1...vertices.length){var vertex : Vertex = vertices[i];vertexList = vertexList.next = new VertexList(vertex.x, vertex.y);
        }vertexList.next = firstVertex;return firstVertex;
    }public static function makeConvex(vertices : Array<Dynamic>) : Array<Dynamic>{var returnShapes : Array<Dynamic> = [];var bounds : Rectangle = getBounds(vertices);var diameter : Float = Math.sqrt(bounds.width * bounds.width + bounds.height * bounds.height);var openList : Array<Dynamic> = [toVertexList(vertices)];var ray1 : Vertex = new Vertex();var ray2 : Vertex = new Vertex();var cutoutIsect : VertexList;var remainingIsect : VertexList;var iter : Int = 0;while (openList.length > 0){iter++;if (iter > 200) {break;
            }var currentShapeStart : VertexList = openList.pop();var currentShape : Array<Dynamic> = currentShapeStart.toArray();if (currentShape.length < 3)                 continue;if (currentShape.length == 3 || isConvex(currentShape)) {returnShapes.push(currentShape);continue;
            }var v : VertexList = currentShapeStart;do{if (isLeft(v, v.next, v.next.next.x, v.next.next.y) == false) {v = v.next;continue;
                }  // Found notch  var dx : Float = (v.next.x - v.x);var dy : Float = (v.next.y - v.y);var d : Float = Math.sqrt(dx * dx + dy * dy);dx /= d;dy /= d;ray1.x = v.next.x + dx;ray1.y = v.next.y + dy;ray2.x = v.next.x + dx * diameter;ray2.y = v.next.y + dy * diameter;var isectInfo : Dynamic = getClosestLineToShapeIntersection(ray1, ray2, currentShapeStart, 0);if (isectInfo == null) {v = v.next;continue;
                }var isect : Vertex = isectInfo.isect;var vertexBeforeIsect : VertexList = isectInfo.v;var vertexAfterIsect : VertexList = vertexBeforeIsect.next;if (isectInfo.d < 1) {cutoutIsect = new VertexList(vertexBeforeIsect.x, vertexBeforeIsect.y);cutoutIsect.next = v.next;getPrevVertex(vertexBeforeIsect).next = cutoutIsect;openList.push(cutoutIsect);remainingIsect = new VertexList(vertexBeforeIsect.x, vertexBeforeIsect.y);v.next = remainingIsect;remainingIsect.next = vertexBeforeIsect.next;openList.push(remainingIsect);
                }
                else {cutoutIsect = new VertexList(isect.x, isect.y);cutoutIsect.next = v.next;vertexBeforeIsect.next = cutoutIsect;openList.push(cutoutIsect);remainingIsect = new VertexList(isect.x, isect.y);v.next = remainingIsect;remainingIsect.next = vertexAfterIsect;openList.push(remainingIsect);
                }v = currentShapeStart;break;
            }            while ((v != currentShapeStart));
        }return returnShapes;
    }private static function cloneList(start : VertexList) : VertexList{var newList : VertexList;var v : VertexList = start;var newV : VertexList = newList;do{if (newV == null) {newList = newV = new VertexList(v.x, v.y);
            }v = v.next;if (v != start) {newV = newV.next = new VertexList(v.x, v.y);
            }
        }        while ((v != start));newV.next = newList;return newList;
    }private static function getPrevVertex(vertex : VertexList) : VertexList{var v : VertexList = vertex;while (v.next != vertex){v = v.next;
        }return v;
    }private static function getClosestLineToShapeIntersection(v1 : Vertex, v2 : Vertex, shapeStart : VertexList, minDistance : Float) : Dynamic{var v : VertexList = shapeStart;var closestDistance : Float = Float.POSITIVE_INFINITY;var closestIsect : Dynamic;do{var isect : Vertex = intersection(v1, v2, v, v.next);if (isect != null) {var dx : Float = v1.x - isect.x;var dy : Float = v1.y - isect.y;var d : Float = Math.sqrt(dx * dx + dy * dy);if (d < closestDistance && d > minDistance) {closestDistance = d;closestIsect = {
                                isect : isect,
                                v : v,
                                d : closestDistance,

                            };
                }
            }v = v.next;
        }        while ((v != shapeStart));return closestIsect;
    }public static function getPolygonStrip(vertices : Array<Dynamic>, thickness : Float, offset : Float = 0) : Array<Dynamic>{var shapes : Array<Dynamic> = [];var halfThickness : Float = thickness * 0.5;var L : Int = vertices.length - 1;for (i in 0...L){var vertex : Vertex = vertices[i];var nextVertex : Vertex = vertices[i + 1];var dx : Float = nextVertex.x - vertex.x;var dy : Float = nextVertex.y - vertex.y;var d : Float = Math.sqrt(dx * dx + dy * dy);dx /= d;dy /= d;var v0 : Vertex = new Vertex(vertex.x + dy * (halfThickness + offset), vertex.y - dx * (halfThickness + offset));var v1 : Vertex = new Vertex(nextVertex.x + dy * (halfThickness + offset), nextVertex.y - dx * (halfThickness + offset));var v2 : Vertex = new Vertex(nextVertex.x - dy * (halfThickness - offset), nextVertex.y + dx * (halfThickness - offset));var v3 : Vertex = new Vertex(vertex.x - dy * (halfThickness - offset), vertex.y + dx * (halfThickness - offset));var shape : Array<Dynamic> = [v0, v1, v2, v3];if (i > 0) {var prevShape : Array<Dynamic> = shapes[i - 1];var isect : Vertex = intersection(v1, v0, prevShape[0], prevShape[1], false);if (isect != null) {v0.x = prevShape[1].x = isect.x;v0.y = prevShape[1].y = isect.y;
                }isect = intersection(v2, v3, prevShape[3], prevShape[2], false);if (isect != null) {v3.x = prevShape[2].x = isect.x;v3.y = prevShape[2].y = isect.y;
                }
            }shapes.push(shape);
        }return shapes;
    }

    public function new()
    {
    }
}