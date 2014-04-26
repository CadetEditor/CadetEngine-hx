package components.skins;

import components.skins.AbstractSkin2D;
import components.skins.CircleGeometry;
import components.skins.Shape;
import components.skins.Texture;
import components.skins.ValidationEvent;
import nme.display.GradientType;
import cadet.events.ValidationEvent;
import cadet2d.components.geom.CircleGeometry;
import cadet2d.components.skins.AbstractSkin2D;
import starling.core.Starling;
import starling.display.Shape;
import starling.textures.GradientTexture;
import starling.textures.Texture;

class ShadedCircleSkin extends AbstractSkin2D
{
	public var circle(get, set) : CircleGeometry;
	private var _circle : CircleGeometry;
	private var _shape : Shape;
	private inline var DISPLAY : String = "display";
	
	public function new()
	{
		super();
		_displayObject = new Shape();
		_shape = cast((_displayObject), Shape);
	}
	
	override private function addedToParent() : Void
	{
		super.addedToParent();
		addSiblingReference(CircleGeometry, "circle");
	}
	
	private function set_circle(value : CircleGeometry) : CircleGeometry
	{
		if (_circle != null) {
			_circle.removeEventListener(ValidationEvent.INVALIDATE, invalidateCircleHandler);
		}
		_circle = value;
		if (_circle != null) {
			_circle.addEventListener(ValidationEvent.INVALIDATE, invalidateCircleHandler);
		}
		invalidate(DISPLAY);
		return value;
	}
	
	private function get_circle() : CircleGeometry
	{
		return _circle;
	}
	
	private function invalidateCircleHandler(event : ValidationEvent) : Void
	{
		invalidate(DISPLAY);
	}
	
	override public function validateNow() : Void
	{
		if (isInvalid(DISPLAY)) {
			validateDisplay();
		}
		super.validateNow();
	}
	
	private function validateDisplay() : Void
	{
		_shape.graphics.clear();
		if (_circle == null) return;
		var colors : Array<Dynamic> = [0xFFFFFF, 0x909090];
		var ratios : Array<Dynamic> = [0, 255];
		var alphas : Array<Dynamic> = [1, 1]; 
		// Don't attempt to create the gradientTexture if the Starling.context is unavailable,    
		// as Texture.fromBitmapData() will throw a missing context error  
		if (!Starling.context) return;
		var gradientTexture : Texture = GradientTexture.create(128, 128, GradientType.RADIAL, colors, alphas, ratios);
		_shape.graphics.beginTextureFill(gradientTexture);
		_shape.graphics.drawCircle(circle.x, circle.y, circle.radius);
		_shape.graphics.endFill();
	}
}