//  //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Inspectable Priority range 50-99  package cadet2d.components.particles;

import cadet2d.components.particles.Bitmap;
import cadet2d.components.particles.BitmapData;
import cadet2d.components.particles.ColorArgb;
import cadet2d.components.particles.Component;
import cadet2d.components.particles.DisplayObject;
import cadet2d.components.particles.IAnimatable;
import cadet2d.components.particles.IComponent;
import cadet2d.components.particles.IComponentContainer;
import cadet2d.components.particles.IInitialisableComponent;
import cadet2d.components.particles.Matrix;
import cadet2d.components.particles.NullParticle;
import cadet2d.components.particles.PDParticleSystem;
import cadet2d.components.particles.Renderer2D;
import cadet2d.components.particles.RendererEvent;
import cadet2d.components.particles.Sprite;
import cadet2d.components.particles.Texture;
import cadet2d.components.particles.TextureComponent;
import nme.errors.ArgumentError;
import nme.errors.Error;
import nme.display.Bitmap;import nme.display.BitmapData;import nme.display3d.Context3DBlendFactor;import nme.geom.Matrix;import cadet.core.Component;import cadet.core.IComponent;import cadet.core.IComponentContainer;import cadet.core.IInitialisableComponent;import cadet.events.RendererEvent;import cadet.util.Deg2rad;import cadet.util.Rad2deg;import cadet2d.components.renderers.Renderer2D;import cadet2d.components.skins.IAnimatable;import cadet2d.components.textures.TextureComponent;import starling.display.DisplayObject;import starling.display.Sprite;import starling.extensions.ColorArgb;import starling.extensions.PDParticleSystem;import starling.textures.Texture;class PDParticleSystemComponent extends Component implements IInitialisableComponent implements IAnimatable
{
    public var x(get, set) : Float;
    public var y(get, set) : Float;
    public var scaleX(get, set) : Float;
    public var scaleY(get, set) : Float;
    public var rotation(get, set) : Float;
    public var matrix(get, set) : Matrix;
    public var serializedMatrix(get, set) : String;
    public var autoplay(get, set) : Bool;
    public var xml(get, set) : FastXML;
    public var texture(get, set) : TextureComponent;
    public var renderer(get, set) : Renderer2D;
    public var isAnimating(get, never) : Bool;
    public var previewAnimation(get, set) : Bool;
    public var emitterType(get, set) : String;
    private var emitterTypeInt(get, never) : Int;
    public var startColor(get, set) : Int;
    public var startColorAlpha(get, set) : Float;
    public var startColorVariance(get, set) : Int;
    public var startColorVarAlpha(get, set) : Float;
    public var endColor(get, set) : Int;
    public var endColorAlpha(get, set) : Float;
    public var endColorVariance(get, set) : Int;
    public var endColorVarAlpha(get, set) : Float;
    public var maxCapacity(get, set) : Int;
    public var emissionRate(get, set) : Float;
    public var emitterX(get, set) : Float;
    public var emitterY(get, set) : Float;
    public var emitterXVariance(get, set) : Float;
    public var emitterYVariance(get, set) : Float;
    public var blendFactorSource(get, set) : String;
    public var blendFactorDest(get, set) : String;
    public var maxNumParticles(get, set) : Int;
    public var lifespan(get, set) : Float;
    public var lifespanVariance(get, set) : Float;
    public var startSize(get, set) : Float;
    public var startSizeVariance(get, set) : Float;
    public var endSize(get, set) : Float;
    public var endSizeVariance(get, set) : Float;
    public var emitAngle(get, set) : Float;
    public var emitAngleVariance(get, set) : Float;
    public var startRotation(get, set) : Float;
    public var startRotationVar(get, set) : Float;
    public var endRotation(get, set) : Float;
    public var endRotationVar(get, set) : Float;
    public var speed(get, set) : Float;
    public var speedVariance(get, set) : Float;
    public var gravityX(get, set) : Float;
    public var gravityY(get, set) : Float;
    public var radialAcceleration(get, set) : Float;
    public var radialAccelVar(get, set) : Float;
    public var tangentialAccel(get, set) : Float;
    public var tangentialAccelVar(get, set) : Float;
    public var maxRadius(get, set) : Float;
    public var maxRadiusVariance(get, set) : Float;
    public var minRadius(get, set) : Float;
    public var rotatePerSecond(get, set) : Float;
    public var rotatePerSecondVar(get, set) : Float;
    public var displayObject(get, never) : DisplayObject;
    public var indexStr(get, never) : String;
  // ITransform2D values  private var _x : Float = 0;private var _y : Float = 0;private var _scaleX : Float = 1;private var _scaleY : Float = 1;private var _rotation : Float = 0;  // Constants  private inline var TRANSFORM : String = "transform";private inline var RESOURCES : String = "resources";private inline var DISPLAY : String = "display";@:meta(Embed(source="NullParticle.png"))
private static var NullParticle : Class<Dynamic>;private static var EMITTER_TYPE_GRAVITY : String = "Gravity";private static var EMITTER_TYPE_RADIAL : String = "Radial";private var _emitterType : String = EMITTER_TYPE_GRAVITY;private var _particleSystem : PDParticleSystem;private var _renderer : Renderer2D;private var _addedToJuggler : Bool;private var _started : Bool;private var _initialised : Bool;private var _autoplay : Bool = true;private var _xml : FastXML;private var _defaultTexture : Texture;private var _texture : TextureComponent;  // GETTER/SETTER VALUES  private var _emitterTypeInt : Int = 0;  // Start Color  private var _startColor : Int = 0x0000FF;private var _startColorAlpha : Float = 1;private var _startColorVariance : Int = 0;private var _startColorVarAlpha : Float = 1;private var _startColorARGB : ColorArgb = new ColorArgb(1, 0, 0, 1);private var _startColorVarARGB : ColorArgb = new ColorArgb(0, 0, 0, 0);  // End Color  private var _endColor : Int = 0x00FFFF;private var _endColorAlpha : Float = 0;private var _endColorVariance : Int = 0;private var _endColorVarAlpha : Int = 0;private var _endColorARGB : ColorArgb = new ColorArgb(0, 0, 1, 1);private var _endColorVarARGB : ColorArgb = new ColorArgb(0, 0, 0, 0);private var _maxCapacity : Int = 8192;private var _emitterX : Float = 0;private var _emitterY : Float = 0;private var _emitterXVariance : Float = 0;private var _emitterYVariance : Float = 0;private var _blendFactorSource : String = Context3DBlendFactor.SOURCE_ALPHA;private var _blendFactorDest : String = Context3DBlendFactor.ONE;private var _maxNumParticles : Int = 128;private var _lifespan : Float = 0.4;private var _lifespanVariance : Float = 0;private var _emissionRate : Float = _maxNumParticles / _lifespan;private var _startSize : Float = 50;private var _startSizeVariance : Float = 0;private var _endSize : Float = 10;private var _endSizeVariance : Float = 0;private var _speed : Float = 800;private var _speedVariance : Float = 0;private var _gravityX : Float = 0;private var _gravityY : Float = 0;private var _radialAcceleration : Float = 0;private var _radialAccelVar : Float = 0;private var _tangentialAccel : Float = 0;private var _tangentialAccelVar : Float = 0;private var _maxRadius : Float = 100;private var _maxRadiusVariance : Float = 0;private var _minRadius : Float = 20;  // Angles    // All angles are stored in degrees and need to be converted to radians when passed back and forth    // from the ParticleSystem. (Degrees make for clearer gradiation with UI)  private var _emitAngle : Float = 0;private var _emitAngleVariance : Float = 0;private var _startRotation : Float = 0;private var _startRotationVar : Float = 0;private var _endRotation : Float = 0;private var _endRotationVar : Float = 0;private var _rotatePerSecond : Float = 720;private var _rotatePerSecondVar : Float = 0;private var _previewAnimation : Bool;  // IRenderable values  private var _displayObject : Sprite;private var _indexStr : String;public function new(config : FastXML = null, textureComponent : TextureComponent = null, name : String = "PDParticleSystemComponent")
    {super(name);_xml = config;_texture = texture;_displayObject = new Sprite();
    }override private function addedToScene() : Void{addSceneReference(Renderer2D, "renderer");if (renderer != null && renderer.initialised) {createDefaultTexture();invalidate(RESOURCES);
        }
    }  // IInitialisableComponent  public function init() : Void{_initialised = true;invalidate(DISPLAY);
    }private function createDefaultTexture() : Void{if (_defaultTexture != null)             return;var instance : BitmapData = Type.createInstance(NullParticle, []).bitmapData;_defaultTexture = Texture.fromBitmap(new Bitmap(instance), false);
    }override public function validateNow() : Void{if (isInvalid(TRANSFORM)) {validateTransform();
        }if (isInvalid(RESOURCES)) {validateResources();
        }if (isInvalid(DISPLAY)) {validateDisplay();
        }super.validateNow();
    }private function validateTransform() : Void{_displayObject.x = _x;_displayObject.y = _y;_displayObject.scaleX = _scaleX;_displayObject.scaleY = _scaleY;_displayObject.rotation = _rotation;
    }private function validateResources() : Void{var config : FastXML;var texture : Texture;if (_xml != null)             config = _xml
        else config = serialise();if (_texture != null && _texture.texture)             texture = _texture.texture
        else texture = _defaultTexture;  // When deserializing from XML, the texture doesn't have a chance to load immediately    // because it requires the Starling.context  if (texture == null)             return;stop(true);  //removeFromDisplayList(true);  removeFromJuggler();if (_particleSystem != null) {_displayObject.removeChild(_particleSystem);
        }_particleSystem = new PDParticleSystem(config, texture);_displayObject.addChild(_particleSystem);  // UPDATE VALUES  _emitterType = emitterTypeIntToString(_particleSystem.emitterType);  // Start Color  _startColor = _particleSystem.startColor.toRgb();_startColorAlpha = _particleSystem.startColor.alpha;_startColorVariance = _particleSystem.startColorVariance.toRgb();_startColorVarAlpha = _particleSystem.startColorVariance.alpha;  // End Color  _endColor = _particleSystem.endColor.toRgb();_endColorAlpha = _particleSystem.endColor.alpha;_endColorVariance = _particleSystem.endColorVariance.toRgb();_endColorVarAlpha = _particleSystem.endColorVariance.alpha;_maxCapacity = _particleSystem.maxCapacity;_emissionRate = _particleSystem.emissionRate;_emitterX = _particleSystem.emitterX;_emitterY = _particleSystem.emitterY;_emitterXVariance = _particleSystem.emitterXVariance;_emitterYVariance = _particleSystem.emitterYVariance;_blendFactorSource = _particleSystem.blendFactorSource;_blendFactorDest = _particleSystem.blendFactorDestination;_maxNumParticles = _particleSystem.maxNumParticles;_lifespan = _particleSystem.lifespan;_lifespanVariance = _particleSystem.lifespanVariance;_startSize = _particleSystem.startSize;_startSizeVariance = _particleSystem.startSizeVariance;_endSize = _particleSystem.endSize;_endSizeVariance = _particleSystem.endSizeVariance;_speed = _particleSystem.speed;_speedVariance = _particleSystem.speedVariance;_gravityX = _particleSystem.gravityX;_gravityY = _particleSystem.gravityY;_radialAcceleration = _particleSystem.radialAcceleration;_radialAccelVar = _particleSystem.radialAccelerationVariance;_tangentialAccel = _particleSystem.tangentialAcceleration;_tangentialAccelVar = _particleSystem.tangentialAccelerationVariance;_maxRadius = _particleSystem.maxRadius;_maxRadiusVariance = _particleSystem.maxRadiusVariance;_minRadius = _particleSystem.minRadius;  // Angles  _emitAngle = rad2deg(_particleSystem.emitAngle);_emitAngleVariance = rad2deg(_particleSystem.emitAngleVariance);_startRotation = rad2deg(_particleSystem.startRotation);_startRotationVar = rad2deg(_particleSystem.startRotationVariance);_endRotation = rad2deg(_particleSystem.endRotation);_endRotationVar = rad2deg(_particleSystem.endRotationVariance);_rotatePerSecond = rad2deg(_particleSystem.rotatePerSecond);_rotatePerSecondVar = rad2deg(_particleSystem.rotatePerSecondVariance);_startColorARGB.copyFrom(_particleSystem.startColor);_startColorVarARGB.copyFrom(_particleSystem.startColorVariance);_endColorARGB.copyFrom(_particleSystem.endColor);_endColorVarARGB.copyFrom(_particleSystem.endColorVariance);addToJuggler();if (_autoplay || _previewAnimation)             start();
    }private function validateDisplay() : Void{  // Set start and end colors for serializing.  _startColorARGB = ColorArgb.fromRgb(_startColor);_startColorARGB.alpha = _startColorAlpha;_startColorVarARGB = ColorArgb.fromArgb(_startColorVariance);_startColorVarARGB.alpha = _startColorVarAlpha;_endColorARGB = ColorArgb.fromRgb(_endColor);_endColorARGB.alpha = _endColorAlpha;_endColorVarARGB = ColorArgb.fromArgb(_endColorVariance);_endColorVarARGB.alpha = _endColorVarAlpha;if (_particleSystem == null)             return;_particleSystem.emitterType = emitterTypeInt;  // Start Color  _particleSystem.startColor = ColorArgb.fromRgb(_startColor);_particleSystem.startColor.alpha = _startColorAlpha;_particleSystem.startColorVariance = ColorArgb.fromRgb(_startColorVariance);_particleSystem.startColorVariance.alpha = _startColorVarAlpha;  // End Color  _particleSystem.endColor = ColorArgb.fromRgb(_endColor);_particleSystem.endColor.alpha = _endColorAlpha;_particleSystem.endColorVariance = ColorArgb.fromRgb(_endColorVariance);_particleSystem.endColorVariance.alpha = _endColorVarAlpha;_particleSystem.maxCapacity = _maxCapacity;_particleSystem.emissionRate = _emissionRate;_particleSystem.emitterX = _emitterX;_particleSystem.emitterY = _emitterY;_particleSystem.emitterXVariance = _emitterXVariance;_particleSystem.emitterYVariance = _emitterYVariance;_particleSystem.blendFactorSource = _blendFactorSource;_particleSystem.blendFactorDestination = _blendFactorDest;_particleSystem.maxNumParticles = _maxNumParticles;_particleSystem.lifespan = _lifespan;_particleSystem.lifespanVariance = _lifespanVariance;_particleSystem.startSize = _startSize;_particleSystem.startSizeVariance = _startSizeVariance;_particleSystem.endSize = _endSize;_particleSystem.endSizeVariance = _endSizeVariance;_particleSystem.speed = _speed;_particleSystem.speedVariance = _speedVariance;_particleSystem.gravityX = _gravityX;_particleSystem.gravityY = _gravityY;_particleSystem.radialAcceleration = _radialAcceleration;_particleSystem.radialAccelerationVariance = _radialAccelVar;_particleSystem.tangentialAcceleration = _tangentialAccel;_particleSystem.tangentialAccelerationVariance = _tangentialAccelVar;_particleSystem.maxRadius = _maxRadius;_particleSystem.maxRadiusVariance = _maxRadiusVariance;_particleSystem.minRadius = _minRadius;  // Angles  _particleSystem.emitAngle = deg2rad(_emitAngle);_particleSystem.emitAngleVariance = deg2rad(_emitAngleVariance);_particleSystem.startRotation = deg2rad(_startRotation);_particleSystem.startRotationVariance = deg2rad(_startRotationVar);_particleSystem.endRotation = deg2rad(_endRotation);_particleSystem.endRotationVariance = deg2rad(_endRotationVar);_particleSystem.rotatePerSecond = deg2rad(_rotatePerSecond);_particleSystem.rotatePerSecondVariance = deg2rad(_rotatePerSecondVar);_startColorARGB.copyFrom(_particleSystem.startColor);_startColorVarARGB.copyFrom(_particleSystem.startColorVariance);_endColorARGB.copyFrom(_particleSystem.endColor);_endColorVarARGB.copyFrom(_particleSystem.endColorVariance);addToJuggler();if (_autoplay || _previewAnimation)             start();
    }  // -------------------------------------------------------------------------------------    // ITRANSFORM2D API    // -------------------------------------------------------------------------------------  @:meta(Inspectable(priority="50"))
