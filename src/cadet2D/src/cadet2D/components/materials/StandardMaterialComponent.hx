package cadet2d.components.materials;

import cadet2d.components.materials.ComponentContainer;
import cadet2d.components.materials.ComponentContainerEvent;
import cadet2d.components.materials.IComponent;
import cadet2d.components.materials.IComponentContainer;
import cadet2d.components.materials.IShaderComponent;
import cadet2d.components.materials.StandardMaterial;
import cadet2d.components.materials.Texture;
import cadet2d.components.materials.TextureComponent;
import cadet2d.components.materials.ValidationEvent;
import cadet.core.ComponentContainer;import cadet.core.IComponent;import cadet.core.IComponentContainer;import cadet.events.ComponentContainerEvent;import cadet.events.ValidationEvent;import cadet2d.components.shaders.IShaderComponent;import cadet2d.components.textures.TextureComponent;import starling.display.materials.IMaterial;import starling.display.materials.StandardMaterial;import starling.textures.Texture;class StandardMaterialComponent extends ComponentContainer implements IMaterialComponent
{
    public var vertexShader(get, set) : IShaderComponent;
    public var fragmentShader(get, set) : IShaderComponent;
    public var texturesContainer(get, set) : IComponentContainer;
    public var material(get, never) : IMaterial;
private inline var VALUES : String = "values";private inline var TEXTURES : String = "textures";private var _material : StandardMaterial;private var _vertexShader : IShaderComponent;private var _fragmentShader : IShaderComponent;private var _texturesContainer : IComponentContainer;private var _textures : Array<Texture>;private var _textureComps : Array<TextureComponent>;public function new(name : String = "StandardMaterialComponent")
    {super(name);_material = new StandardMaterial();texturesContainer = this;_textureComps = new Array<TextureComponent>();
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="50"))
private function set_VertexShader(value : IShaderComponent) : IShaderComponent{_vertexShader = value;invalidate(VALUES);
        return value;
    }private function get_VertexShader() : IShaderComponent{return _vertexShader;
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="51"))
private function set_FragmentShader(value : IShaderComponent) : IShaderComponent{_fragmentShader = value;invalidate(VALUES);
        return value;
    }private function get_FragmentShader() : IShaderComponent{return _fragmentShader;
    }@:meta(Serializable())
@:meta(Inspectable(editor="ComponentList",scope="scene",priority="52"))
private function set_TexturesContainer(value : IComponentContainer) : IComponentContainer{if (_texturesContainer != null) {_texturesContainer.removeEventListener(ComponentContainerEvent.CHILD_ADDED, childAddedHandler);
        }_texturesContainer = value;if (_texturesContainer != null) {_texturesContainer.addEventListener(ComponentContainerEvent.CHILD_ADDED, childAddedHandler);
        }invalidate(TEXTURES);
        return value;
    }private function get_TexturesContainer() : IComponentContainer{return _texturesContainer;
    }override public function validateNow() : Void{if (isInvalid(VALUES)) {validateValues();
        }if (isInvalid(TEXTURES)) {validateTextures();
        }super.validateNow();
    }private function validateValues() : Void{_material.vertexShader = (_vertexShader != null) ? _vertexShader.shader : null;_material.fragmentShader = (_fragmentShader != null) ? _fragmentShader.shader : null;
    }private function validateTextures() : Void{for (i in 0..._textureComps.length){var textureComp : TextureComponent = _textureComps[i];textureComp.removeEventListener(ValidationEvent.VALIDATED, textureValidatedHandler);
        }_textures = new Array<Texture>();_textureComps = new Array<TextureComponent>();if (_texturesContainer != null) {for (_texturesContainer.children.length){var childComp : IComponent = _texturesContainer.children[i];if (Std.is(childComp, TextureComponent)) {textureComp = cast((childComp), TextureComponent);textureComp.validateNow();textureComp.addEventListener(ValidationEvent.VALIDATED, textureValidatedHandler);if (textureComp.texture) {_textures.push(textureComp.texture);_textureComps.push(textureComp);
                    }
                }
            }
        }_material.textures = _textures;dispatchEvent(new ValidationEvent(ValidationEvent.VALIDATED, TEXTURES));
    }private function textureValidatedHandler(event : ValidationEvent) : Void{if (event.validationType == TextureComponent.TEXTURE) {invalidate(TEXTURES);
        }
    }private function childAddedHandler(event : ComponentContainerEvent) : Void{invalidate(TEXTURES);
    }  // Graphics.clear() disposes materials referenced on Graphic classes,    // So the material needs to be reconstructed on each frame.  private function get_Material() : IMaterial{validateValues();validateTextures();return _material;
    }
}