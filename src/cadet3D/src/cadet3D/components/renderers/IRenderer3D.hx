package cadet3d.components.renderers;

import cadet3d.components.renderers.DisplayObjectContainer;
import cadet3d.components.renderers.IRenderer;
import nme.display.DisplayObjectContainer;import cadet.core.IRenderer;interface IRenderer3D extends IRenderer
{
function enable(parent : DisplayObjectContainer, depth : Int = -1) : Void;function disable(parent : DisplayObjectContainer) : Void;
}