private function set_X(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_x = value;invalidate(TRANSFORM);
        return value;
    }private function get_X() : Float{return _x;
    }@:meta(Inspectable(priority="51"))
private function set_Y(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_y = value;invalidate(TRANSFORM);
        return value;
    }private function get_Y() : Float{return _y;
    }@:meta(Inspectable(priority="52"))
private function set_ScaleX(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_scaleX = value;invalidate(TRANSFORM);
        return value;
    }private function get_ScaleX() : Float{return _scaleX;
    }@:meta(Inspectable(priority="53"))
private function set_ScaleY(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_scaleY = value;invalidate(TRANSFORM);
        return value;
    }private function get_ScaleY() : Float{return _scaleY;
    }@:meta(Inspectable(priority="54",editor="Slider",min="0",max="360",snapInterval="1"))
private function set_Rotation(value : Float) : Float{if (Math.isNaN(value)) {throw (new Error("value is not a number"));
        }_rotation = deg2rad(value);invalidate(TRANSFORM);
        return value;
    }private function get_Rotation() : Float{return rad2deg(_rotation);
    }private function set_Matrix(value : Matrix) : Matrix{_displayObject.transformationMatrix = value;_x = _displayObject.x;_y = _displayObject.y;_scaleX = _displayObject.scaleX;_scaleY = _displayObject.scaleY;_rotation = _displayObject.rotation;invalidate(TRANSFORM);
        return value;
    }private function get_Matrix() : Matrix{if (isInvalid(TRANSFORM)) {validateTransform();
        }return _displayObject.transformationMatrix;
    }@:meta(Serializable(alias="matrix"))
