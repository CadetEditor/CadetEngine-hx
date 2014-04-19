package components.processes;

import components.processes.BounceBehaviour;
import components.processes.Component;
import components.processes.ISteppableComponent;
import components.processes.ImageSkin;
import components.processes.Point;
import components.processes.Rectangle;
import components.processes.TextureComponent;
import cadet.core.Component;import cadet.core.ISteppableComponent;import cadet2d.components.skins.ImageSkin;import cadet2d.components.textures.TextureComponent;import components.behaviours.BounceBehaviour;import nme.geom.Point;import nme.geom.Rectangle;class BunnySpawner extends Component implements ISteppableComponent
{public var numEntities : Int = 100;private var entityIndex : Int;public var textureComponent : TextureComponent;public var boundsRect : Rectangle;public function new()
    {
        super();
    }private function createBunny() : Void{  // Add the BounceBehaviour to the scene  var randomVelocity : Point = new Point(Math.random() * 10, (Math.random() * 10) - 5);var bounceBehaviour : BounceBehaviour = new BounceBehaviour();bounceBehaviour.velocity = randomVelocity;bounceBehaviour.boundsRect = boundsRect;scene.children.addItem(bounceBehaviour);  // Add a Skin to the scene  var skin : ImageSkin = new ImageSkin();skin.texture = textureComponent;scene.children.addItem(skin);  // Pass reference to skin to bounceBehaviour  bounceBehaviour.transform = skin;
    }public function step(dt : Float) : Void{if (entityIndex < numEntities) {entityIndex++;createBunny();
        }
    }
}