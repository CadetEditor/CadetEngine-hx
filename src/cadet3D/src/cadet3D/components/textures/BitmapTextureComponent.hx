// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.components.textures;

import cadet3d.components.textures.BitmapTexture;
import cadet3d.components.textures.Point;
import away3d.textures.BitmapTexture;
import cadet.util.BitmapDataUtil;
import cadet.util.NullBitmap;
import nme.display.BitmapData;
import nme.display.BitmapDataChannel;
import nme.geom.Point;

class BitmapTextureComponent extends AbstractTexture2DComponent
{
	public var alphaChannel(get, set) : String;
	public var bitmapData(get, set) : BitmapData;
	private var _bitmapTexture : BitmapTexture;
	private var _bitmapData : BitmapData;
	private var _bitmapDataSrc : BitmapData;
	private var _alphaChannel : String = "alpha";
	
	public function new()
	{
		super();
		_texture2D = _bitmapTexture = new BitmapTexture(NullBitmap.instance);
	}
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="100",editor="DropDownMenu",dataProvider="[RED,GREEN,BLUE,ALPHA]"))
	private function set_alphaChannel(value : String) : String
	{
		_alphaChannel = value;
		updateTexture();
		return value;
	}
	
	private function get_alphaChannel() : String
	{
		return _alphaChannel;
	}
	
	@:meta(Serializable(type="resource"))
	@:meta(Inspectable(priority="101",editor="ResourceItemEditor"))
	private function set_bitmapData(value : BitmapData) : BitmapData
	{
		_bitmapDataSrc = value;  
		//_bitmapTexture.bitmapData = BitmapDataUtil.makePowerOfTwo(value) || NullBitmap.instance;  
		_bitmapData = value;
		updateTexture();
		return value;
	}
	
	private function get_bitmapData() : BitmapData
	{
		return _bitmapData;
	}
	
	private function updateTexture() : Void
	{
		var channel : Int;
		if (_alphaChannel == "RED") 				channel = 1
		else if (_alphaChannel == "GREEN") 			channel = 2
		else if (_alphaChannel == "BLUE") 			channel = 4
		else if (_alphaChannel == "ALPHA") 			channel = 8;
		if (_bitmapData == null) return;
		var bmpd : BitmapData = _bitmapDataSrc;
		if (channel != 0) {
			bmpd = new BitmapData(_bitmapDataSrc.width, _bitmapDataSrc.height, true, 0xFFFFFFFF);
			bmpd.copyChannel(_bitmapDataSrc, bmpd.rect, new Point(), channel, BitmapDataChannel.ALPHA);
		}
		_bitmapTexture.bitmapData = BitmapDataUtil.makePowerOfTwo(bmpd) || NullBitmap.instance;
		_bitmapData = bmpd;invalidate("*");
	}
}