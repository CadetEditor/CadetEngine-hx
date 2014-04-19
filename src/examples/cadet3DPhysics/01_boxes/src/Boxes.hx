import ApplyTorqueBehaviour;
import CadetScene;
import CameraComponent;
import ColorMaterialComponent;
import CubeGeometryComponent;
import DirectionalLightComponent;
import Event;
import MeshComponent;
import PhysicsProcess;
import PlaneGeometryComponent;
import Renderer3D;
import RigidBodyBehaviour;
import Sprite;
import TridentComponent;
import nme.display.Sprite;import nme.events.Event;import cadet.core.CadetScene;import cadet3d.components.cameras.CameraComponent;import cadet3d.components.core.MeshComponent;import cadet3d.components.debug.TridentComponent;import cadet3d.components.geom.CubeGeometryComponent;import cadet3d.components.geom.PlaneGeometryComponent;import cadet3d.components.lights.DirectionalLightComponent;import cadet3d.components.materials.ColorMaterialComponent;import cadet3d.components.renderers.Renderer3D;import cadet3dphysics.components.behaviours.RigidBodyBehaviour;import cadet3dphysics.components.processes.PhysicsProcess;import components.behaviours.ApplyTorqueBehaviour;@:meta(SWF(width="700",height="400",backgroundColor="0x002135",frameRate="60"))
class Boxes extends Sprite
{private var cadetScene : CadetScene;private var defaultMaterial : ColorMaterialComponent;public function new()
    {
        super();cadetScene = new CadetScene();  // Add Renderer  var renderer : Renderer3D = new Renderer3D();renderer.viewportWidth = stage.stageWidth;renderer.viewportHeight = stage.stageHeight;cadetScene.children.addItem(renderer);renderer.enable(this);  // Add Trident  var trident : TridentComponent = new TridentComponent();cadetScene.children.addItem(trident);  // Add Camera  var camera : CameraComponent = new CameraComponent();camera.rotationX = -145;camera.rotationY = -45;camera.rotationZ = -180;camera.x = 1000;camera.y = 1000;camera.z = 1000;cadetScene.children.addItem(camera);  // Add Light source  var dirLight : DirectionalLightComponent = new DirectionalLightComponent();dirLight.ambient = 0.3;dirLight.diffuse = 1;dirLight.rotationX = 65;dirLight.rotationY = -90;cadetScene.children.addItem(dirLight);  // Add Physics Process  cadetScene.children.addItem(new PhysicsProcess());  // Add default Material  defaultMaterial = new ColorMaterialComponent();cadetScene.children.addItem(defaultMaterial);  // Create floor  var planeGeometry : PlaneGeometryComponent = new PlaneGeometryComponent(6000, 6000);var planeEntity : MeshComponent = new MeshComponent();planeEntity.materialComponent = defaultMaterial;planeEntity.geometryComponent = planeGeometry;planeEntity.children.addItem(planeGeometry);planeEntity.children.addItem(new RigidBodyBehaviour());cadetScene.children.addItem(planeEntity);  // Create cubes  var sceneWidth : Int = 2000;var sceneHeight : Int = 6000;var sceneDepth : Int = 2000;var cubeSize : Int = 80;var variation : Int = 20;for (i in 0...150){var x : Float = Math.random() * sceneWidth - sceneWidth / 2;var y : Float = Math.random() * sceneHeight;var z : Float = Math.random() * sceneDepth - sceneDepth / 2;var width : Float = cubeSize + Math.random() * variation;var height : Float = cubeSize + Math.random() * variation;var depth : Float = cubeSize + Math.random() * variation;addCubeEntity(x, y, z, width, height, depth);
        }  // Add big cube Material  var bigCubeMaterial : ColorMaterialComponent = new ColorMaterialComponent();bigCubeMaterial.color = 0xFF0000;cadetScene.children.addItem(bigCubeMaterial);  // Add big cube  var bigCube : MeshComponent = addCubeEntity(0, 6500, 0, 200, 200, 200);bigCube.materialComponent = bigCubeMaterial;bigCube.children.addItem(new ApplyTorqueBehaviour());addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }private function addCubeEntity(x : Float, y : Float, z : Float, width : Float, height : Float, depth : Float) : MeshComponent{var cubeGeometry : CubeGeometryComponent = new CubeGeometryComponent(width, height, depth);var entity : MeshComponent = new MeshComponent();entity.x = x;entity.y = y;entity.z = z;entity.materialComponent = defaultMaterial;entity.geometryComponent = cubeGeometry;entity.children.addItem(cubeGeometry);entity.children.addItem(new RigidBodyBehaviour());cadetScene.children.addItem(entity);return entity;
    }private function enterFrameHandler(event : Event) : Void{cadetScene.step();
    }
}