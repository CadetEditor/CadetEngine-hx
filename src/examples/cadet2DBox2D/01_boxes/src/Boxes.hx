import ApplyTorqueBehaviour;
import nme.display.Sprite;
import nme.events.Event;
import cadet.core.CadetScene;
import cadet.core.ComponentContainer;
import cadet2d.components.geom.RectangleGeometry;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.skins.GeometrySkin;
import cadet2d.components.transforms.Transform2D;
import cadet2dbox2d.components.behaviours.RigidBodyBehaviour;
import cadet2dbox2d.components.behaviours.RigidBodyMouseDragBehaviour;
import cadet2dbox2d.components.processes.DebugDrawProcess;
import cadet2dbox2d.components.processes.PhysicsProcess;
import components.behaviours.ApplyTorqueBehaviour;

@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class Boxes extends Sprite
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
		cadetScene.children.addItem(new PhysicsProcess());  
		//			var debugDraw:DebugDrawProcess = new DebugDrawProcess();    
		//			cadetScene.children.addItem( debugDraw );  
		var boxSize : Int = 10;
		for (i in 0...80) {
			var x : Float = Math.random() * stage.stageWidth;
			var y : Float = Math.random() * 100;
			var width : Float = boxSize + Math.random() * boxSize;
			var height : Float = boxSize + Math.random() * boxSize;
			addRectangleEntity(x, y, width, height, Math.random() * 360);
		}
		var rotatingRectangle : ComponentContainer = addRectangleEntity(0, -100, 60, 60);
		rotatingRectangle.children.addItem(new ApplyTorqueBehaviour(10, 2));  
		// Create the floor. We pass 'true' as the 'fixed' property to make the floor static.  
		addRectangleEntity( -200, stage.stageHeight - 50, stage.stageWidth + 200, 50, 0, true);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function addRectangleEntity(x : Float, y : Float, width : Float, height : Float, rotation : Float = 0, fixed : Bool = false) : ComponentContainer
	{
		var transform : Transform2D = new Transform2D(x, y, rotation); 
		var skin : GeometrySkin = new GeometrySkin();
		var entity : ComponentContainer = new ComponentContainer();
		entity.children.addItem(transform);
		entity.children.addItem(skin);
		entity.children.addItem(new RectangleGeometry(width, height));
		entity.children.addItem(new RigidBodyBehaviour(fixed));
		entity.children.addItem(new RigidBodyMouseDragBehaviour());
		cadetScene.children.addItem(entity);
		return entity;
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		cadetScene.step();
	}
}