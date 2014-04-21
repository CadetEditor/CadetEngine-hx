// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================    
// Inspectable Priority range 100-149  

package cadet2d.components.skins;

import cadet2d.components.skins.DisplayObjectContainer;
import cadet2d.components.skins.IRenderable;
import cadet2d.components.skins.Image;
import cadet2d.components.skins.Quad;
import cadet2d.components.skins.SkinEvent;
import cadet2d.components.skins.Texture;
import cadet2d.components.skins.TextureAtlasComponent;
import cadet2d.components.skins.TransformableSkin;
import cadet.events.ValidationEvent;
import cadet2d.components.textures.TextureAtlasComponent;
import cadet2d.components.textures.TextureComponent;
import cadet2d.events.SkinEvent;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;

class ImageSkin extends TransformableSkin
{
    public var textureAtlas(get, set) : TextureAtlasComponent;
    public var texturesPrefix(get, set) : String;
    public var texture(get, set) : TextureComponent;
    public var quad(get, never) : Quad;
	private static inline var TEXTURE : String = "texture";
	private var _texture : TextureComponent;
	private var _quad : Quad;
	private var _textureAtlas : TextureAtlasComponent;
	private var _texturesPrefix : String;
	private var _textureDirty : Bool;
	
	public function new(name : String = "ImageSkin")
    {
		super(name);
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="100"))
	private function set_TextureAtlas(value : TextureAtlasComponent) : TextureAtlasComponent
	{
		if (_textureAtlas != null) { 
			_textureAtlas.removeEventListener(ValidationEvent.INVALIDATE, invalidateAtlasHandler);
        }
		_textureAtlas = value;
		if (_textureAtlas != null) {
			_textureAtlas.addEventListener(ValidationEvent.INVALIDATE, invalidateAtlasHandler);
        }  
		// textureAtlas & texture are mutually exclusive values  
		if (value != null) _texture = null;
		invalidate(TEXTURE);
        return value;
    }
	
	private function get_TextureAtlas() : TextureAtlasComponent
	{
		return _textureAtlas;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(priority="101"))
	private function set_TexturesPrefix(value : String) : String
	{
		_texturesPrefix = value;
		invalidate(TEXTURE);
        return value;
    }
	
	private function get_TexturesPrefix() : String
	{
		return _texturesPrefix;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene",priority="102"))
	private function set_Texture(value : TextureComponent) : TextureComponent
	{
		_texture = value;  
		// textureAtlas & texture are mutually exclusive values  
		if (value != null) {
			_textureAtlas = null;_texturesPrefix = null;
        }
		
		invalidate(TEXTURE);
        return value;
    }
	
	private function get_Texture() : TextureComponent
	{
		return _texture;
    }
	
	override public function validateNow() : Void
	{
		if (_textureDirty) {
			invalidate(TEXTURE);
        }
		if (isInvalid(TEXTURE)) {
			validateTexture();
        }
		super.validateNow();
    }
	
	override private function validateDisplay() : Bool
	{
		if (_quad != null && (_quad.width != _width || _quad.height != _height)) {
			_quad.width = _width;
			_quad.height = _height;
			return true;
        }
		super.validateDisplay();return false;
    }
	
	private function getTextures() : Array<Texture>
	{
		var textures : Array<Texture> = new Array<Texture>();
		if (_texture != null && _texture.texture) {
			textures.push(_texture.texture);
        } else if (_textureAtlas != null && _textureAtlas.atlas && _texturesPrefix != null) {
			textures = _textureAtlas.atlas.getTextures(_texturesPrefix);
        }
		return textures;
    }
	
	private function validateTexture() : Void
	{  
		// Remove existing asset first  
		if (Std.is(displayObject, DisplayObjectContainer)) {
			var displayObjectContainer : DisplayObjectContainer = cast((displayObject), DisplayObjectContainer);
        }
		if (_quad != null && displayObjectContainer && displayObjectContainer.contains(_quad)) {
			displayObjectContainer.removeChild(_quad);
        }  
		// If textureAtlas and texture are null, quit out having removed the quad.  
		if (_textureAtlas == null && _texture == null) {
			return;
        }
		
		var textures : Array<Texture>;  
		// If a texture has been set, check whether it's been validated,    
		// if so, set textures Vector, if not, try again next time  
		if (_texture != null) { 
			if (_texture.texture) {
				textures = new Array<Texture>();
				textures.push(_texture.texture);
            } else {
				_textureDirty = true;
				return;
            }
        }
        // Else if there isn't a texture set and their is a textureAtlas set, but it's not been validated,
        // or if there's no texturesPrefix, try again next time
        else if ((_textureAtlas != null && !_textureAtlas.atlas) || _texturesPrefix == null) {
			_textureDirty = true;
			return;
        }
        // Else if there's both a textureAtlas and a texturesPrefix, set the textures Vector.
        // If the result of the above is no textures, quit out.
        else if (_textureAtlas != null) {
			textures = _textureAtlas.atlas.getTextures(_texturesPrefix);
        }
		
		if (textures == null || textures.length == 0) return;  
		//_quad = new Image(textures[0]);  
		_quad = createQuad(textures);
		if (displayObjectContainer) {
			displayObjectContainer.addChild(_quad);  
			// set default width and height  
			if (_width == 0) _width = _quad.width;
			if (_height == 0) _height = _quad.height;
        }
		_textureDirty = false;  
		// Useful when not using editor as validation is not immediate  
		dispatchEvent(new SkinEvent(SkinEvent.TEXTURE_VALIDATED));
    }
	
	private function createQuad(textures : Array<Texture>) : Quad
	{
		return new Image(textures[0]);
    }
	
	private function invalidateAtlasHandler(event : ValidationEvent) : Void
	{
		invalidate(TEXTURE);
    }
	
	override public function clone() : IRenderable
	{
		var newSkin : ImageSkin = new ImageSkin();
		newSkin.rotation = rotation;
		newSkin.scaleX = scaleX;
		newSkin.scaleY = scaleY;
		newSkin.texture = _texture;
		newSkin.textureAtlas = _textureAtlas;
		newSkin.texturesPrefix = _texturesPrefix;
		newSkin.touchable = _displayObject.touchable;
		newSkin.transform2D = _transform2D; 
		newSkin.x = x;
		newSkin.y = y;
		newSkin.width = _width;
		newSkin.height = _height;
		return newSkin;
    }
	
	private function get_Quad() : Quad
	{
		return _quad;
    }
}