private function set_SerializedMatrix(value : String) : String{var split : Array<Dynamic> = value.split(",");matrix = new Matrix(split[0], split[1], split[2], split[3], split[4], split[5]);
        return value;
    }private function get_SerializedMatrix() : String{var m : Matrix = matrix;return m.a + "," + m.b + "," + m.c + "," + m.d + "," + m.tx + "," + m.ty;
    }  // -------------------------------------------------------------------------------------    // -------------------------------------------------------------------------------------    // INSPECTABLE API    // -------------------------------------------------------------------------------------  @:meta(Serializable())
@:meta(Inspectable())
private function set_Autoplay(value : Bool) : Bool{_autoplay = value;
        return value;
    }private function get_Autoplay() : Bool{return _autoplay;
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(priority="55",editor="ResourceItemEditor",extensions="[pex]"))
private function set_Xml(value : FastXML) : FastXML{_xml = value;invalidate(RESOURCES);
        return value;
    }private function get_Xml() : FastXML{return _xml;
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="56"))
private function set_Texture(value : TextureComponent) : TextureComponent{_texture = value;invalidate(RESOURCES);
        return value;
    }private function get_Texture() : TextureComponent{return _texture;
    }  // -------------------------------------------------------------------------------------  private function get_Renderer() : Renderer2D{return _renderer;
    }private function set_Renderer(value : Renderer2D) : Renderer2D{if (_renderer != null) {_renderer.removeEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }_renderer = value;if (_renderer == null)             return;if (_renderer.initialised) {invalidate(DISPLAY);
        }
        else {_renderer.addEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);
        }
        return value;
    }private function rendererInitialisedHandler(event : RendererEvent) : Void{_renderer.removeEventListener(RendererEvent.INITIALISED, rendererInitialisedHandler);createDefaultTexture();invalidate(RESOURCES);invalidate(DISPLAY);
    }  // -------------------------------------------------------------------------------------    // IANIMATABLE API    // -------------------------------------------------------------------------------------  public function addToJuggler() : Bool{if (!_initialised && !_previewAnimation)             return false  // only add if in run mode or if previewing  ;if (renderer == null || !renderer.initialised)             return false;if (_particleSystem == null)             return false;if (_addedToJuggler)             return false;renderer.addToJuggler(_particleSystem);_addedToJuggler = true;return true;
    }public function removeFromJuggler() : Bool{if (renderer == null || !renderer.initialised)             return false;if (_particleSystem == null)             return false;if (!_addedToJuggler)             return false;renderer.removeFromJuggler(_particleSystem);_addedToJuggler = false;return true;
    }private function get_IsAnimating() : Bool{return _addedToJuggler;
    }  // IAnimatable : Design time  private function get_PreviewAnimation() : Bool{return _previewAnimation;
    }private function set_PreviewAnimation(value : Bool) : Bool{_previewAnimation = value;invalidate(DISPLAY);
        return value;
    }  // -------------------------------------------------------------------------------------  public function start(duration : Float = Float.MAX_VALUE) : Void{if (!_initialised && !_previewAnimation)             return;if (_particleSystem == null)             return  //if (_started) return;  ;_particleSystem.start(duration);_started = true;
    }public function stop(clearParticles : Bool = false) : Void{if (_particleSystem == null)             return  //if (!_started) return;  ;_particleSystem.stop(clearParticles);_started = false;
    }@:meta(Serializable())
