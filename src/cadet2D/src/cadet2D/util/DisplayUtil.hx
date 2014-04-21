package cadet2d.util;

import cadet2d.util.DisplayObject;
import starling.display.DisplayObject;

class DisplayUtil
{
	public static function haveCommonParent
	(
	currentObject : DisplayObject, targetSpace : DisplayObject) : Bool
	{  
		// 1. find a common parent of this and the target space  
		var commonParent : DisplayObject = null;
		var sAncestors : Array<DisplayObject> = new Array<DisplayObject>();
		
		while (currentObject) { 
			sAncestors.push(currentObject);
			currentObject = currentObject.parent;
        }
		
		currentObject = targetSpace;
		
		while (currentObject && Lambda.indexOf(sAncestors, currentObject) == -1) 
			currentObject = currentObject.parent;
			
		sAncestors.length = 0;
		
		if (currentObject != null) {
			commonParent = currentObject;
			return true;
        }
		
		return false;
    }

    public function new()
    {
    }
}