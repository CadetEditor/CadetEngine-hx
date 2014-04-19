  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.textures;

import cadet2d.components.textures.Bitmap;
import cadet2d.components.textures.BitmapData;
import cadet2d.components.textures.Texture;
import cadet2d.components.textures.ValidationEvent;
import nme.display.Bitmap;import nme.display.BitmapData;import cadet.core.Component;import cadet.events.ValidationEvent;import starling.core.Starling;import starling.textures.Texture;class TextureComponent extends Component
{
    public var bitmapData(get, set) : BitmapData;
    public var texture(get, never) : Texture;
public static inline var TEXTURE : String = "texture";private var _bitmapData : BitmapData;private var _texture : Texture;public function new(name : String = "TextureComponent")
    {super(name);
    }@:meta(Serializable(type="resource"))
@:meta(Inspectable(editor="ResourceItemEditor"))
private function set_BitmapData(value : BitmapData) : BitmapData{if (value == null)             return;_bitmapData = value;invalidate(TEXTURE);
        return value;
    }private function get_BitmapData() : BitmapData{return _bitmapData;
    }private function get_Texture() : Texture{return _texture;
    }override public function validateNow() : Void{var textureValidated : Bool = true;if (isInvalid(TEXTURE)) {textureValidated = validateTexture();
        }super.validateNow();if (!textureValidated) {invalidate(TEXTURE);
        }
    }private function validateTexture() : Bool{if (_bitmapData != null && Starling.context) {  //trace("validateTexture");    //				if ( _texture ) {    //					_texture.dispose();    //					_texture = null;    //				}  _texture = Texture.fromBitmap(new Bitmap(_bitmapData), false);var event : ValidationEvent = new ValidationEvent(ValidationEvent.VALIDATED, TEXTURE);dispatchEvent(event);return true;
        }return false;
    }
}