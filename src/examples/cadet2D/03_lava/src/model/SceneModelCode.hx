package model;

import model.AnimateUVVertexShaderComponent;
import model.BezierCurve;
import model.ComponentContainer;
import model.Event;
import model.GeometrySkin;
import model.ImageSkin;
import model.QuadraticBezier;
import model.Renderer2D;
import model.ResourceManager;
import model.StandardMaterialComponent;
import model.TextureComponent;
import model.TextureFragmentShaderComponent;
import model.Transform2D;
import nme.display.DisplayObject;
import nme.events.Event;
import cadet.core.CadetScene;
import cadet.core.ComponentContainer;
import cadet2d.components.geom.BezierCurve;
import cadet2d.components.materials.StandardMaterialComponent;
import cadet2d.components.renderers.Renderer2D;
import cadet2d.components.shaders.fragment.TextureFragmentShaderComponent;
import cadet2d.components.shaders.vertex.AnimateUVVertexShaderComponent;
import cadet2d.components.skins.GeometrySkin;
import cadet2d.components.skins.ImageSkin;
import cadet2d.components.textures.TextureComponent;
import cadet2d.components.transforms.Transform2D;
import cadet2d.geom.QuadraticBezier;
import core.app.managers.ResourceManager;

class SceneModelCode implements ISceneModel
{
	public var cadetScene(get, set) : CadetScene;
	private var _parent : DisplayObject;
	private var _cadetScene : CadetScene;
	private var _resourceManager : ResourceManager;
	private var _bgTextureURL : String = "lavaDemo/FinalBackground.png";
	private var _fgTextureURL : String = "lavaDemo/FinalRock.png";
	private var _banksTextureURL : String = "lavaDemo/BanksTiled.png";
	private var _lavaTextureURL : String = "lavaDemo/LavaTiled.png";
	private var _lavaThickness : Float = 90;
	private var _banksThickness : Float = _lavaThickness * 2.2;
	
	public function new(resourceManager : ResourceManager)
	{
		_cadetScene = new CadetScene();
		_resourceManager = resourceManager;
	}
	
	public function init(parent : DisplayObject) : Void
	{
		_parent = parent;
		var renderer : Renderer2D = new Renderer2D();
		renderer.viewportWidth = parent.stage.stageWidth;
		renderer.viewportHeight = parent.stage.stageHeight;
		_cadetScene.children.addItem(renderer);
		renderer.enable(parent.stage);
		drawBg();
		drawLava();
		drawBanks();
		drawFg();
		_parent.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function get_cadetScene() : CadetScene
	{
		return _cadetScene;
	}
	
	private function set_cadetScene(value : CadetScene) : CadetScene
	{
		_cadetScene = value;
		return value;
	}
	
	private function drawBg() : Void
	{
		var entity : ComponentContainer = new ComponentContainer("Background Entity");
		_cadetScene.children.addItem(entity);  
		// Add the bg texture to the scene  
		var bgTexture : TextureComponent = new TextureComponent("Bg Texture");
		_resourceManager.bindResource(_bgTextureURL, bgTexture, "bitmapData");
		entity.children.addItem(bgTexture);
		var imgSkin : ImageSkin = new ImageSkin("Bg Skin");
		imgSkin.texture = bgTexture;
		imgSkin.width = _parent.stage.stageWidth;
		imgSkin.height = _parent.stage.stageHeight;
		entity.children.addItem(imgSkin);
	}
	
	private function drawFg() : Void
	{
		var entity : ComponentContainer = new ComponentContainer("Foreground Entity");
		_cadetScene.children.addItem(entity);  
		// Add the bg texture to the scene  
		var fgTexture : TextureComponent = new TextureComponent("Fg Texture");
		_resourceManager.bindResource(_fgTextureURL, fgTexture, "bitmapData");
		entity.children.addItem(fgTexture);
		var imgSkin : ImageSkin = new ImageSkin("Fg Skin");
		imgSkin.texture = fgTexture;
		imgSkin.width = _parent.stage.stageWidth;
		imgSkin.height = _parent.stage.stageHeight * 1.6;
		entity.children.addItem(imgSkin);
	}
	
	private function drawLava() : Void
	{
		var entity : ComponentContainer = new ComponentContainer("Lava Entity");
		_cadetScene.children.addItem(entity);
		var curve : BezierCurve = new BezierCurve();
		entity.children.addItem(curve);
		var transform : Transform2D = new Transform2D();
		entity.children.addItem(transform);
		var skin : GeometrySkin = new GeometrySkin(_lavaThickness);
		entity.children.addItem(skin);
		var qb : QuadraticBezier;
		qb = new QuadraticBezier(150, 0, 500, 100, 500, 300);
		curve.segments.push(qb);
		qb = new QuadraticBezier(500, 300, 500, 500, 700, 650);
		curve.segments.push(qb);  
		// Add lava material to scene  
		var lavaMaterial : StandardMaterialComponent = new StandardMaterialComponent();
		entity.children.addItem(lavaMaterial);  
		// Add shaders to lava material  
		var vertexShader : AnimateUVVertexShaderComponent = new AnimateUVVertexShaderComponent();
		vertexShader.uSpeed = 0.1;
		vertexShader.vSpeed = 0;
		entity.children.addItem(vertexShader);
		var fragmentShader : TextureFragmentShaderComponent = new TextureFragmentShaderComponent();
		entity.children.addItem(fragmentShader);  
		// Add the lava texture to the scene  
		var lavaTexture : TextureComponent = new TextureComponent("Lava Texture");
		_resourceManager.bindResource(_lavaTextureURL, lavaTexture, "bitmapData");
		lavaMaterial.children.addItem(lavaTexture);
		lavaMaterial.vertexShader = vertexShader;
		lavaMaterial.fragmentShader = fragmentShader;
		skin.lineMaterial = lavaMaterial;
	}
	
	private function drawBanks() : Void
	{
		var entity : ComponentContainer = new ComponentContainer("Banks Entity");
		_cadetScene.children.addItem(entity);
		var curve : BezierCurve = new BezierCurve();
		entity.children.addItem(curve);
		var transform : Transform2D = new Transform2D();
		entity.children.addItem(transform);
		var skin : GeometrySkin = new GeometrySkin(_banksThickness);
		entity.children.addItem(skin);
		var qb : QuadraticBezier;
		qb = new QuadraticBezier(150, 0, 500, 100, 500, 300);
		curve.segments.push(qb);
		qb = new QuadraticBezier(500, 300, 500, 500, 700, 650);
		curve.segments.push(qb);  
		// Add the banks texture to the scene  
		var banksTexture : TextureComponent = new TextureComponent("Banks Texture");
		_resourceManager.bindResource(_banksTextureURL, banksTexture, "bitmapData");
		entity.children.addItem(banksTexture);
		skin.lineTexture = banksTexture;
	}
	
	private function enterFrameHandler(event : Event) : Void
	{
		_cadetScene.step();
	}
}