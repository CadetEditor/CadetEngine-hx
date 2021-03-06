import AnimateRotationBehaviour;
import CadetScene;
import CircleGeometry;
import ComponentContainer;
import Event;
import GeometrySkin;
import RectangleGeometry;
import Renderer2D;
import ShadedCircleSkin;
import Sprite;
import Transform2D;
import UpdateAlphaBehaviour;
import nme.display.Sprite;
import nme.events.Event;
import cadet.core.CadetScene;
import cadet.core.ComponentContainer;
import cadet2d.components.geom.CircleGeometry;
import cadet2d.components.geom.RectangleGeometry;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.skins.GeometrySkin;
import cadet2d.components.transforms.Transform2D;
import components.behaviours.AnimateRotationBehaviour;
import components.behaviours.UpdateAlphaBehaviour;
import components.skins.ShadedCircleSkin;

@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class BehavioursAndSkins extends Sprite
{
	private var cadetScene : CadetScene;
	
	public function new()
	{
		super();
		cadetScene = new CadetScene();
		var renderer : Renderer2D = new Renderer2D();
		renderer.viewportWidth = stage.stageWidth;
		renderer.viewportHeight = stage.stageHeight;
		cadetScene.children.addItem(renderer);
		renderer.enable(this);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);  
		// Rectangle Entity  
		var rectangleEntity : ComponentContainer = new ComponentContainer();
		rectangleEntity.name = "Rectangle";
		cadetScene.children.addItem(rectangleEntity);
		var transform : Transform2D = new Transform2D();
		transform.x = 250;
		transform.y = 150;
		rectangleEntity.children.addItem(transform);
		var rectangleGeometry : RectangleGeometry = new RectangleGeometry();
		rectangleGeometry.width = 200;
		rectangleGeometry.height = 100;
		rectangleEntity.children.addItem(rectangleGeometry);
		var skin : GeometrySkin = new GeometrySkin();
		rectangleEntity.children.addItem(skin);
		var animateRotationBehaviour : AnimateRotationBehaviour = new AnimateRotationBehaviour();
		rectangleEntity.children.addItem(animateRotationBehaviour);
		var updateAlphaBehaviour : UpdateAlphaBehaviour = new UpdateAlphaBehaviour();
		rectangleEntity.children.addItem(updateAlphaBehaviour);  
		// Circle Entity  
		var circleEntity : ComponentContainer = new ComponentContainer();
		circleEntity.name = "Circle"; 
		cadetScene.children.addItem(circleEntity);
		transform = new Transform2D();
		transform.x = 550;
		transform.y = 150;
		circleEntity.children.addItem(transform);
		var circleGeometry : CircleGeometry = new CircleGeometry(50);
		circleEntity.children.addItem(circleGeometry);
		var shadedCircleSkin : ShadedCircleSkin = new ShadedCircleSkin();
		circleEntity.children.addItem(shadedCircleSkin);
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		cadetScene.step();
	}
}