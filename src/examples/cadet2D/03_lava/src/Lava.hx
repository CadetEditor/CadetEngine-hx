/*
An example demonstrating an effect achievable with an animated UV vertex shader.

Assets used in the Starling-Graphics-Extension with kind permission of Tomislav Podhraski. Original tutorial here
http://gamedev.tutsplus.com/tutorials/implementation/create-a-glowing-flowing-lava-river-using-bezier-curves-and-shaders/
*/import Cadet2DStartUpOperation;
import Event;
import EventDispatcher;
import ISceneModel;
import SceneModelCode;
import SceneModelXML;
import Sprite;
import nme.display.Sprite;import nme.events.Event;import nme.events.EventDispatcher;import cadet.core.CadetScene;import cadet2d.operations.Cadet2DStartUpOperation;import core.app.CoreApp;import core.app.util.AsynchronousUtil;import core.app.util.SerializationUtil;import model.ISceneModel;import model.SceneModelCode;import model.SceneModelXML;@:meta(SWF(width="800",height="600",backgroundColor="0x002135",frameRate="60"))
class Lava extends Sprite
{private var _sceneModel : ISceneModel;  // Comment out either of the below to switch ISceneModels.    // URL = SceneModel_XML, null = SceneModel_Code  private var _cadetFileURL : String = "/lava.cdt2d";  //		private var _cadetFileURL:String = null;  public function new()
    {
        super();  // Required when loading data and assets.  var startUpOperation : Cadet2DStartUpOperation = new Cadet2DStartUpOperation(_cadetFileURL);startUpOperation.addEventListener(flash.events.Event.COMPLETE, startUpCompleteHandler);startUpOperation.execute();
    }private function startUpCompleteHandler(event : Event) : Void{var operation : Cadet2DStartUpOperation = cast((event.target), Cadet2DStartUpOperation);  // If a _cadetFileURL is specified, load the external CadetScene from XML    // Otherwise, revert to the coded version of the CadetScene.  if (_cadetFileURL != null) {_sceneModel = new SceneModelXML();_sceneModel.cadetScene = cast((operation.getResult()), CadetScene);
        }
        else {_sceneModel = new SceneModelCode(CoreApp.resourceManager);  // Need to wait for the next frame to serialize, otherwise the manifests aren't ready  AsynchronousUtil.callLater(serialize);
        }_sceneModel.init(this);
    }private function serialize() : Void{var eventDispatcher : EventDispatcher = SerializationUtil.serialize(_sceneModel.cadetScene);eventDispatcher.addEventListener(flash.events.Event.COMPLETE, serializationCompleteHandler);
    }private function serializationCompleteHandler(event : flash.events.Event) : Void{trace(SerializationUtil.getResult().toXMLString());
    }
}