import Cadet2DStartUpOperation;
import Event;
import ISceneModel;
import SceneModelXML;
import Sprite;
import nme.display.Sprite;import nme.events.Event;import cadet.core.CadetScene;import cadet2d.operations.Cadet2DStartUpOperation;import model.ISceneModel;import model.SceneModelXML;@:meta(SWF(width="800",height="600",backgroundColor="0x002135",frameRate="60"))
class Boilerplate extends Sprite
{private var _sceneModel : ISceneModel;private var _cadetFileURL : String = "/scene.cdt2d";public function new()
    {
        super();  // Required when loading data and assets.  var startUpOperation : Cadet2DStartUpOperation = new Cadet2DStartUpOperation(_cadetFileURL);startUpOperation.addManifest(startUpOperation.baseManifestURL + "Cadet2DBox2D.xml");startUpOperation.addEventListener(flash.events.Event.COMPLETE, startUpCompleteHandler);startUpOperation.execute();
    }private function startUpCompleteHandler(event : Event) : Void{var operation : Cadet2DStartUpOperation = cast((event.target), Cadet2DStartUpOperation);if (_cadetFileURL != null) {_sceneModel = new SceneModelXML();_sceneModel.cadetScene = cast((operation.getResult()), CadetScene);
        }_sceneModel.init(this);
    }
}