package cadet2d.components.materials;

import cadet2d.components.materials.IEventDispatcher;
import cadet2d.components.materials.IMaterial;
import nme.events.IEventDispatcher;import starling.display.materials.IMaterial;interface IMaterialComponent extends IEventDispatcher
{
    var material(get, never) : IMaterial;

}