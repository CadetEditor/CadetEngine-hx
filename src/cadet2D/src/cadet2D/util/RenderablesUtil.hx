package cadet2d.util;

import cadet2d.util.IRenderable;
import cadet2d.components.skins.IRenderable;

class RenderablesUtil
{
	public static function sortSkinsById(renderableA : IRenderable, renderableB : IRenderable) : Int
	{
		var skinA_Ids : Array<Dynamic> = renderableA.indexStr.split("_");
		var skinB_Ids : Array<Dynamic> = renderableB.indexStr.split("_");
		var longest : Int = Math.max(skinA_Ids.length, skinB_Ids.length);
		var index : Int = 0;
		
		while (index < longest) {
			var idA : Float = index < (skinA_Ids.length) ? skinA_Ids[index] : -1;
			var idB : Float = index < (skinB_Ids.length) ? skinB_Ids[index] : -1;
			
			if (idA < idB) {
				return -1;
            } else if (idA > idB) {
				return 1;
            }
			index++;
        }
		
		return 0;
    }

    public function new()
    {
    }
}