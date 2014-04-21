// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 100-149  

package cadet2d.components.skins;

import cadet2d.components.skins.BezierCurve;
import cadet2d.components.skins.BitmapData;
import cadet2d.components.skins.CircleGeometry;
import cadet2d.components.skins.CompoundGeometry;
import cadet2d.components.skins.IGeometry;
import cadet2d.components.skins.IMaterialComponent;
import cadet2d.components.skins.IRenderable;
import cadet2d.components.skins.Matrix;
import cadet2d.components.skins.PolygonGeometry;
import cadet2d.components.skins.QuadraticBezier;
import cadet2d.components.skins.TextureComponent;
import cadet2d.components.skins.Vertex;
import nme.errors.Error;
import nme.display.BitmapData;
import nme.geom.Matrix;
import cadet.components.geom.IGeometry;
import cadet.events.ValidationEvent;
import cadet.util.BitmapDataUtil;
import cadet2d.components.geom.BezierCurve; 
import cadet2d.components.geom.CircleGeometry;
import cadet2d.components.geom.CompoundGeometry;
import cadet2d.components.geom.PolygonGeometry;
import cadet2d.components.materials.IMaterialComponent;
import cadet2d.components.textures.TextureComponent;
import cadet2d.geom.QuadraticBezier;
import cadet2d.geom.Vertex;
import starling.core.Starling;
import starling.display.Graphics;
import starling.display.Shape;

class GeometrySkin extends AbstractSkin2D implements IRenderable
{
    public var geometry(get, set) : IGeometry;
    public var lineAlpha(get, set) : Float;
    public var lineThickness(get, set) : Float;
    public var lineColor(get, set) : Int;
    public var fillAlpha(get, set) : Float;
    public var fillColor(get, set) : Int;
    public var fillBitmap(get, set) : BitmapData;
    public var lineMaterial(get, set) : IMaterialComponent;
    public var lineTexture(get, set) : TextureComponent;
    public var drawVertices(get, set) : Bool;
	private var _lineThickness : Float;
	private var _lineColor : Int;
	private var _lineAlpha : Float;
	private var _fillColor : Int;
	private var _fillAlpha : Float;
	private var _fillBitmap : BitmapData;
	private var _lineMaterial : IMaterialComponent;
	private var _lineTexture : TextureComponent;
	private var _drawVertices : Bool = false;
	private var _geometry : IGeometry;
	private var _shape : Shape;
	
	public function new(lineThickness : Float = 1, lineColor : Int = 0xFFFFFF, lineAlpha : Float = 0.7, fillColor : Int = 0xFFFFFF, fillAlpha : Float = 0.04)
    {
        super();
		name = "GeometrySkin";
		this.lineThickness = lineThickness;
		this.lineColor = lineColor;
		this.lineAlpha = lineAlpha;
		this.fillColor = fillColor;
		this.fillAlpha = fillAlpha;
		_displayObject = new Shape();
		_shape = cast((_displayObject), Shape);
    }
	
	override private function addedToScene() : Void
	{
		super.addedToScene();
		addSiblingReference(IGeometry, "geometry");
    }
	
