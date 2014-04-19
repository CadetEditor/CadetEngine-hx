package cadet2d.components.shaders.vertex;

import cadet2d.components.shaders.vertex.AnimateUVVertexShader;
import cadet2d.components.shaders.vertex.Component;
import cadet2d.components.shaders.vertex.IShader;
import cadet2d.components.shaders.vertex.IShaderComponent;
import cadet.core.Component;import cadet2d.components.shaders.IShaderComponent;import starling.display.shaders.IShader;import starling.display.shaders.vertex.AnimateUVVertexShader;class AnimateUVVertexShaderComponent extends Component implements IShaderComponent
{
    public var uSpeed(get, set) : Float;
    public var vSpeed(get, set) : Float;
    public var shader(get, never) : IShader;
private inline var VALUES : String = "values";private var _shader : AnimateUVVertexShader;private var _uSpeed : Float;private var _vSpeed : Float;public function new(name : String = "AnimateUVVertexShaderComponent")
    {super(name);_shader = new AnimateUVVertexShader();
    }@:meta(Serializable())
@:meta(Inspectable(priority="50"))
private function get_USpeed() : Float{return _uSpeed;
    }private function set_USpeed(value : Float) : Float{_uSpeed = value;invalidate(VALUES);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="51"))
private function get_VSpeed() : Float{return _vSpeed;
    }private function set_VSpeed(value : Float) : Float{_vSpeed = value;invalidate(VALUES);
        return value;
    }override public function validateNow() : Void{if (isInvalid(VALUES)) {validateValues();
        }super.validateNow();
    }private function validateValues() : Void{_shader.uSpeed = _uSpeed;_shader.vSpeed = _vSpeed;
    }private function get_Shader() : IShader{return _shader;
    }
}