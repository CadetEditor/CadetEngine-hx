import Cadet3DStartUpOperation;
import CadetScene;
import Event;
import Renderer3D;
import Sprite;
import nme.display.Sprite;import nme.events.Event;import cadet.core.CadetScene;import cadet.util.ComponentUtil;import cadet3d.components.renderers.Renderer3D;import cadet3d.operations.Cadet3DStartUpOperation;@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class Planets extends Sprite
{private var cadetScene : CadetScene;private var cadetFileURL : String = "/planets.cdt3d";public function new()
    {
        super();  // Required when loading data and assets.  var startUpOperation : Cadet3DStartUpOperation = new Cadet3DStartUpOperation(cadetFileURL);startUpOperation.addEventListener(Event.COMPLETE, startUpCompleteHandler);startUpOperation.execute();
    }private function startUpCompleteHandler(event : Event) : Void{var operation : Cadet3DStartUpOperation = cast((event.target), Cadet3DStartUpOperation);initScene(cast((operation.getResult()), CadetScene));
    }private function initScene(scene : CadetScene) : Void{cadetScene = scene;var renderer : Renderer3D = ComponentUtil.getChildOfType(cadetScene, Renderer3D);renderer.enable(this);addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }private function enterFrameHandler(event : Event) : Void{cadetScene.step();
    }
}