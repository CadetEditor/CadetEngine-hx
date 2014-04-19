// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.util;

import nme.display.BitmapData;

class NullBitmap
{
    public static var instance(get, never) : BitmapData;
	
	@:meta(Embed(source="NullBitmap.png"))
	private static var NullBitmap : Class<Dynamic>;
	private static var _instance : BitmapData;
	
	private static function get_Instance() : BitmapData
	{
		if (_instance == null) {
			_instance = Type.createInstance(NullBitmap, []).bitmapData;
        }
		return _instance;
    }

    public function new()
    {
    }
}