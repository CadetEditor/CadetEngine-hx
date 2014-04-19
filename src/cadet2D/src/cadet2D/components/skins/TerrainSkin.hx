  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.skins;

import cadet2d.components.skins.TerrainGeometry;
import nme.display.BitmapData;import nme.geom.Matrix;import cadet.events.ValidationEvent;import cadet2d.components.geom.TerrainGeometry;import cadet2d.components.textures.TextureComponent;import cadet2d.geom.Vertex;import cadet2d.util.VertexUtil;import core.app.datastructures.ObjectPool;import starling.core.Starling;import starling.display.Graphics;import starling.display.Shape;class TerrainSkin extends AbstractSkin2D
{
    public var fillTexture(get, set) : TextureComponent;
    public var surfaceTexture(get, set) : TextureComponent;
    public var surfaceThickness(get, set) : Float;
    public var terrainGeometry(get, set) : TerrainGeometry;
  // Invalidation types  public static inline var ALL_BUCKETS : String = "allBuckets";public static inline var SOME_BUCKETS : String = "someBuckets";  // Sibling References  private var _terrainGeometry : TerrainGeometry;  // Styles    //protected var _surfaceBitmap		:BitmapData;  private var _surfaceThickness : Int = 20;  //protected var _fillBitmap			:BitmapData;  private var _surfaceTexture : TextureComponent;private var _fillTexture : TextureComponent;  //  private var invalidatedBuckets : Dynamic;private var shapes : Dynamic;private static var m : Matrix = new Matrix();private var _shape : Shape;public function new(name : String = "TerrainSkin")
    {super(name);_displayObject = new Shape();_shape = cast((_displayObject), Shape);init();
    }private function init() : Void{while (_shape.numChildren > 0){_shape.removeChildAt(0);
        }shapes = { };invalidatedBuckets = { };
    }override public function dispose() : Void{super.dispose();init();
    }override private function addedToScene() : Void{super.addedToScene();addSiblingReference(TerrainGeometry, "terrainGeometry");
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="100"))
private function set_FillTexture(value : TextureComponent) : TextureComponent{if (_fillTexture != null) {_fillTexture.removeEventListener(ValidationEvent.VALIDATED, fillTextureValidatedHandler);
        }_fillTexture = value;if (_fillTexture != null) {_fillTexture.addEventListener(ValidationEvent.VALIDATED, fillTextureValidatedHandler);
        }invalidate(ALL_BUCKETS);invalidate(DISPLAY);
        return value;
    }private function get_FillTexture() : TextureComponent{return _fillTexture;
    }private function fillTextureValidatedHandler(event : ValidationEvent) : Void{invalidate(ALL_BUCKETS);invalidate(DISPLAY);
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="101"))
private function set_SurfaceTexture(value : TextureComponent) : TextureComponent{if (_surfaceTexture != null) {_surfaceTexture.removeEventListener(ValidationEvent.VALIDATED, surfaceTextureValidatedHandler);
        }_surfaceTexture = value;if (_surfaceTexture != null) {_surfaceTexture.addEventListener(ValidationEvent.VALIDATED, surfaceTextureValidatedHandler);
        }invalidate(ALL_BUCKETS);invalidate(DISPLAY);
        return value;
    }private function get_SurfaceTexture() : TextureComponent{return _surfaceTexture;
    }private function surfaceTextureValidatedHandler(event : ValidationEvent) : Void{invalidate(ALL_BUCKETS);invalidate(DISPLAY);
    }  /*				
		[Serializable( type="resource" )][Inspectable( editor="ResourceItemEditor" )]
		public function set fillBitmap( value:BitmapData ):void
		{
			_fillBitmap = value;
			invalidate( ALL_BUCKETS );
			invalidate( DISPLAY );
		}
		public function get fillBitmap():BitmapData { return _fillBitmap; }
		
		[Serializable( type="resource" )][Inspectable( editor="ResourceItemEditor" )]
		public function set surfaceBitmap( value:BitmapData ):void
		{
			_surfaceBitmap = value;
			invalidate( ALL_BUCKETS );
			invalidate( DISPLAY );
		}
		public function get surfaceBitmap():BitmapData { return _surfaceBitmap; }
		*/  @:meta(Serializable())