@:meta(Inspectable(priority="57",editor="DropDownMenu",dataProvider="[Gravity,Radial]"))
private function get_EmitterType() : String{return _emitterType;
    }private function set_EmitterType(value : String) : String{_emitterType = value;invalidate(DISPLAY);
        return value;
    }private function emitterTypeIntToString(value : Int) : String{if (value == 0) {return EMITTER_TYPE_GRAVITY;
        }
        else if (value == 1) {return EMITTER_TYPE_RADIAL;
        }return null;
    }private function get_EmitterTypeInt() : Int{var intType : Int = 0;if (_emitterType == EMITTER_TYPE_RADIAL) {intType = 1;
        }return intType;
    }@:meta(Serializable())
@:meta(Inspectable(priority="58",editor="ColorPicker"))
private function get_StartColor() : Int{return _startColor;
    }private function set_StartColor(value : Int) : Int{_startColor = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="59",editor="Slider",min="0",max="1",snapInterval="0.05"))
private function get_StartColorAlpha() : Float{return _startColorAlpha;
    }private function set_StartColorAlpha(value : Float) : Float{_startColorAlpha = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="60",editor="ColorPicker"))
private function get_StartColorVariance() : Int{return _startColorVariance;
    }private function set_StartColorVariance(value : Int) : Int{_startColorVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="61",editor="Slider",min="0",max="1",snapInterval="0.05"))
