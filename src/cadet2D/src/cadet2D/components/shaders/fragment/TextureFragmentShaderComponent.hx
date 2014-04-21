package cadet2d.components.shaders.fragment;

import cadet2d.components.shaders.fragment.Component;
import cadet2d.components.shaders.fragment.IShader;
import cadet2d.components.shaders.fragment.IShaderComponent;
import cadet2d.components.shaders.fragment.TextureFragmentShader;
import cadet.core.Component;
import cadet2d.components.shaders.IShaderComponent;
import starling.display.shaders.IShader;
import starling.display.shaders.fragment.TextureFragmentShader;

class TextureFragmentShaderComponent extends Component implements IShaderComponent
{
    public var shader(get, never) : IShader;
	private var _shader : IShader;
	
	public function new(name : String = "TextureFragmentShaderComponent")
    {
		super(name);
		_shader = new TextureFragmentShader();
    }
	
	private function get_Shader() : IShader
	{
		return _shader;
    }
}