// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet.core;

import cadet.core.ComponentContainer;
import cadet.core.ComponentEvent;
import cadet.core.DependencyManager;
import cadet.core.ICadetScene;
import cadet.core.IComponent;
import cadet.core.IInitialisableComponent;
import cadet.core.ISteppableComponent;
import cadet.core.PropertyChangeEvent;
import cadet.events.ComponentEvent;import core.app.managers.DependencyManager;import core.events.PropertyChangeEvent;class CadetScene extends ComponentContainer implements ICadetScene
{
    public var framerate(get, set) : Int;
    public var timeScale(get, set) : Float;
    public var dependencyManager(get, set) : DependencyManager;
    public var userData(get, set) : Dynamic;
    public var runMode(get, set) : Bool;
private var _framerate : Int = 60;private var _timeScale : Float = 1;private var _runMode : Bool = false;private var lastFrameTime : Int = Math.round(haxe.Timer.stamp() * 1000);private var steppableComponents : Array<IComponent>;private var initOnRunComponents : Array<IComponent>;private var _dependencyManager : DependencyManager;private var _userData : Dynamic;public function new()
    {
        super();_dependencyManager = new DependencyManager();name = "Scene";_scene = this;steppableComponents = new Array<IComponent>();initOnRunComponents = new Array<IComponent>();addEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler);
    }private function componentAddedToSceneHandler(event : ComponentEvent) : Void{var component : IComponent = event.component;var onAList : Bool = false;if (Std.is(component, ISteppableComponent)) {steppableComponents.push(component);onAList = true;
        }if (Std.is(component, IInitialisableComponent)) {initOnRunComponents.push(component);onAList = true;  // if scene already running, init the component  if (runMode) {cast((component), IInitialisableComponent).init();
            }
        }if (onAList) {component.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedHandler);
        }
    }private function componentRemovedHandler(event : ComponentEvent) : Void{var component : IComponent = event.component;var steppableIndex : Int = Lambda.indexOf(steppableComponents, component);var initOnRunIndex : Int = Lambda.indexOf(initOnRunComponents, component);if (steppableIndex != -1) {steppableComponents.splice(steppableIndex, 1);
        }if (initOnRunIndex != -1) {initOnRunComponents.splice(initOnRunIndex, 1);
        }component.removeEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedHandler);
    }public function step() : Void{if (!runMode) {for (iORComponent in initOnRunComponents){iORComponent.init();
            }runMode = true;
        }var timeStep : Float = 1 / _framerate;var currentTime : Int = Math.round(haxe.Timer.stamp() * 1000);var elapsed : Int = currentTime - lastFrameTime;if (elapsed < (timeStep * 1000)) {return;
        }var dt : Float = timeStep * timeScale;for (steppableComponent in steppableComponents){steppableComponent.step(dt);
        }validateNow();lastFrameTime = currentTime;
    }@:meta(Serializable())
@:meta(Inspectable(toolTip="This value should be set to match the framerate of SWF the scene will be playing within."))
private function set_Framerate(value : Int) : Int{_framerate = value;dispatchEvent(new PropertyChangeEvent("propertyChange_framerate", null, _framerate));
        return value;
    }private function get_Framerate() : Int{return _framerate;
    }@:meta(Serializable())
@:meta(Inspectable(toolTip="This value scales the amount of time elapsing per step of the Cadet Scene. Eg 0.5 = half speed."))
private function set_TimeScale(value : Float) : Float{_timeScale = value;dispatchEvent(new PropertyChangeEvent("propertyChange_timescale", null, _timeScale));
        return value;
    }private function get_TimeScale() : Float{return _timeScale;
    }override private function childAdded(child : IComponent, index : Int) : Void{super.childAdded(child, index);child.scene = this;
    }@:meta(Serializable())
private function set_DependencyManager(value : DependencyManager) : DependencyManager{_dependencyManager = value;
        return value;
    }private function get_DependencyManager() : DependencyManager{return _dependencyManager;
    }@:meta(Serializable(type="rawObject"))
private function set_UserData(value : Dynamic) : Dynamic{_userData = value;
        return value;
    }private function get_UserData() : Dynamic{return _userData;
    }  // runMode is set to "true" the first time the scene is "stepped" and all IInitialisableComponents are initialised.    // Certain Processes and Behaviours may require the scene to behave differently at edit time and runtime,    // for instance, a process might remove it's edit time Skins at runtime and generate them procedurally.    // The default value is false.  private function get_RunMode() : Bool{return _runMode;
    }private function set_RunMode(value : Bool) : Bool{_runMode = value;
        return value;
    }  // Allow the scene to re-initialise components  public function reset() : Void{_runMode = false;
    }
}