private function get_StartColorVarAlpha() : Float{return _startColorVarAlpha;
    }private function set_StartColorVarAlpha(value : Float) : Float{_startColorVarAlpha = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="62",editor="ColorPicker"))
private function get_EndColor() : Int{return _endColor;
    }private function set_EndColor(value : Int) : Int{_endColor = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="63",editor="Slider",min="0",max="1",snapInterval="0.05"))
private function get_EndColorAlpha() : Float{return _endColorAlpha;
    }private function set_EndColorAlpha(value : Float) : Float{_endColorAlpha = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="64",editor="ColorPicker"))
private function get_EndColorVariance() : Int{return _endColorVariance;
    }private function set_EndColorVariance(value : Int) : Int{_endColorVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="65",editor="Slider",min="0",max="1",snapInterval="0.05"))
private function get_EndColorVarAlpha() : Float{return _endColorVarAlpha;
    }private function set_EndColorVarAlpha(value : Float) : Float{_endColorVarAlpha = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="66"))
private function get_MaxCapacity() : Int{return _maxCapacity;
    }private function set_MaxCapacity(value : Int) : Int{_maxCapacity = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="67"))
private function get_EmissionRate() : Float{return _emissionRate;
    }private function set_EmissionRate(value : Float) : Float{_emissionRate = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="68"))
