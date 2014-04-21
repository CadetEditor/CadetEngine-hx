// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.util;

import cadet2d.util.Graphics;
import cadet2d.util.Matrix;
import cadet2d.util.Point;
import cadet2d.util.QuadraticBezier;
import nme.display.Graphics;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import cadet.util.Equations;
import cadet2d.geom.QuadraticBezier;
import cadet2d.geom.Vertex;

class QuadraticBezierUtil
{
	private static inline var PRECISION : Float = 1e-10;
	
	public static function clone(segments : Array<Dynamic>) : Array<Dynamic>  //Vector.<QuadraticBezier> ):Vector.<QuadraticBezier>  
	{
		var clonedSegments : Array<Dynamic> = new Array<Dynamic>();  //Vector.<QuadraticBezier> = new Vector.<QuadraticBezier>();  
		
		for (i in 0...segments.length) {
			clonedSegments.push(segments[i].clone());
        }
		
		return clonedSegments;
    }
	
	public static function transform(segments : Array<Dynamic>, matrix : Matrix) : Void  //Vector.<QuadraticBezier>, matrix:Matrix ):void  
	{
		var start : Point = new Point();
		var end : Point = new Point();
		var control : Point = new Point();
		for (segment in segments) {
			start.x = segment.startX;
			start.y = segment.startY;
			end.x = segment.endX;
			end.y = segment.endY;
			control.x = segment.controlX;
			control.y = segment.controlY;
			start = matrix.transformPoint(start);
			end = matrix.transformPoint(end);
			control = matrix.transformPoint(control);
			segment.startX = start.x; 
			segment.startY = start.y;
			segment.endX = end.x;
			segment.endY = end.y;
			segment.controlX = control.x;
			segment.controlY = control.y;
        }
    }
	
	public static function draw(graphics : Graphics, segments : Array<Dynamic>) : Void  //Vector.<QuadraticBezier> ):void  
	{
		for (i in 0...segments.length) {
			var segment : QuadraticBezier = segments[i];
			graphics.moveTo(segment.startX, segment.startY);
			graphics.curveTo(segment.controlX, segment.controlY, segment.endX, segment.endY);
        }
    }  
	
	//public static function evaluatePosition( segments:Vector.<QuadraticBezier>, ratio:Number, vertex:Vertex = null ):Vertex  
	public static function evaluatePosition(segments : Array<Dynamic>, ratio : Float, vertex : Vertex = null) : Vertex
	{
		ratio = ratio < (0) ? 0 : ratio > (1) ? 1 : ratio;
		var segmentIndex : Int;
		
		if (ratio == 1) {
			segmentIndex = segments.length - 1;
        } else {
			segmentIndex = ratio * segments.length;
        }
		
		var segmentRatio : Float = 1 / segments.length;
		var localRatio : Float;
		
		if (ratio == 1) {
			localRatio = 1;
        } else if (segmentIndex == 0) {
			localRatio = ratio / segmentRatio;
        } else {
			localRatio = (ratio % (segmentIndex * segmentRatio)) / segmentRatio;
        }
		
		return evaluateSegmentPosition(segments[segmentIndex], localRatio, vertex);
    }
	
	public static function makeContinuous(segmentA : QuadraticBezier, segmentB : QuadraticBezier) : Void
	{
		var dx : Float = segmentA.controlX - segmentA.endX;
		var dy : Float = segmentA.controlY - segmentA.endY;
		segmentB.controlX = segmentB.startX - dx;
		segmentB.controlY = segmentB.startY - dy;
    }
	
	public static function getLength(segments : Array<Dynamic>) : Float  //Vector.<QuadraticBezier> ):Number  
	{
		var length : Float = 0;
		
		for (segment in segments) {
			length += getSegmentLength(segment);
        }
		
		return length;
    }  
	
	//public static function getBounds( segments:Vector.<QuadraticBezier> ):flash.geom.Rectangle  
	public static function getBounds(segments : Array<Dynamic>) : flash.geom.Rectangle
	{
		var xMin : Float = Float.POSITIVE_INFINITY;
		var xMax : Float = Float.NEGATIVE_INFINITY;
		var yMin : Float = Float.POSITIVE_INFINITY;
		var yMax : Float = Float.NEGATIVE_INFINITY;
		var segmentBounds : flash.geom.Rectangle = new flash.geom.Rectangle();
		
		for (segment in segments) {
			getSegmentBounds(segment, segmentBounds);
			xMin = segmentBounds.left < (xMin != 0) ? segmentBounds.left : xMin;
			yMin = segmentBounds.top < (yMin != 0) ? segmentBounds.top : yMin;
			xMax = segmentBounds.right > (xMax != 0) ? segmentBounds.right : xMax;
			yMax = segmentBounds.bottom > (yMax != 0) ? segmentBounds.bottom : yMax;
        }
		
		return new flash.geom.Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
    }  
	
