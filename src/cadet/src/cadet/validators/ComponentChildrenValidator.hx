package cadet.validators;

import cadet.validators.ArrayCollection;
import cadet.validators.CollectionValidator;
import cadet.validators.CollectionValidatorEvent;
import cadet.validators.IComponent;
import cadet.validators.IComponentContainer;
import cadet.core.IComponent;import cadet.core.IComponentContainer;import core.app.events.CollectionValidatorEvent;import core.app.util.ArrayUtil;import core.app.validators.CollectionValidator;import core.data.ArrayCollection;class ComponentChildrenValidator extends CollectionValidator
{public function new(collection : ArrayCollection, validType : Class<Dynamic>, min : Int = 1, max : Int = Int.MAX_VALUE)
    {super(collection, validType, min, max);
    }  /*		public function validate(componentType:Class, selection:ArrayCollection):Boolean
		{
			_validType = componentType;
			var validItems:Array = [];
			
			for each ( var component:IComponentContainer in selection ) {
				recurseItems(component, validItems);
			}
			
			if ( validItems.length > 0 ) {
				return true;
			}
			
			return false;
		}
		*/  override public function getValidItems() : Array<Dynamic>{if (!_collection)             return [];var validItems : Array<Dynamic> = [];  //ArrayUtil.filterByType(_collection.source, _validType);  for (i in 0..._collection.length){if (Std.is(_collection[i], _validType)) {validItems.push(_collection[i]);
            }if (Std.is(_collection[i], IComponentContainer)) {validItems = recurseItems(_collection[i], validItems);
            }
        }if (validItems.length < _min)             return [];if (validItems.length > _max)             return [];return validItems;
    }override private function updateState() : Void{var validItems : Array<Dynamic> = getValidItems();if (validItems.length == 0) {setState(false);
        }
        else {setState(true);
        }if (ArrayUtil.compare(oldCollection, validItems) == false) {oldCollection = validItems;dispatchEvent(new CollectionValidatorEvent(CollectionValidatorEvent.VALID_ITEMS_CHANGED, validItems));
        }
    }private function recurseItems(parent : IComponentContainer, validItems : Array<Dynamic>) : Array<Dynamic>{var newItems : Array<Dynamic> = ArrayUtil.filterByType(parent.children.source, _validType);if (newItems.length > 0) {validItems = validItems.concat(newItems);
        }for (i in 0...parent.children.length){var child : IComponent = parent.children[i];if (Std.is(child, IComponentContainer)) {recurseItems(cast((child), IComponentContainer), validItems);
            }
        }return validItems;
    }
}