private function get_EmitterX() : Float{return _emitterX;
    }private function set_EmitterX(value : Float) : Float{_emitterX = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="69"))
private function get_EmitterY() : Float{return _emitterY;
    }private function set_EmitterY(value : Float) : Float{_emitterY = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="70"))
private function get_EmitterXVariance() : Float{return _emitterXVariance;
    }private function set_EmitterXVariance(value : Float) : Float{_emitterXVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="71"))
private function get_EmitterYVariance() : Float{return _emitterYVariance;
    }private function set_EmitterYVariance(value : Float) : Float{_emitterYVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="72",editor="DropDownMenu",dataProvider="[zero,one,sourceColor,oneMinusSourceColor,sourceAlpha,oneMinusSourceAlpha,destinationAlpha,oneMinusDestinationAlpha,destinationColor,oneMinusDestinationColor]"))
private function get_BlendFactorSource() : String{return _blendFactorSource;
    }private function set_BlendFactorSource(value : String) : String{_blendFactorSource = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="73",editor="DropDownMenu",dataProvider="[zero,one,sourceColor,oneMinusSourceColor,sourceAlpha,oneMinusSourceAlpha,destinationAlpha,oneMinusDestinationAlpha,destinationColor,oneMinusDestinationColor]"))
private function get_BlendFactorDest() : String{return _blendFactorDest;
    }private function set_BlendFactorDest(value : String) : String{_blendFactorDest = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="74"))
