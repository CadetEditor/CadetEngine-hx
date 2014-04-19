package cadet.components.sounds;

import cadet.components.sounds.Component;
import cadet.components.sounds.Sound;
import cadet.components.sounds.SoundChannel;
import cadet.components.sounds.SoundTransform;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import cadet.core.Component;

class SoundComponent extends Component implements ISound
{
    public var asset(get, set) : Sound;
    public var startTime(get, set) : Float;
    public var loops(get, set) : Float;
	private var _asset : Sound;
	private var _channel : SoundChannel;
	private var _startTime : Float = 0;
	private var _loops : Int = 0;
	private var _soundTransform : SoundTransform = null;
	
	public function new(name : String = "SoundComponent")
    {
		super(name);
    }  
	
	// -------------------------------------------------------------------------------------    
	// INSPECTABLE API    
	// -------------------------------------------------------------------------------------  
	
	@:meta(Serializable(type="resource"))
	@:meta(Inspectable(editor="ResourceItemEditor",extensions="[mp3]"))
	private function set_Asset(value : Sound) : Sound
	{
		_asset = value;
        return value;
    }
	
	private function get_Asset() : Sound
	{
		return _asset;
    }
	
	public function play() : Bool
	{
		if (_asset == null) return false;
		_channel = _asset.play(_startTime, _loops, _soundTransform);
		return true;
    }
	
	public function stop() : Void
	{
		if (_channel != null) {
			_channel.stop();
        }
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_StartTime(value : Float) : Float
	{
		_startTime = value;
        return value;
    }
	
	private function get_StartTime() : Float
	{
		return _startTime;
    }
	
	@:meta(Serializable())
	@:meta(Inspectable())
	private function set_Loops(value : Float) : Float
	{
		_loops = value;
        return value;
    }
	
	private function get_Loops() : Float
	{
		return _loops;
    }  
	
	// -------------------------------------------------------------------------------------  
}