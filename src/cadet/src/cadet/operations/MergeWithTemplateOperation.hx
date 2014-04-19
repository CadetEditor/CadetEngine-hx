  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.operations;

import cadet.operations.AddItemOperation;
import cadet.operations.ChangePropertyOperation;
import cadet.operations.CloneOperation;
import cadet.operations.IComponentContainer;
import cadet.operations.RemoveItemOperation;
import nme.events.ErrorEvent;import nme.events.Event;import nme.events.EventDispatcher;import cadet.core.IComponent;import cadet.core.IComponentContainer;import cadet.util.ComponentUtil;import core.app.core.operations.IAsynchronousOperation;import core.app.core.operations.IUndoableOperation;import core.app.events.OperationProgressEvent;import core.app.operations.AddItemOperation;import core.app.operations.ChangePropertyOperation;import core.app.operations.CloneOperation;import core.app.operations.RemoveItemOperation;import core.app.operations.UndoableCompoundOperation;import core.app.util.AsynchronousUtil;import core.app.util.IntrospectionUtil;class MergeWithTemplateOperation extends EventDispatcher implements IUndoableOperation implements IAsynchronousOperation
{
    public var label(get, never) : String;
private var component : IComponent;private var template : IComponent;private var clone : Bool;private var operation : UndoableCompoundOperation;public function new(component : IComponent, template : IComponent, clone : Bool = false)
    {
        super();this.component = component;this.template = template;this.clone = clone;
    }public function execute() : Void{AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));return;if (clone) {var cloneOperation : CloneOperation = new CloneOperation(template);cloneOperation.addEventListener(OperationProgressEvent.PROGRESS, passThroughHandler);cloneOperation.addEventListener(ErrorEvent.ERROR, passThroughHandler);cloneOperation.addEventListener(Event.COMPLETE, cloneCompleteHandler);cloneOperation.execute();
        }
        else {performMerge();
        }
    }private function cloneCompleteHandler(event : Event) : Void{var cloneOperation : CloneOperation = cast((event.target), CloneOperation);template = cast((cloneOperation.getResult()), IComponent);performMerge();
    }private function passThroughHandler(event : Event) : Void{dispatchEvent(event.clone());
    }private function performMerge() : Void{var parent : IComponentContainer = component.parentComponent;operation = new UndoableCompoundOperation();var index : Int = parent.children.getItemIndex(component);operation.addOperation(new RemoveItemOperation(component, parent.children));operation.addOperation(new AddItemOperation(template, parent.children, index));operation.addOperation(new ChangePropertyOperation(template, "templateID", component.templateID));operation.addOperation(new ChangePropertyOperation(template, "exportTemplateID", null));if (Std.is(template, IComponentContainer) && Std.is(component, IComponentContainer)) {var templateAsContainer : IComponentContainer = cast((template), IComponentContainer);var componentAsContainer : IComponentContainer = cast((component), IComponentContainer);  // Now loop through the new component's children and handle any marked with [Cadet( inheritFromTemplate='false' )]  for (i in 0...templateAsContainer.children.length){var child : IComponent = templateAsContainer.children[i];var inheritFromTemplateValue : String = IntrospectionUtil.getMetadataByNameAndKey(child, "Cadet", "inheritFromTemplate");if (inheritFromTemplateValue == null)                     {i++;continue;
                };if (inheritFromTemplateValue != "false")                     {i++;continue;
                };var existingChild : IComponent = ComponentUtil.getChildByName(componentAsContainer, child.name);if (existingChild == null)                     {i++;continue;
                };templateAsContainer.children.removeItem(child);templateAsContainer.children.addItemAt(existingChild, i);
            }
        }operation.execute();AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
    }public function undo() : Void{operation.undo();AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
    }private function get_Label() : String{return "Merge with template";
    }
}