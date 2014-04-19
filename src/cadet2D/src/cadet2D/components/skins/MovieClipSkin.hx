  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================    // Inspectable Priority range 100-149  package cadet2d.components.skins;

import cadet2d.components.skins.MovieClip;
import cadet2d.components.renderers.Renderer2D;import cadet2d.components.textures.TextureAtlasComponent;import starling.display.MovieClip;import starling.display.Quad;import starling.textures.Texture;class MovieClipSkin extends ImageSkin implements IAnimatable
{
    public var loop(get, set) : Bool;
    public var movieclip(get, never) : MovieClip;
    public var isAnimating(get, never) : Bool;
    public var previewAnimation(get, set) : Bool;
private static inline var LOOP : String = "loop";public var renderer : Renderer2D;private var _textureAtlas : TextureAtlasComponent;private var _loop : Bool;private var _fps : Int;  // "dirty" vars are for when display list changes are made but Starling isn't ready yet.    // These vars make sure it keeps on trying.  private var _loopDirty : Bool;private var _addedToJuggler : Bool;private var _previewAnimation : Bool;public function new(name : String = "MovieClipSkin")
    {super(name);
    }override private function addedToScene() : Void{addSceneReference(Renderer2D, "renderer");super.addedToScene();
    }@:meta(Serializable())
@:meta(Inspectable(priority="100"))
private function set_Loop(value : Bool) : Bool{_loop = value;invalidate(LOOP);
        return value;
    }private function get_Loop() : Bool{return _loop;
    }  /*		[Serializable][Inspectable( priority="101" )]
		public function set fps( value:uint ):void
		{
			_fps = value;
			
			invalidate( DISPLAY );
		}
		public function get fps():uint
		{
			return _fps;
		}*/  override public function validateNow() : Void{var isInvalidLoop : Bool = isInvalid(LOOP);  // clears the invalidationTable  super.validateNow();if (_loopDirty) {invalidate(LOOP);isInvalidLoop = true;
        }if (isInvalidLoop) {validateLoop();
        }
    }override private function createQuad(textures : Array<Texture>) : Quad{return new MovieClip(textures);
    }private function validateLoop() : Void{if (renderer == null || _quad == null) {_loopDirty = true;return;
        }var success : Bool;if (_loop) {success = addToJuggler();
        }
        else {success = removeFromJuggler();
        }if (success) {_loopDirty = false;
        }
    }private function get_Movieclip() : MovieClip{return cast((_quad), MovieClip);
    }override public function clone() : IRenderable{var newSkin : MovieClipSkin = new MovieClipSkin();newSkin.loop = _loop;newSkin.rotation = rotation;newSkin.scaleX = scaleX;newSkin.scaleY = scaleY;newSkin.texture = _texture;newSkin.textureAtlas = _textureAtlas;newSkin.texturesPrefix = _texturesPrefix;newSkin.touchable = _displayObject.touchable;newSkin.transform2D = _transform2D;newSkin.x = x;newSkin.y = y;newSkin.width = _width;newSkin.height = _height;return newSkin;
    }  // IAnimatable  public function addToJuggler() : Bool{if (!scene.runMode && !_previewAnimation)             return false  // only add if in run mode or if previewing  ;if (renderer == null || !renderer.initialised)             return false  //			if (_addedToJuggler) return true;  ;renderer.addToJuggler(movieclip);_addedToJuggler = true;return true;
    }public function removeFromJuggler() : Bool{if (renderer == null || !renderer.initialised)             return false  //    //			if (!_addedToJuggler) return true;  ;renderer.removeFromJuggler(movieclip);_addedToJuggler = false;return true;
    }private function get_IsAnimating() : Bool{return _addedToJuggler;
    }  // IAnimatable : Design time  private function set_PreviewAnimation(value : Bool) : Bool{_previewAnimation = value;
        return value;
    }private function get_PreviewAnimation() : Bool{return _previewAnimation;
    }
}