	private function set_Geometry(value : IGeometry) : IGeometry
	{
		if (_geometry != null) {
			_geometry.removeEventListener(ValidationEvent.INVALIDATE, invalidateGeometryHandler);
        }
		_geometry = value;
		if (_geometry != null) {
			_geometry.addEventListener(ValidationEvent.INVALIDATE, invalidateGeometryHandler);
        }
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_Geometry() : IGeometry
	{
		return _geometry;
    }  
	
	/*		override public function invalidate( invalidationType:String ):void
	{
		//trace(invalidationType);
		if ( invalidationType == DISPLAY ) {
			trace("I Disp");
		}
		super.invalidate( invalidationType );
	}*/  
		
	private function invalidateGeometryHandler(event : ValidationEvent) : Void
	{
		invalidate(DISPLAY);
    }
	
	override private function validateDisplay() : Bool
	{
		super.validateDisplay(); 
		if (!Starling.current) return false;
		var graphics : Graphics = _shape.graphics; 
		graphics.clear();
		super.validateDisplay();
		return render(_geometry);
    }
	
	private function render(geometry : IGeometry) : Bool
	{
		if (Std.is(geometry, PolygonGeometry)) {
			return renderPolygon(cast((geometry), PolygonGeometry));
        } else if (Std.is(geometry, CircleGeometry)) {
			return renderCircle(cast((geometry), CircleGeometry));
        } else if (Std.is(geometry, BezierCurve)) {
			return renderBezier(cast((geometry), BezierCurve));
        } else if (Std.is(geometry, CompoundGeometry)) {
			var compoundGeometry : CompoundGeometry = cast((geometry), CompoundGeometry);
			for (childGeometry/* AS3HX WARNING could not determine type for var: childGeometry exp: EField(EIdent(compoundGeometry),children) type: null */ in compoundGeometry.children) {
				return render(childGeometry);
            }
        }
		return false;
    }
	
	private function renderPolygon(polygon : PolygonGeometry) : Bool
	{
		var graphics : Graphics = _shape.graphics;
		var vertices : Array<Dynamic> = polygon.vertices;
		var firstVertex : Vertex = vertices[0];
		if (firstVertex == null) {
			return false;
        }
		setLineStyle();
		if (_fillBitmap != null) {
			var m : Matrix = new Matrix();  
			//m.translate(_fillXOffset, _fillYOffset);  
			try {
				graphics.beginBitmapFill(_fillBitmap, m);
            } catch (e : Error) {
				trace("Error: " + e.errorID + " " + e.message);
            }
        } else if (_fillAlpha > 0) {
			graphics.beginFill(_fillColor, _fillAlpha);
        }
		
		graphics.moveTo(firstVertex.x, firstVertex.y);
		for (i in 1...vertices.length) {
			var vertex : Vertex = vertices[i];
			graphics.lineTo(vertex.x, vertex.y);
        }
		graphics.lineTo(firstVertex.x, firstVertex.y);
		graphics.endFill();  
		// Don't have to draw vertices. If you got this far, return true.  
		if (!_drawVertices) {
			return true;
        }
		graphics.beginFill(0xFF0000, 1);
		for (vertex in vertices) {
			graphics.drawCircle(vertex.x, vertex.y, 2);
        }
		return true;
    }
	
	private function renderCircle(circle : CircleGeometry) : Bool
	{
		var graphics : Graphics = _shape.graphics;
		setLineStyle();
		if (_fillBitmap != null) {
			var m : Matrix = new Matrix();  
			//m.translate(_fillXOffset, _fillYOffset);  
			graphics.beginBitmapFill(_fillBitmap, m);
        } else if (_fillAlpha > 0) {
			graphics.beginFill(_fillColor, _fillAlpha);
        }
		graphics.drawCircle(circle.x, circle.y, circle.radius);
		graphics.endFill(); 
		graphics.moveTo(circle.x, circle.y);
		graphics.lineTo(circle.x + circle.radius, circle.y);
		return true;
    }
	
	private function renderBezier(bezierCurve : BezierCurve) : Bool
	{
		var graphics : Graphics = _shape.graphics;
		if (!setLineStyle()) {
			return false;
        }  
		//QuadraticBezierUtil.draw(graphics, bezierCurve.segments);  
		if (bezierCurve.segments.length == 0) {
			return false;
        }
		var segment : QuadraticBezier = bezierCurve.segments[0];
		graphics.moveTo(segment.startX, segment.startY);
		for (i in 0...bezierCurve.segments.length) {
			segment = bezierCurve.segments[i];
			graphics.curveTo(segment.controlX, segment.controlY, segment.endX, segment.endY);
        }
		return true;
    }
	
	private function setLineStyle() : Bool
	{
		var graphics : Graphics = _shape.graphics;
		if (_lineThickness != 0) {
			if (_lineMaterial != null) {
				if (_lineMaterial.material.textures && _lineMaterial.material.textures.length > 0) {
					graphics.lineMaterial(_lineThickness, _lineMaterial.material);
					return true;
                }
            } else if (_lineTexture != null) {
				if (_lineTexture.texture) {
					graphics.lineTexture(_lineThickness, _lineTexture.texture);
					return true;
                }
            } else {
				graphics.lineStyle(_lineThickness, _lineColor, _lineAlpha);  //, false, LineScaleMode.NONE );  
				return true;
            }
        }
		return false;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(label="Line alpha",priority="100",editor="Slider",min="0",max="1"))
	private function set_LineAlpha(value : Float) : Float
	{
		_lineAlpha = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_LineAlpha() : Float
	{
		return _lineAlpha;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(label = "Line thickness", priority = "101"))//, editor="Slider", min="0.1", max="100", snapInterval="0.1" )]  
	private function set_LineThickness(value : Float) : Float
	{
		_lineThickness = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_LineThickness() : Float
	{
		return _lineThickness;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(label="Line colour",priority="102",editor="ColorPicker"))
	private function set_LineColor(value : Int) : Int
	{
		_lineColor = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_LineColor() : Int
	{
		return _lineColor;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(label="Fill alpha",priority="103",editor="Slider",min="0",max="1"))
	private function set_FillAlpha(value : Float) : Float
	{
		_fillAlpha = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_FillAlpha() : Float
	{
		return _fillAlpha;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(label="Fill colour",priority="104",editor="ColorPicker"))
	private function set_FillColor(value : Int) : Int
	{
		_fillColor = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_FillColor() : Int
	{
		return _fillColor;
    }
	
	@:meta(Serializable(type="resource"))
	@:meta(Inspectable(label="Fill bitmap",priority="105",editor="ResourceItemEditor"))
	private function set_FillBitmap(value : BitmapData) : BitmapData
	{  
		// Needs to be a power of two in order to be tileable  
		_fillBitmap = BitmapDataUtil.makePowerOfTwo(value);
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_FillBitmap() : BitmapData
	{
		return _fillBitmap;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="106"))
	private function set_LineMaterial(value : IMaterialComponent) : IMaterialComponent
	{
		if (_lineMaterial != null) {
			_lineMaterial.removeEventListener(ValidationEvent.VALIDATED, lineTextureValidatedHandler);
        }
		_lineMaterial = value;
		if (_lineMaterial != null) {
			lineTexture = null;  // Mutually exclusive values  
			_lineMaterial.addEventListener(ValidationEvent.VALIDATED, lineTextureValidatedHandler);
        }
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_LineMaterial() : IMaterialComponent
	{
		return _lineMaterial;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="107"))
	private function set_LineTexture(value : TextureComponent) : TextureComponent
	{
		if (_lineTexture != null) {
			_lineTexture.removeEventListener(ValidationEvent.VALIDATED, lineTextureValidatedHandler);
        }
		_lineTexture = value;
		if (_lineTexture != null) {
			lineMaterial = null;  // Mutually exclusive values  
			_lineTexture.addEventListener(ValidationEvent.VALIDATED, lineTextureValidatedHandler);
        }
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_LineTexture() : TextureComponent
	{
		return _lineTexture;
    }  
	
	/*		[Serializable][Inspectable( priority="106")]
		public function set fillXOffset( value:Number ):void
		{
			_fillXOffset = value;
			invalidate( DISPLAY );
		}
		public function get fillXOffset():Number { return _fillXOffset; }
		
		[Serializable][Inspectable( priority="107")]
		public function set fillYOffset( value:Number ):void
		{
			_fillYOffset = value;
			invalidate( DISPLAY );
		}
		public function get fillYOffset():Number { return _fillYOffset; }*/  
		
	@:meta(Serializable())
	@:meta(Inspectable(label="Draw vertices",priority="108"))
	private function set_DrawVertices(value : Bool) : Bool
	{
		_drawVertices = value;
		invalidate(DISPLAY);
        return value;
    }
	
	private function get_DrawVertices() : Bool
	{
		return _drawVertices;
    }
	
	private function lineTextureValidatedHandler(event : ValidationEvent) : Void
	{
		invalidate(DISPLAY);
    }
}