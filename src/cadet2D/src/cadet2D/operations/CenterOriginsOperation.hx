// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.operations;

import cadet2d.operations.IComponentContainer;
import cadet.components.geom.IGeometry;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.util.ComponentUtil;
import cadet2d.components.transforms.Transform2D;
import core.app.operations.UndoableCompoundOperation;

class CenterOriginsOperation extends UndoableCompoundOperation
{
	private var components : Array<Dynamic>;
	private var useCentroid : Bool;
	
	public function new(components : Array<Dynamic>, useCentroid : Bool = false)
    {
        super();
		this.components = components;
		this.useCentroid = useCentroid; 
		label = "Center Origin(s)";
		for (i in 0...components.length) {
			var component : IComponentContainer = components[i];
			var transform : Transform2D = try cast(ComponentUtil.getChildOfType(component, Transform2D), Transform2D) catch (e:Dynamic) null;
			if (transform == null) {
				continue;
            }
			var geometries : Array<IComponent> = ComponentUtil.getChildrenOfType(component, IGeometry);
			if (geometries.length == 0) {
				continue;
            }
			for (geometry in geometries) {
				addOperation(new CenterOriginOperation(geometry, transform, useCentroid));
            }
        }
    }
}