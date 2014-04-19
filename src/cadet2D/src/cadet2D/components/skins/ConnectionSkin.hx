  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.skins;

import cadet2d.components.skins.Connection;
import cadet2d.components.skins.Graphics;
import cadet2d.components.skins.Point;
import cadet2d.components.skins.Renderer2D;
import cadet2d.components.skins.Shape;
import cadet.events.ValidationEvent;import cadet2d.components.connections.Connection;import cadet2d.components.renderers.Renderer2D;import nme.geom.Point;import starling.display.Graphics;import starling.display.Shape;@:meta(CadetEditor(transformable="false"))
class ConnectionSkin extends AbstractSkin2D
{
    public var renderer(get, set) : Renderer2D;
    public var connection(get, set) : Connection;
    public var lineThickness(get, set) : Float;
    public var lineColor(get, set) : Int;
    public var lineAlpha(get, set) : Float;
    public var radius(get, set) : Float;
private var _lineThickness : Float;private var _lineColor : Float;private var _lineAlpha : Float;private var _radius : Float;private var _connection : Connection;private var _renderer : Renderer2D;private var _shape : Shape;public function new(lineThickness : Float = 1, lineColor : Int = 0xFFFFFF, lineAlpha : Float = 0.5, width : Float = 10, radius : Float = 10)
    {
        super();name = "ConnectionSkin";this.lineThickness = lineThickness;this.lineColor = lineColor;this.lineAlpha = lineAlpha;this.radius = radius;this.width = width;_displayObject = new Shape();_shape = cast((_displayObject), Shape);
    }override private function addedToScene() : Void{super.addedToScene();addSiblingReference(Connection, "connection");addSceneReference(Renderer2D, "renderer");
    }private function set_Renderer(value : Renderer2D) : Renderer2D{_renderer = value;invalidate(DISPLAY);
        return value;
    }private function get_Renderer() : Renderer2D{return _renderer;
    }private function set_Connection(value : Connection) : Connection{if (_connection != null) {_connection.removeEventListener(ValidationEvent.INVALIDATE, invalidateConnectionHandler);
        }_connection = value;if (_connection != null) {_connection.addEventListener(ValidationEvent.INVALIDATE, invalidateConnectionHandler);
        }invalidate(DISPLAY);
        return value;
    }private function get_Connection() : Connection{return _connection;
    }private function invalidateConnectionHandler(event : ValidationEvent) : Void{invalidate(DISPLAY);
    }override public function validateNow() : Void{if (isInvalid(DISPLAY)) {validateDisplay();
        }super.validateNow();
    }override private function validateDisplay() : Bool{if (_connection == null)             return false;if (_renderer == null || !_renderer.viewport)             return false;var graphics : Graphics = _shape.graphics;graphics.clear();graphics.lineStyle(lineThickness, lineColor, lineAlpha);var pt1 : Point = _connection.transformA.globalMatrix.transformPoint(_connection.localPosA.toPoint());pt1 = _renderer.worldToViewport(pt1);pt1 = _renderer.viewport.localToGlobal(pt1);pt1 = _shape.globalToLocal(pt1);var pt2 : Point = _connection.transformB.globalMatrix.transformPoint(_connection.localPosB.toPoint());pt2 = _renderer.worldToViewport(pt2);pt2 = _renderer.viewport.localToGlobal(pt2);pt2 = _shape.globalToLocal(pt2);graphics.drawCircle(pt1.x, pt1.y, radius);graphics.drawCircle(pt2.x, pt2.y, radius);graphics.lineStyle(width, lineColor, lineAlpha);graphics.moveTo(pt1.x, pt1.y);graphics.lineTo(pt2.x, pt2.y);super.validateDisplay();return true;
    }  // Getters / Setters ////////////////////////////////////////////////////////////////////////////  @:meta(Serializable())
@:meta(Inspectable(label="Line thickness",priority="1",editor="Slider",min="0.1",max="100",snapInterval="0.1"))
private function set_LineThickness(value : Float) : Float{_lineThickness = value;invalidate(DISPLAY);
        return value;
    }private function get_LineThickness() : Float{return _lineThickness;
    }@:meta(Serializable())
@:meta(Inspectable(label="Line colour",priority="2",editor="ColorPicker"))
private function set_LineColor(value : Int) : Int{_lineColor = value;invalidate(DISPLAY);
        return value;
    }private function get_LineColor() : Int{return _lineColor;
    }@:meta(Serializable())
@:meta(Inspectable(label="Line alpha",priority="3",editor="Slider",min="0",max="1"))
private function set_LineAlpha(value : Float) : Float{_lineAlpha = value;invalidate(DISPLAY);
        return value;
    }private function get_LineAlpha() : Float{return _lineAlpha;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_Radius(value : Float) : Float{_radius = value;invalidate(DISPLAY);
        return value;
    }private function get_Radius() : Float{return _radius;
    }  /*		[Serializable][Inspectable]
		public function set width( value:Number ):void
		{
			_width = value;
			invalidate(DISPLAY);
		}
		public function get width():Number { return _width; }*/  
}