private function get_MaxNumParticles() : Int{return _maxNumParticles;
    }private function set_MaxNumParticles(value : Int) : Int{_maxNumParticles = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="75"))
private function get_Lifespan() : Float{return _lifespan;
    }private function set_Lifespan(value : Float) : Float{_lifespan = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="76"))
private function get_LifespanVariance() : Float{return _lifespanVariance;
    }private function set_LifespanVariance(value : Float) : Float{_lifespanVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="77"))
private function get_StartSize() : Float{return _startSize;
    }private function set_StartSize(value : Float) : Float{_startSize = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="78"))
private function get_StartSizeVariance() : Float{return _startSizeVariance;
    }private function set_StartSizeVariance(value : Float) : Float{_startSizeVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="79"))
private function get_EndSize() : Float{return _endSize;
    }private function set_EndSize(value : Float) : Float{_endSize = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="80"))
private function get_EndSizeVariance() : Float{return _endSizeVariance;
    }private function set_EndSizeVariance(value : Float) : Float{_endSizeVariance = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="81",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_EmitAngle() : Float{return _emitAngle;
    }private function set_EmitAngle(value : Float) : Float{_emitAngle = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="82",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_EmitAngleVariance() : Float{return _emitAngleVariance;
    }private function set_EmitAngleVariance(value : Float) : Float{_emitAngleVariance = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="83",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_StartRotation() : Float{return _startRotation;
    }private function set_StartRotation(value : Float) : Float{_startRotation = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="84",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_StartRotationVar() : Float{return _startRotationVar;
    }private function set_StartRotationVar(value : Float) : Float{_startRotationVar = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="85",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_EndRotation() : Float{return _endRotation;
    }private function set_EndRotation(value : Float) : Float{_endRotation = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="86",editor="Slider",min="0",max="360",snapInterval="1"))
private function get_EndRotationVar() : Float{return _endRotationVar;
    }private function set_EndRotationVar(value : Float) : Float{_endRotationVar = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="87"))
private function get_Speed() : Float{return _speed;
    }private function set_Speed(value : Float) : Float{_speed = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="88"))
private function get_SpeedVariance() : Float{return _speedVariance;
    }private function set_SpeedVariance(value : Float) : Float{_speedVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="89"))
private function get_GravityX() : Float{return _gravityX;
    }private function set_GravityX(value : Float) : Float{_gravityX = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="90"))
private function get_GravityY() : Float{return _gravityY;
    }private function set_GravityY(value : Float) : Float{_gravityY = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="91"))
private function get_RadialAcceleration() : Float{return _radialAcceleration;
    }private function set_RadialAcceleration(value : Float) : Float{_radialAcceleration = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="92"))
private function get_RadialAccelVar() : Float{return _radialAccelVar;
    }private function set_RadialAccelVar(value : Float) : Float{_radialAccelVar = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="93"))
private function get_TangentialAccel() : Float{return _tangentialAccel;
    }private function set_TangentialAccel(value : Float) : Float{_tangentialAccel = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="94"))
private function get_TangentialAccelVar() : Float{return _tangentialAccelVar;
    }private function set_TangentialAccelVar(value : Float) : Float{_tangentialAccelVar = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="95"))
private function get_MaxRadius() : Float{return _maxRadius;
    }private function set_MaxRadius(value : Float) : Float{_maxRadius = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="96"))
private function get_MaxRadiusVariance() : Float{return _maxRadiusVariance;
    }private function set_MaxRadiusVariance(value : Float) : Float{_maxRadiusVariance = value;invalidate(DISPLAY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="97"))
private function get_MinRadius() : Float{return _minRadius;
    }private function set_MinRadius(value : Float) : Float{_minRadius = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="98"))
private function get_RotatePerSecond() : Float{return _rotatePerSecond;
    }private function set_RotatePerSecond(value : Float) : Float{_rotatePerSecond = value;invalidate(DISPLAY);
        return value;
    }  // Degrees  @:meta(Serializable())
