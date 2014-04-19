package cadet2d.events;

import nme.events.Event;class SkinEvent extends Event
{public static inline var TEXTURE_VALIDATED : String = "textureValidated";public function new(type : String, bubbles : Bool = false, cancelable : Bool = false)
    {super(type, bubbles, cancelable);
    }
}