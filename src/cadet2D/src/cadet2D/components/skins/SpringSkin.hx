  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Inspectable Priority range 100-149  package cadet2d.components.skins;

import cadet.events.ValidationEvent;import cadet2d.components.connections.Connection;import cadet2d.components.renderers.Renderer2D;import nme.geom.Point;import starling.display.Graphics;import starling.display.Shape;class SpringSkin extends AbstractSkin2D
{
    public var renderer(get, set) : Renderer2D;
    public var connection(get, set) : Connection;
    public var lineThickness(get, set) : Float;
    public var lineColor(get, set) : Int;
    public var lineAlpha(get, set) : Float;
    public var numZigZags(get, set) : Float;
  // Invalidation types    //protected static const DISPLAY	:String = "display";  private var _lineThickness : Float;private var _lineColor : Float;private var _lineAlpha : Float;private var _numZigZags : Float;private var _width : Float;private var _connection : Connection;private var _renderer : Renderer2D;private var _shape : Shape;public function new(lineThickness : Float = 1, lineColor : Int = 0xFFFFFF, lineAlpha : Float = 0.5, numZigZags : Int = 20, width : Float = 10)
    {
        super();name = "SpringSkin";this.lineThickness = lineThickness;this.lineColor = lineColor;this.lineAlpha = lineAlpha;this.numZigZags = numZigZags;this.width = width;_displayObject = new Shape();_shape = cast((_displayObject), Shape);
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
    }override private function validateDisplay() : Bool{if (_connection == null)             return false;if (_renderer == null || !_renderer.viewport)             return false;if (!_connection.transformA)             return false;if (!_connection.transformB)             return false;var graphics : Graphics = _shape.graphics;graphics.clear();graphics.lineStyle(lineThickness, lineColor, lineAlpha);var pt1 : Point = _connection.transformA.matrix.transformPoint(_connection.localPosA.toPoint());pt1 = _renderer.worldToViewport(pt1);pt1 = _renderer.viewport.localToGlobal(pt1);pt1 = _shape.globalToLocal(pt1);var pt2 : Point = _connection.transformB.matrix.transformPoint(_connection.localPosB.toPoint());pt2 = _renderer.worldToViewport(pt2);pt2 = _renderer.viewport.localToGlobal(pt2);pt2 = _shape.globalToLocal(pt2);graphics.moveTo(pt1.x, pt1.y);var switcher : Int = 1;var nx : Float = pt2.x - pt1.x;var ny : Float = pt2.y - pt1.y;var m : Float = Math.sqrt(nx * nx + ny * ny);var n : Point = new Point((ny / m) * width * 0.5, -(nx / m) * width * 0.5);for (i in 0...numZigZags){var ratio : Float = (i + 1) / (numZigZags + 1);var ptx : Float = pt1.x + ratio * nx;var pty : Float = pt1.y + ratio * ny;ptx += n.x * switcher;pty += n.y * switcher;graphics.lineTo(ptx, pty);switcher *= -1;
        }graphics.lineTo(pt2.x, pt2.y);super.validateDisplay();return true;
    }  // Getters / Setters ////////////////////////////////////////////////////////////////////////////  @:meta(Serializable())
@:meta(Inspectable(label="Line thickness",priority="100"))
private function set_LineThickness(value : Float) : Float{_lineThickness = value;invalidate(DISPLAY);
        return value;
    }private function get_LineThickness() : Float{return _lineThickness;
    }@:meta(Serializable())
@:meta(Inspectable(label="Line color",priority="101",editor="ColorPicker"))
private function set_LineColor(value : Int) : Int{_lineColor = value;invalidate(DISPLAY);
        return value;
    }private function get_LineColor() : Int{return _lineColor;
    }@:meta(Serializable())
@:meta(Inspectable(label="Line alpha",priority="102",editor="Slider",min="0",max="1"))
private function set_LineAlpha(value : Float) : Float{_lineAlpha = value;invalidate(DISPLAY);
        return value;
    }private function get_LineAlpha() : Float{return _lineAlpha;
    }@:meta(Serializable())
@:meta(Inspectable())
private function set_NumZigZags(value : Float) : Float{_numZigZags = value;invalidate(DISPLAY);
        return value;
    }private function get_NumZigZags() : Float{return _numZigZags;
    }  /*		[Serializable][Inspectable]
		public function set width( value:Number ):void
		{
			_width = value;
			invalidate(DISPLAY);
		}
		public function get width():Number { return _width; }*/  
}