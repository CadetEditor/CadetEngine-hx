package cadet.components.processes;

import cadet.components.processes.ComponentEvent;
import cadet.components.processes.IInitialisableComponent;
import cadet.components.processes.ISound;
import cadet.components.processes.SoundComponent;
import nme.media.SoundMixer;import cadet.components.sounds.ISound;import cadet.components.sounds.SoundComponent;import cadet.core.Component;import cadet.core.IComponent;import cadet.core.IInitialisableComponent;import cadet.events.ComponentEvent;import cadet.util.ComponentUtil;class SoundProcess extends Component implements IInitialisableComponent
{
    public var muted(get, set) : Bool;
    public var music(get, set) : SoundComponent;
private inline var SOUNDS : String = "sounds";private var _muted : Bool = false;private var _musicPlaying : Bool = false;private var _initialised : Bool = false;private var _music : SoundComponent;private var soundArray : Array<Dynamic>;public function new(name : String = "SoundProcess")
    {soundArray = new Array<Dynamic>();super(name);
    }override private function addedToScene() : Void{scene.addEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler);scene.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedFromSceneHandler);addSounds();
    }  //IInitialisableComponent  public function init() : Void{_initialised = true;invalidate(SOUNDS);
    }  // -------------------------------------------------------------------------------------    // INSPECTABLE API    // -------------------------------------------------------------------------------------  @:meta(Serializable())
@:meta(Inspectable(priority="50"))
private function set_Muted(value : Bool) : Bool{_muted = value;invalidate(SOUNDS);
        return value;
    }private function get_Muted() : Bool{return _muted;
    }@:meta(Serializable())
@:meta(Inspectable(priority="51",editor="ComponentList",scope="scene"))
private function set_Music(value : SoundComponent) : SoundComponent{_music = value;
        return value;
    }private function get_Music() : SoundComponent{return _music;
    }  // -------------------------------------------------------------------------------------  override public function validateNow() : Void{var soundsInvalid : Bool = false;if (isInvalid(SOUNDS)) {soundsInvalid = true;
        }super.validateNow();if (soundsInvalid) {validateSounds();
        }
    }private function validateSounds() : Void{if (!_initialised)             return;if (!_muted) {if (_music != null && !_musicPlaying) {_musicPlaying = _music.play();if (!_musicPlaying) {invalidate(SOUNDS);
                }
            }
        }
        else {if (_music != null && _musicPlaying) {_musicPlaying = false;_music.stop();
            }
        }
    }public function playSound(sound : ISound) : Void{if (muted)             return;if (sound == _music) {if (_musicPlaying)                 return
            else _musicPlaying = true;
        }sound.play();
    }public function stopSound(sound : ISound) : Void{sound.stop();if (sound == music) {_musicPlaying = false;
        }
    }private function addSounds() : Void{var allSounds : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, ISound, true);for (sound in allSounds){addSound(sound);
        }
    }public function stopAllSounds() : Void{for (sound in soundArray){stopSound(sound);
        }
    }override public function dispose() : Void{SoundMixer.stopAll();stopAllSounds();super.dispose();
    }private function componentAddedToSceneHandler(event : ComponentEvent) : Void{if (Std.is(event.component, ISound) == false)             return;addSound(cast((event.component), ISound));
    }private function componentRemovedFromSceneHandler(event : ComponentEvent) : Void{if (Std.is(event.component, ISound) == false)             return;removeSound(cast((event.component), ISound));
    }private function addSound(sound : ISound) : Void{var i : Int = Lambda.indexOf(soundArray, sound);if (i == -1)             soundArray.push(sound);
    }private function removeSound(sound : ISound) : Void{var i : Int = Lambda.indexOf(soundArray, sound);if (i != -1)             soundArray.splice(i, 1);
    }
}