@:meta(Inspectable(editor="NumericStepper",min="1",max="100",stepSize="1",priority="102"))
private function set_SurfaceThickness(value : Float) : Float{_surfaceThickness = value;invalidate(ALL_BUCKETS);invalidate(DISPLAY);
        return value;
    }private function get_SurfaceThickness() : Float{return _surfaceThickness;
    }private function set_TerrainGeometry(value : TerrainGeometry) : TerrainGeometry{if (_terrainGeometry != null) {_terrainGeometry.removeEventListener(ValidationEvent.INVALIDATE, invalidateTerrainHandler);
        }_terrainGeometry = value;if (_terrainGeometry != null) {_terrainGeometry.addEventListener(ValidationEvent.INVALIDATE, invalidateTerrainHandler);
        }invalidate(ALL_BUCKETS);invalidate(DISPLAY);
        return value;
    }private function get_TerrainGeometry() : TerrainGeometry{return _terrainGeometry;
    }private function invalidateTerrainHandler(event : ValidationEvent) : Void{if (event.validationType == TerrainGeometry.ALL_BUCKETS) {invalidate(ALL_BUCKETS);invalidate(DISPLAY);
        }
        else if (event.validationType == TerrainGeometry.SOME_BUCKETS) {invalidate(SOME_BUCKETS);invalidate(DISPLAY);
        }
    }override public function validateNow() : Void{if (Starling.current) {if (isInvalid(ALL_BUCKETS)) {validateAllBuckets();
            }if (isInvalid(SOME_BUCKETS)) {validateSomeBuckets();
            }
        }super.validateNow();  // validateDisplay will have failed in this instance  if (!Starling.current) {invalidate(ALL_BUCKETS);
        }
    }private function validateAllBuckets() : Void{if (_terrainGeometry == null)             return;invalidatedBuckets = { };var numBuckets : Int = Math.ceil(_terrainGeometry.numSamples / _terrainGeometry.bucketSize);for (i in 0...numBuckets){invalidatedBuckets[i] = true;
        }for (shape/* AS3HX WARNING could not determine type for var: shape exp: EIdent(shapes) type: Dynamic */ in shapes){_shape.removeChild(shape);
        }shapes = { };invalidate(SOME_BUCKETS);
    }private function validateSomeBuckets() : Void{if (_terrainGeometry == null)             return;var bucketIndex : String;for (bucketIndex in Reflect.fields(invalidatedBuckets)){validateBucket(as3hx.Compat.parseInt(bucketIndex));
        }var terrainInvalidatedBuckets : Dynamic = _terrainGeometry.invalidatedBuckets;for (bucketIndex in Reflect.fields(terrainInvalidatedBuckets)){if (Reflect.field(invalidatedBuckets, bucketIndex))                 continue;validateBucket(as3hx.Compat.parseInt(bucketIndex));
        }invalidatedBuckets = { };
    }private function validateBucket(index : Int) : Void{var shape : Shape = shapes[index];if (shape == null) {shape = shapes[index] = ObjectPool.getInstance(Shape);_shape.addChild(shape);
        }var samples : Array<Dynamic> = _terrainGeometry.samples;var sampleWidth : Float = _terrainGeometry.sampleWidth;var firstSampleIndex : Int = index * _terrainGeometry.bucketSize;var lastSampleIndex : Int = Math.min(firstSampleIndex + _terrainGeometry.bucketSize, samples.length - 1);var length : Int = lastSampleIndex - firstSampleIndex;shape.x = as3hx.Compat.parseInt(firstSampleIndex * sampleWidth);var graphics : Graphics = shape.graphics;graphics.clear();  //if ( _fillBitmap )  if (_fillTexture != null) {m.identity();m.tx = as3hx.Compat.parseInt(-shape.x % _fillTexture.texture.width);  //m.tx = int(-shape.x % _fillBitmap.width);    //graphics.beginBitmapFill(_fillBitmap, m);  graphics.beginTextureFill(_fillTexture.texture, m);
        }
        else {graphics.lineStyle(1, 0xFFFFFF, 0.7);
        }var vertices : Array<Dynamic> = [];graphics.moveTo(0, 0);for (i in 0...length + 1){var sample : Float = samples[firstSampleIndex + i];graphics.lineTo(as3hx.Compat.parseInt(i * sampleWidth), -sample);vertices[i] = new Vertex(as3hx.Compat.parseInt(i * sampleWidth), -sample);
        }graphics.lineTo(as3hx.Compat.parseInt((i - 1) * sampleWidth), 0);graphics.endFill();  //if ( !_surfaceBitmap ) return;  if (_surfaceTexture == null)             return;var strip : Array<Dynamic> = VertexUtil.getPolygonStrip(vertices, _surfaceThickness, 0);for (length){sample = samples[firstSampleIndex + i];var stripShape : Array<Dynamic> = strip[i];var dx : Float = stripShape[1].x - stripShape[0].x;var dy : Float = stripShape[1].y - stripShape[0].y;var d : Float = Math.sqrt(dx * dx + dy * dy);dx /= d;dy /= d;var angle : Float = Math.PI * 0.5 - Math.atan2(dx, dy);m.identity();  //				m.translate(-shape.x % _surfaceBitmap.width,0);    //				m.scale(1, _surfaceThickness/_surfaceBitmap.height);    //				m.rotate(angle);    //				m.translate(stripShape[0].x, stripShape[0].y);    //				graphics.beginBitmapFill(_surfaceBitmap, m);  m.translate(-shape.x % _surfaceTexture.texture.width, 0);m.scale(1, _surfaceThickness / _surfaceTexture.texture.height);m.rotate(angle);m.translate(stripShape[0].x, stripShape[0].y);graphics.beginTextureFill(_surfaceTexture.texture, m);graphics.moveTo(stripShape[0].x, stripShape[0].y);graphics.lineTo(stripShape[1].x, stripShape[1].y);graphics.lineTo(stripShape[2].x, stripShape[2].y);graphics.lineTo(stripShape[3].x, stripShape[3].y);graphics.lineTo(stripShape[0].x, stripShape[0].y);graphics.endFill();
        }
    }
}