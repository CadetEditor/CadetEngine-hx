import BounceBehaviour;
import BunnyAsset;
import CadetScene;
import Event;
import ImageSkin;
import Point;
import Rectangle;
import Renderer2D;
import Sprite;
import TextureComponent;
import cadet.core.CadetScene;import cadet2d.components.renderers.Renderer2D;import cadet2d.components.skins.ImageSkin;import cadet2d.components.textures.TextureComponent;import components.behaviours.BounceBehaviour;import nme.display.Sprite;import nme.events.Event;import nme.geom.Point;import nme.geom.Rectangle;@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class BunnyMark extends Sprite
{@:meta(Embed(source="assets/wabbit_alpha.png"))
private var BunnyAsset : Class<Dynamic>;private var textureComponent : TextureComponent;private var numEntities : Int = 1000;private var entityIndex : Int;private var cadetScene : CadetScene;public function new()
    {
        super();cadetScene = new CadetScene();var renderer : Renderer2D = new Renderer2D();renderer.viewportWidth = stage.stageWidth;renderer.viewportHeight = stage.stageHeight;cadetScene.children.addItem(renderer);renderer.enable(this);  // Create the shared TextureComponent  textureComponent = new TextureComponent();textureComponent.bitmapData = Type.createInstance(BunnyAsset, []).bitmapData;cadetScene.children.addItem(textureComponent);addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }private function enterFrameHandler(event : Event) : Void{if (entityIndex < numEntities) {entityIndex++;createBunny();
        }cadetScene.step();
    }private function createBunny() : Void{  // Add the BounceBehaviour to the scene  var randomVelocity : Point = new Point(Math.random() * 10, (Math.random() * 10) - 5);var bounceBehaviour : BounceBehaviour = new BounceBehaviour();bounceBehaviour.velocity = randomVelocity;bounceBehaviour.boundsRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);cadetScene.children.addItem(bounceBehaviour);  // Add a Skin to the scene  var skin : ImageSkin = new ImageSkin();skin.texture = textureComponent;cadetScene.children.addItem(skin);  // Pass reference to skin to bounceBehaviour  bounceBehaviour.transform = skin;
    }
}