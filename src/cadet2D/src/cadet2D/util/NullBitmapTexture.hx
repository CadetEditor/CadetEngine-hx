package cadet2d.util;

import cadet2d.util.Bitmap;
import cadet2d.util.Texture;
import nme.display.Bitmap;import cadet.util.NullBitmap;import starling.textures.Texture;class NullBitmapTexture
{
    public static var instance(get, never) : Texture;
private static var _instance : Texture;private static function get_Instance() : Texture{if (_instance == null) {_instance = Texture.fromBitmap(new Bitmap(NullBitmap.instance), false);
        }return _instance;
    }

    public function new()
    {
    }
}