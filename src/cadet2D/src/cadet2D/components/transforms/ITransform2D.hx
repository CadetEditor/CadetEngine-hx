package cadet2d.components.transforms;

import cadet2d.components.transforms.IComponent;
import cadet2d.components.transforms.Matrix;
import nme.geom.Matrix;import cadet.core.IComponent;interface ITransform2D extends IComponent
{
    var x(get, set) : Float;    var y(get, set) : Float;    var scaleX(get, set) : Float;    var scaleY(get, set) : Float;    var rotation(get, set) : Float;    var matrix(get, set) : Matrix;    var globalMatrix(get, never) : Matrix;    var parentTransform(get, set) : ITransform2D;

}