@:meta(Inspectable(priority="99"))
private function get_RotatePerSecondVar() : Float{return _rotatePerSecondVar;
    }private function set_RotatePerSecondVar(value : Float) : Float{_rotatePerSecondVar = value;invalidate(DISPLAY);
        return value;
    }public function serialise() : FastXML{  // Note: XML Angles are stored in degrees  var defaultXML : FastXML = FastXML.parse("<particleEmitterConfig>
				  <texture name=\"drugs_particle.png\"/>
				  <sourcePosition x={emitterX} y={emitterY}/>
				  <sourcePositionVariance x={emitterXVariance} y={emitterYVariance}/>
				  <speed value={speed}/>
				  <speedVariance value={speedVariance}/>
				  <particleLifeSpan value={lifespan}/>
				  <particleLifespanVariance value={lifespanVariance}/>
				  <gravity x={gravityX} y={gravityY}/>
				  <radialAcceleration value={radialAcceleration}/>
				  <tangentialAcceleration value={tangentialAccel}/>
				  <radialAccelVariance value={radialAccelVar}/>
				  <tangentialAccelVariance value={tangentialAccelVar}/>
				  <startColor red={_startColorARGB.red} green={_startColorARGB.green} blue={_startColorARGB.blue} alpha={_startColorARGB.alpha}/>
				  <startColorVariance red={_startColorVarARGB.red} green={_startColorVarARGB.green} blue={_startColorVarARGB.blue} alpha={_startColorVarARGB.alpha}/>
				  <finishColor red={_endColorARGB.red} green={_endColorARGB.green} blue={_endColorARGB.blue} alpha={_endColorARGB.alpha}/>
				  <finishColorVariance red={_endColorVarARGB.red} green={_endColorVarARGB.green} blue={_endColorVarARGB.blue} alpha={_endColorVarARGB.alpha}/>
				  <maxParticles value={maxNumParticles}/>
				  <startParticleSize value={startSize}/>
				  <startParticleSizeVariance value={startSizeVariance}/>
				  <finishParticleSize value={endSize}/>
				  <FinishParticleSizeVariance value={endSizeVariance}/>
				  <duration value=\"-1.00\"/>
				  <emitterType value={emitterTypeInt}/>
				  <maxRadius value={maxRadius}/>
				  <maxRadiusVariance value={maxRadiusVariance}/>
				  <minRadius value={minRadius}/>
				  <blendFuncSource value={getBlendFunc(blendFactorSource)}/>
				  <blendFuncDestination value={getBlendFunc(blendFactorDest)}/>
				  <angle value={emitAngle}/>
				  <angleVariance value={emitAngleVariance}/>
				  <rotationStart value={startRotation}/>
				  <rotationStartVariance value={startRotationVar}/>
				  <rotationEnd value={endRotation}/>
				  <rotationEndVariance value={endRotationVar}/>
				  <rotatePerSecond value={rotatePerSecond}/>
				  <rotatePerSecondVariance value={rotatePerSecondVar}/>
				</particleEmitterConfig>");return defaultXML;
    }private function getBlendFunc(value : String) : Int{

        switch (value)
        {case Context3DBlendFactor.ZERO:return 0;case Context3DBlendFactor.ONE:return 1;case Context3DBlendFactor.SOURCE_COLOR:return 0x300;case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:return 0x301;case Context3DBlendFactor.SOURCE_ALPHA:return 0x302;case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:return 0x303;case Context3DBlendFactor.DESTINATION_ALPHA:return 0x304;case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:return 0x305;case Context3DBlendFactor.DESTINATION_COLOR:return 0x306;case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:return 0x307;default:throw new ArgumentError("unsupported blending function: " + value);
        }
    }  // -------------------------------------------------------------------------------------    // IRENDERABLE API    // -------------------------------------------------------------------------------------  private function get_DisplayObject() : DisplayObject{return _displayObject;
    }private function get_IndexStr() : String{  // Refresh the indices  var component : IComponent = this;while (component.parentComponent){component.index = component.parentComponent.children.getItemIndex(component);component = component.parentComponent;
        }  // Refresh the indexStr  var indexArr : Array<Dynamic> = [index];var parent : IComponentContainer = parentComponent;while (parent){if (parent.index != -1) {indexArr.push(parent.index);
            }
            else {break;
            }parent = parent.parentComponent;
        }indexArr.reverse();_indexStr = Std.string(indexArr);_indexStr = _indexStr.replace(",", "_");return _indexStr;
    }  // -------------------------------------------------------------------------------------  
}