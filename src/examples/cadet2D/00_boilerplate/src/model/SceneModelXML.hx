package model;

import model.Event;
import model.Renderer2D;
import nme.display.DisplayObject;
import nme.events.Event;
import cadet.core.CadetScene;
import cadet.util.ComponentUtil;
import cadet2d.components.renderers.Renderer2D;

class SceneModelXML implements ISceneModel
{
	public var cadetScene(get, set) : CadetScene;
	private var _parent : DisplayObject;
	private var _cadetScene : CadetScene;
	
	public function new()
	{
	}
	
	public function init(parent : DisplayObject) : Void
	{
		_parent = parent;  
		// Grab a reference to the Renderer2D and enable it  
		var renderer : Renderer2D = ComponentUtil.getChildOfType(_cadetScene, Renderer2D);
		renderer.enable(parent);
		_parent.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function get_cadetScene() : CadetScene
	{
		return _cadetScene;
	}
	
	private function set_cadetScene(value : CadetScene) : CadetScene
	{
		_cadetScene = value;
		return value;
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		_cadetScene.step();
	}
}