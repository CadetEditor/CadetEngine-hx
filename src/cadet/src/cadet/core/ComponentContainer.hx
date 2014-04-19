  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.core;

import cadet.core.ArrayCollection;
import cadet.core.ArrayCollectionEvent;
import cadet.core.ComponentContainerEvent;
import cadet.core.IComponent;
import cadet.core.IComponentContainer;
import cadet.events.ComponentContainerEvent;
import cadet.events.ComponentEvent;
import cadet.util.ComponentReferenceUtil;
import core.data.ArrayCollection;
import core.events.ArrayCollectionChangeKind;
import core.events.ArrayCollectionEvent;

@:meta(Event(type="cadet.events.ComponentContainerEvent",name="childAdded"))
@:meta(Event(type="cadet.events.ComponentContainerEvent",name="childRemoved"))
/**
* @author Jonathan
* 
*/  

class ComponentContainer extends Component implements IComponent implements IComponentContainer
{
    public var children(get, set) : ArrayCollection;
	private var _children : ArrayCollection;
	private var childRemovedEvent : ComponentContainerEvent;
	private var childAddedEvent : ComponentContainerEvent;
	
	public function new(name : String = "ComponentContainer")
    {
		super(name);
		init();
    }
	
	private function init() : Void
	{
		children = new ArrayCollection();
		childRemovedEvent = new ComponentContainerEvent(ComponentContainerEvent.CHILD_REMOVED, null);
		childAddedEvent = new ComponentContainerEvent(ComponentContainerEvent.CHILD_ADDED, null);
    }
	
	private function addChildReference(type : Class<Dynamic>, property : String) : Void
	{
		ComponentReferenceUtil.addReferenceByType(this, type, this, property);
    }
	
	override public function dispose() : Void
	{
		var L : Int = _children.length;
		while (L > 0) {
			_children[0].dispose();
			_children.removeItemAt(0);
			L--;
        }
		previousChildSource = null;
		super.dispose();
    }
	
	override private function addedToScene() : Void
	{
		for (child/* AS3HX WARNING could not determine type for var: child exp: EIdent(_children) type: ArrayCollection */ in _children) {
			child.scene = _scene;
        }
    }
	
	override private function removedFromScene() : Void
	{
		for (child/* AS3HX WARNING could not determine type for var: child exp: EIdent(_children) type: ArrayCollection */ in _children) {
			child.scene = null;
        }
    }
	
	override public function validateNow() : Void
	{
		for (child/* AS3HX WARNING could not determine type for var: child exp: EIdent(_children) type: ArrayCollection */ in _children) {
			child.validateNow();
        }
		super.validateNow();
    }
	
	private var previousChildSource : Array<Dynamic> = [];
	private function childrenChangeHandler(event : ArrayCollectionEvent) : Void
	{
		var _sw0_ = (event.kind);        

        switch (_sw0_)
        {
			case ArrayCollectionChangeKind.ADD:
				childAdded(cast((event.item), IComponent), event.index);
			case ArrayCollectionChangeKind.REMOVE:
				childRemoved(cast((event.item), IComponent));
			case ArrayCollectionChangeKind.RESET:
				for (child/* AS3HX WARNING could not determine type for var: child exp: EField(EIdent(event),item) type: null */ in event.item) {
					childRemoved(child);
                }
				for (i in 0..._children.length) {
					child = _children[i];
					childAdded(child, i);
                }
        }
		
		previousChildSource = children.source.substring();
    }
	
	private function childAdded(child : IComponent, index : Int) : Void
	{
		child.index = index; 
		child.addEventListener(ComponentEvent.ADDED_TO_PARENT, childEventHandler);
		child.addEventListener(ComponentEvent.REMOVED_FROM_PARENT, childEventHandler);
		child.addEventListener(ComponentEvent.ADDED_TO_SCENE, childEventHandler);
		child.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, childEventHandler);
		child.parentComponent = this;
		child.scene = _scene;
		childAddedEvent.child = child;
		dispatchEvent(childAddedEvent);
    }
	
	private function childRemoved(child : IComponent) : Void
	{
		child.parentComponent = null;
		child.scene = null;
		child.removeEventListener(ComponentEvent.ADDED_TO_PARENT, childEventHandler);
		child.removeEventListener(ComponentEvent.REMOVED_FROM_PARENT, childEventHandler);
		child.removeEventListener(ComponentEvent.ADDED_TO_SCENE, childEventHandler);
		child.removeEventListener(ComponentEvent.REMOVED_FROM_SCENE, childEventHandler);
		childRemovedEvent.child = child;
		dispatchEvent(childRemovedEvent);
    }
	
	private function childEventHandler(event : ComponentEvent) : Void
	{
		dispatchEvent(event);
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_Children(value : ArrayCollection) : ArrayCollection
	{
		if (_children != null) {
			_children.source = [];
			_children.removeEventListener(ArrayCollectionEvent.CHANGE, childrenChangeHandler);
        }
		
		_children = value;
		
		if (_children != null) {
			_children.addEventListener(ArrayCollectionEvent.CHANGE, childrenChangeHandler);
			for (i in 0..._children.length) {
				var child : IComponent = _children[i];
				childAdded(child, i);
            }
        }
        return value;
    }
	
	private function get_Children() : ArrayCollection
	{
		return _children;
    }
}