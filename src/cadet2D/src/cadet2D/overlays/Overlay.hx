package cadet2d.overlays;

import cadet2d.overlays.Shape;
import starling.display.Shape;class Overlay extends Shape
{
    public var invalidationTable(get, never) : Dynamic;
private var _invalidationTable : Dynamic;  //private var invalidationEvent		:InvalidationEvent;  public function new()
    {
        super();_invalidationTable = { };  //invalidationEvent = new InvalidationEvent( InvalidationEvent.INVALIDATE );  invalidate("*");
    }  // Invalidation methods  public function invalidate(invalidationType : String) : Void{Reflect.setField(_invalidationTable, invalidationType, true);
    }public function validateNow() : Void{validate();_invalidationTable = { };
    }private function validate() : Void{
    }public function isInvalid(type : String) : Bool{if (Reflect.field(_invalidationTable, "*"))             return true;if (type == "*") {for (val/* AS3HX WARNING could not determine type for var: val exp: EIdent(_invalidationTable) type: Dynamic */ in _invalidationTable){return true;
            }
        }return Reflect.field(_invalidationTable, type) == true;
    }private function get_InvalidationTable() : Dynamic{return _invalidationTable;
    }
}