package components.behaviours;

import components.behaviours.GeometrySkin;
import components.behaviours.Renderer2D;
import cadet.core.Component;
import cadet.core.ISteppableComponent;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.skins.GeometrySkin;

class UpdateAlphaBehaviour extends Component implements ISteppableComponent
{
	public var skin : GeometrySkin;
	public var renderer : Renderer2D;
	
	public function new()
	{
		super();
	}
	
	override private function addedToScene() : Void
	{
		addSiblingReference(GeometrySkin, "skin");
		addSceneReference(Renderer2D, "renderer");
	}
	
	public function step(dt : Float) : Void
	{
		if (skin == null) return;
		skin.fillAlpha = renderer.mouseX / renderer.viewport.stage.stageWidth;
	}
}