	//public static function getClosestRatio(segments:Vector.<QuadraticBezier>, x:Number, y:Number):Number  
	public static function getClosestRatio(segments : Array<Dynamic>, x : Float, y : Float) : Float
	{
		var closestDistance : Float = Float.POSITIVE_INFINITY;
		var closestIndex : Int;
		var closestRatio : Float;
		var v : Vertex = new Vertex();
		
		for (i in 0...segments.length) {
			var segment : QuadraticBezier = segments[i];
			var ratio : Float = getClosestRatioOnSegment(segment, x, y); 
			evaluateSegmentPosition(segment, ratio, v);
			var dx : Float = v.x - x;
			var dy : Float = v.y - y;
			var d : Float = dx * dx + dy * dy;
			
			if (d < closestDistance) {
				closestDistance = d;
				closestRatio = ratio;
				closestIndex = i;
            }
			
        }
		
		var segmentRatio : Float = 1 / segments.length;
		return (closestIndex * segmentRatio) + (closestRatio * segmentRatio);
    }
	
	public static function evaluateSegmentPosition(segment : QuadraticBezier, ratio : Float, vertex : Vertex = null) : Vertex
	{  
		//ratio = ratio < 0 ? 0 : ratio > 1 ? 1 : ratio;  
		vertex = vertex == (null) ? new Vertex() : vertex;
		var f : Float = 1 - ratio;
		vertex.x = segment.startX * f * f + segment.controlX * 2 * ratio * f + segment.endX * ratio * ratio;
		vertex.y = segment.startY * f * f + segment.controlY * 2 * ratio * f + segment.endY * ratio * ratio;
		return vertex;
    }
	
