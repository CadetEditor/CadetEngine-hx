import BunnyAsset;
import BunnySpawner;
import cadet.core.CadetScene;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.textures.TextureComponent;
import components.processes.BunnySpawner;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;

@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class BunnyMarkSpawner extends Sprite
{
	@:meta(Embed(source="assets/wabbit_alpha.png"))
	private var BunnyAsset : Class<Dynamic>;
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
		// Create the shared TextureComponent  
		var textureComponent : TextureComponent = new TextureComponent();
		textureComponent.bitmapData = Type.createInstance(BunnyAsset, []).bitmapData;
		cadetScene.children.addItem(textureComponent);  
		// Create the BunnySpawner Process  
		var bunnySpawner : BunnySpawner = new BunnySpawner();
		bunnySpawner.textureComponent = textureComponent;
		bunnySpawner.numEntities = 1000;
		bunnySpawner.boundsRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		cadetScene.children.addItem(bunnySpawner);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		cadetScene.step();
	}
}