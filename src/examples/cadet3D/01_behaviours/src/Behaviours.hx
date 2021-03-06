import AnimateRotationBehaviour;
import CadetScene;
import CameraComponent;
import ColorMaterialComponent;
import CubeGeometryComponent;
import DirectionalLightComponent;
import Event;
import MeshComponent;
import Renderer3D;
import Sprite;
import TridentComponent;
import nme.display.Sprite;
import nme.events.Event;
import cadet.core.CadetScene;
import cadet3d.components.cameras.CameraComponent;
import cadet3d.components.core.MeshComponent;
import cadet3d.components.debug.TridentComponent;
import cadet3d.components.geom.CubeGeometryComponent;
import cadet3d.components.lights.DirectionalLightComponent;
import cadet3d.components.materials.ColorMaterialComponent;
import cadet3d.components.renderers.Renderer3D;
import components.behaviours.AnimateRotationBehaviour;

@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class Behaviours extends Sprite
{
	private var cadetScene : CadetScene;
	
	public function new()
	{
		super();
		cadetScene = new CadetScene();
		var renderer : Renderer3D = new Renderer3D();
		renderer.viewportWidth = stage.stageWidth;
		renderer.viewportHeight = stage.stageHeight;
		cadetScene.children.addItem(renderer);
		renderer.enable(this);
		var trident : TridentComponent = new TridentComponent();
		cadetScene.children.addItem(trident);
		var camera : CameraComponent = new CameraComponent();
		camera.rotationX = -145;
		camera.rotationY = -45;
		camera.rotationZ = -180;
		camera.x = 1000;
		camera.y = 1000;
		camera.z = 1000;
		cadetScene.children.addItem(camera);
		var material : ColorMaterialComponent = new ColorMaterialComponent();
		cadetScene.children.addItem(material);
		var cubeGeometry : CubeGeometryComponent = new CubeGeometryComponent();
		cubeGeometry.width = 400;
		cubeGeometry.height = 400;
		cubeGeometry.depth = 400;
		cadetScene.children.addItem(cubeGeometry);
		var cubeEntity : MeshComponent = new MeshComponent();
		cubeEntity.name = "Cube";
		cubeEntity.materialComponent = material;
		cubeEntity.geometryComponent = cubeGeometry;
		cadetScene.children.addItem(cubeEntity);
		var animateRotationBehaviour : AnimateRotationBehaviour = new AnimateRotationBehaviour();
		cubeEntity.children.addItem(animateRotationBehaviour);
		var dirLight : DirectionalLightComponent = new DirectionalLightComponent();
		dirLight.ambient = 0.3;
		dirLight.diffuse = 1;
		dirLight.rotationX = 65;
		dirLight.rotationY = -90;
		cadetScene.children.addItem(dirLight);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		cadetScene.step();
	}
}