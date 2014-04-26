// Press SPACEBAR twice to step scene.    
// 3rd component is removed from scene and added as child of second.  
import nme.display.Sprite;
import nme.events.Event;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import cadet.components.processes.InputProcess;
import cadet.components.processes.KeyboardInputMapping;
import cadet.core.CadetScene;
import cadet.core.ComponentContainer;
import cadet.events.InputProcessEvent;
import cadet.util.ComponentUtil;
import cadet2d.components.geom.RectangleGeometry;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.skins.GeometrySkin;
import cadet2d.components.transforms.Transform2D;
import components.behaviours.AnimateRotationBehaviour;

@:meta(SWF(width="1024",height="768",backgroundColor="0x002135",frameRate="60"))
class C2DTestsTransform02 extends Sprite
{
	private var cadetScene : CadetScene;
	private var rectangleEntity1 : ComponentContainer;
	private var rectangleEntity2 : ComponentContainer;
	private var rectangleEntity3 : ComponentContainer;
	private var count : Int = 0;
	
	public function new()
	{
		super();
		var tf : TextField = new TextField();
		addChild(tf);
		tf.text = "Press SPACEBAR twice to step scene.\n3rd component is removed from scene and added as child of second.";
		tf.textColor = 0xFFFFFF;
		tf.autoSize = TextFieldAutoSize.LEFT;
		cadetScene = new CadetScene();
		var renderer : Renderer2D = new Renderer2D();
		renderer.viewportWidth = stage.stageWidth;
		renderer.viewportHeight = stage.stageHeight;
		cadetScene.children.addItem(renderer);
		renderer.enable(this);
		var inputProcess : InputProcess = new InputProcess(); c
		adetScene.children.addItem(inputProcess);
		inputProcess.addEventListener(InputProcessEvent.INPUT_DOWN, inputDownHandler);
		var keyboardInput : KeyboardInputMapping = new KeyboardInputMapping("SPACE");
		keyboardInput.input = KeyboardInputMapping.SPACE;
		inputProcess.children.addItem(keyboardInput);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);  
		// Create first rectangle and add to scene  
		rectangleEntity1 = createRectangleEntity(cadetScene, 200, 200, 40, 40, 0xFF0000);  
		//var parentTransform:Transform2D = ComponentUtil.getChildOfType(rectangleEntity1, Transform2D);    
		//parentTransform.scaleX = 1.5;  
		var animateRotationBehaviour : AnimateRotationBehaviour = new AnimateRotationBehaviour();
		rectangleEntity1.children.addItem(animateRotationBehaviour);  
		// Create second rectangle and nest within first  
		rectangleEntity2 = createRectangleEntity(rectangleEntity1, 40, 40, 40, 40, 0x00FF00);  
		// Create third rectangle and add to scene  
		rectangleEntity3 = createRectangleEntity(cadetScene, 40, 40, 40, 40, 0x0000FF);
	}
	
	private function createRectangleEntity(parent : ComponentContainer, x : Float, y : Float, width : Float, height : Float, lineColour : Int = 0xFFFFFF) : ComponentContainer
	{
		var rectangleEntity : ComponentContainer = new ComponentContainer();
		rectangleEntity.name = "Rectangle";
		parent.children.addItem(rectangleEntity);
		var transform : Transform2D = new Transform2D();
		transform.x = x;
		transform.y = y;
		rectangleEntity.children.addItem(transform);
		var rectangleGeometry : RectangleGeometry = new RectangleGeometry();
		rectangleGeometry.width = width;
		rectangleGeometry.height = height;
		rectangleEntity.children.addItem(rectangleGeometry);
		var skin : GeometrySkin = new GeometrySkin();
		skin.lineColor = lineColour;
		rectangleEntity.children.addItem(skin);
		return rectangleEntity;
	}
	
	private function inputDownHandler(event : InputProcessEvent) : Void
	{
		if (event.name == "SPACE") {
			if (count == 0) {
				rectangleEntity3.parentComponent.children.removeItem(rectangleEntity3);
			} else if (count == 1) {
				rectangleEntity2.children.addItem(rectangleEntity3);
			}
			count++;
		}
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		cadetScene.step();
	}
}