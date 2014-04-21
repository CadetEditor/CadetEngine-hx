// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.geom;

import cadet2d.components.geom.ICollisionShape;
import cadet.core.CadetScene;
import cadet.core.Component;
import cadet.core.IComponentContainer;
import cadet.util.ComponentReferenceUtil;
import cadet.util.ComponentUtil;
import cadet2d.components.transforms.Transform2D;
import nme.events.Event;

@:meta(Event(type="cadet.events.CollisionEvent",name="collision"))
class CollisionShape extends Component implements ICollisionShape
{
    public var transform(get, never) : Transform2D;
	public var _transform : Transform2D;
	
	public function new()
    {
        super();
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(Transform2D, "_transform");
    }
	
	private function get_Transform() : Transform2D
	{
		return _transform;
    }
}