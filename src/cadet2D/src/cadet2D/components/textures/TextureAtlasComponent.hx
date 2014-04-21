package cadet2d.components.textures;

import cadet2d.components.textures.Component;
import cadet2d.components.textures.TextureAtlas;
import cadet2d.components.textures.TextureComponent;
import cadet.core.Component;
import starling.textures.TextureAtlas;

class TextureAtlasComponent extends Component
{
    public var xml(get, set) : FastXML;
    public var texture(get, set) : TextureComponent;
    public var atlas(get, never) : TextureAtlas;
	private var ATLAS : String = "atlas";
	private var _textureAtlas : TextureAtlas;
	private var _textureComponent : TextureComponent;
	private var _xml : FastXML;
	private var _atlas : TextureAtlas;
	private var _atlasDirty : Bool;
	
	public function new(name : String = "TextureAtlasComponent")
    {
		super(name);
    }
	
	@:meta(Serializable(type="resource"))
	@:meta(Inspectable(editor="ResourceItemEditor",extensions="[xml]"))
	private function set_Xml(value : FastXML) : FastXML
	{
		_xml = value;
		invalidate(ATLAS);
        return value;
    }
	
	private function get_Xml() : FastXML
	{
		return _xml;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable(editor="ComponentList",scope="scene"))
	private function set_Texture(value : TextureComponent) : TextureComponent
	{
		_textureComponent = value;
		invalidate(ATLAS);
        return value;
    }
	
	private function get_Texture() : TextureComponent
	{
		return _textureComponent;
    }
	
	override public function validateNow() : Void
	{
		if (_atlasDirty) {
			invalidate(ATLAS);
        }
		if (isInvalid(ATLAS)) {
			validateAtlas();
        }
		super.validateNow();
    }
	
	private function validateAtlas() : Void
	{
		if (_textureComponent == null || !_textureComponent.texture) {
			_atlasDirty = true;
			return;
        }
		_atlas = new TextureAtlas(_textureComponent.texture, _xml);
		_atlasDirty = false;
    }
	
	private function get_Atlas() : TextureAtlas
	{
		return _atlas;
    }
}