	public static function getSegmentLength(segment : QuadraticBezier, time : Float = 1) : Float
	{
		var csX : Float = segment.controlX - segment.startX;
		var csY : Float = segment.controlY - segment.startY;
		var nvX : Float = segment.endX - segment.controlX - csX;
		var nvY : Float = segment.endY - segment.controlY - csY;  
		
		// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)  
		var c0 : Float = 4 * (csX * csX + csY * csY);
		var c1 : Float = 8 * (csX * nvX + csY * nvY);
		var c2 : Float = 4 * (nvX * nvX + nvY * nvY);
		var ft : Float;
		var f0 : Float;
		
		if (c2 == 0) {
			if (c1 == 0) { 
				ft = Math.sqrt(c0) * time;
				return ft;
            } else {
				ft = (2 / 3) * (c1 * time + c0) * Math.sqrt(c1 * time + c0) / c1;
				f0 = (2 / 3) * c0 * Math.sqrt(c0) / c1;
				return (ft - f0);
            }
        }
		
		var sqrt_0 : Float = Math.sqrt(c2 * time * time + c1 * time + c0);
		var sqrt_c0 : Float = Math.sqrt(c0);
		var sqrt_c2 : Float = Math.sqrt(c2);
		var exp1 : Float = (0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0;
		
		if (exp1 < PRECISION) {
			ft = 0.25 * (2 * c2 * time + c1) * sqrt_0 / c2;
        } else {
			ft = 0.25 * (2 * c2 * time + c1) * sqrt_0 / c2 + 0.5 * Math.log((0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
        }
		
		var exp2 : Float = (0.5 * c1) / sqrt_c2 + sqrt_c0;
		
		if (exp2 < PRECISION) {
			f0 = 0.25 * (c1) * sqrt_c0 / c2;
        } else {
			f0 = 0.25 * (c1) * sqrt_c0 / c2 + 0.5 * Math.log((0.5 * c1) / sqrt_c2 + sqrt_c0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
        }
		
		return ft - f0;
    }
	
	public static function getSegmentBounds(segment : QuadraticBezier, bounds : flash.geom.Rectangle) : flash.geom.Rectangle
	{
		var xMin : Float;
		var xMax : Float;
		var yMin : Float;
		var yMax : Float;
		bounds = bounds == (null) ? new flash.geom.Rectangle() : bounds;
		var x : Float = segment.startX - 2 * segment.controlX + segment.endX;
		var extremumTimeX : Float = ((segment.startX - segment.controlX) / x) || 0;
		var extemumPointX : Vertex = evaluateSegmentPosition(segment, extremumTimeX);
		
		if (Math.isNaN(extemumPointX.x) || extremumTimeX <= 0 || extremumTimeX >= 1) {
			xMin = Math.min(segment.startX, segment.endX);
			xMax = Math.max(segment.startX, segment.endX);
        } else {
			xMin = Math.min(extemumPointX.x, Math.min(segment.startX, segment.endX));
			xMax = Math.max(extemumPointX.x, Math.max(segment.startX, segment.endX));
        }
		
		var y : Float = segment.startY - 2 * segment.controlY + segment.endY;
		var extremumTimeY : Float = ((segment.startY - segment.controlY) / y) || 0;
		var extemumPointY : Vertex = evaluateSegmentPosition(segment, extremumTimeY);
		
		if (Math.isNaN(extemumPointY.y) || extremumTimeY <= 0 || extremumTimeY >= 1) {
			yMin = Math.min(segment.startY, segment.endY);
			yMax = Math.max(segment.startY, segment.endY);
        } else {
			yMin = Math.min(extemumPointY.y, Math.min(segment.startY, segment.endY));
			yMax = Math.max(extemumPointY.y, Math.max(segment.startY, segment.endY));
        }
		
		bounds.x = xMin; 
		bounds.y = yMin;
		bounds.width = xMax - xMin;
		bounds.height = yMax - yMin;
		return bounds;
    }
	
	public static function getClosestRatioOnSegment(segment : QuadraticBezier, x : Float, y : Float) : Float
	{
		var sx : Float = segment.startX;
		var sy : Float = segment.startY;
		var cx : Float = segment.controlX;
		var cy : Float = segment.controlY;
		var ex : Float = segment.endX;
		var ey : Float = segment.endY;
		var lpx : Float = sx - x;
		var lpy : Float = sy - y;
		var kpx : Float = sx - 2 * cx + ex;
		var kpy : Float = sy - 2 * cy + ey;
		var npx : Float = -2 * sx + 2 * cx;
		var npy : Float = -2 * sy + 2 * cy;
		var delimiter : Float = 2 * (kpx * kpx + kpy * kpy);
		var A : Float;
		var B : Float;
		var C : Float;
		var extremumTimes : Array<Dynamic>;
		
		if (delimiter != 0) {
			A = 3 * (npx * kpx + npy * kpy) / delimiter;
			B = ((npx * npx + npy * npy) + 2 * (lpx * kpx + lpy * kpy)) / delimiter;
			C = (npx * lpx + npy * lpy) / delimiter;
			extremumTimes = Equations.solveCubicEquation(1, A, B, C);
        } else {
			B = (npx * npx + npy * npy) + 2 * (lpx * kpx + lpy * kpy);
			C = npx * lpx + npy * lpy;
			extremumTimes = Equations.solveLinearEquation(B, C);
        }
		
		extremumTimes.push(0);
		extremumTimes.push(1);
		var extremumTime : Float;
		var extremumPoint : Vertex = new Vertex();
		var extremumDistance : Float;
		var closestPointTime : Float;
		var closestDistance : Float;
		var isInside : Bool;
		var len : Int = extremumTimes.length;
		
		for (i in 0...len) {
			extremumTime = extremumTimes[i];
			evaluateSegmentPosition(segment, extremumTime, extremumPoint);
			var dx : Float = x - extremumPoint.x;
			var dy : Float = y - extremumPoint.y;
			extremumDistance = Math.sqrt(dx * dx + dy * dy);
			isInside = (extremumTime >= 0) && (extremumTime <= 1);
			
			if (Math.isNaN(closestPointTime)) {
				if (isInside) {
					closestPointTime = extremumTime;
					closestDistance = extremumDistance;
                }
				continue;                
            }
			
			if (extremumDistance < closestDistance) {
				if (isInside) {
					closestPointTime = extremumTime;
					closestDistance = extremumDistance;
                }
            }
        }
		return closestPointTime;
    }

    public function new()
    {
    }
}