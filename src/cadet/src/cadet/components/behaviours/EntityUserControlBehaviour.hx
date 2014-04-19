// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.components.behaviours;

import cadet.components.behaviours.Component;
import cadet.components.behaviours.IEntityUserControlledBehaviour;
import cadet.components.behaviours.ISteppableComponent;
import cadet.components.behaviours.InputProcess;
import cadet.components.processes.InputProcess;
import cadet.core.Component;
import cadet.core.ISteppableComponent;

class EntityUserControlBehaviour extends Component implements ISteppableComponent
{
	@:meta(Serializable())
	@:meta(Inspectable())
	public var upMapping : String = "UP";
	@:meta(Serializable())
	@:meta(Inspectable())
	public var downMapping : String = "DOWN";
	@:meta(Serializable())
	@:meta(Inspectable())
	public var leftMapping : String = "LEFT";
	@:meta(Serializable())
	@:meta(Inspectable())
	public var rightMapping : String = "RIGHT";
	@:meta(Serializable())
	@:meta(Inspectable())
	public var spaceMapping : String = "SPACE";
	public var inputProcess : InputProcess;
	public var entityBehaviour : IEntityUserControlledBehaviour;
	
	public function new()
    {
        super();
		name = "EntityUserControlBehaviour";
    }
	
	override private function addedToScene() : Void
	{
		addSiblingReference(IEntityUserControlledBehaviour, "entityBehaviour");
		addSceneReference(InputProcess, "inputProcess");
    }
	
	public function step(dt : Float) : Void
	{
		if (entityBehaviour == null) return;
		if (inputProcess == null) return;
		if (inputProcess.isInputDown(upMapping)) {
			entityBehaviour.up();
        }
		if (inputProcess.isInputDown(downMapping)) {
			entityBehaviour.down();
        }
		if (inputProcess.isInputDown(leftMapping)) {
			entityBehaviour.left();
        }
		if (inputProcess.isInputDown(rightMapping)) {
			entityBehaviour.right();
        }
		if (inputProcess.isInputDown(spaceMapping)) {
			entityBehaviour.space();
        }
    }
}