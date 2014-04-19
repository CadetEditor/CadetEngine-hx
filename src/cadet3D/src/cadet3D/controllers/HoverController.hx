package cadet3d.controllers;

import cadet3d.controllers.Entity;
import cadet3d.controllers.LookAtController;
import cadet3d.controllers.ObjectContainer3D;
import cadet3d.controllers.Vector3D;
import away3d.Arcane;import away3d.containers.*;import away3d.controllers.LookAtController;import away3d.core.math.*;import away3d.entities.*;import nme.geom.Vector3D;  /**
	 * Extended camera used to hover round a specified target object.
	 * 
	 * @see	away3d.containers.View3D
	 */  class HoverController extends LookAtController
{
    public var steps(get, set) : Int;
    public var panAngle(get, set) : Float;
    public var currentPanAngle(get, set) : Float;
    public var tiltAngle(get, set) : Float;
    public var currentTiltAngle(get, set) : Float;
    public var distance(get, set) : Float;
    public var minPanAngle(get, set) : Float;
    public var maxPanAngle(get, set) : Float;
    public var minTiltAngle(get, set) : Float;
    public var maxTiltAngle(get, set) : Float;
    public var yFactor(get, set) : Float;
    public var wrapPanAngle(get, set) : Bool;
private var _currentPanAngle : Float = 0;private var _currentTiltAngle : Float = 90;private var _panAngle : Float = 0;private var _tiltAngle : Float = 90;private var _distance : Float = 1000;private var _minPanAngle : Float = -Infinity;private var _maxPanAngle : Float = Infinity;private var _minTiltAngle : Float = -90;private var _maxTiltAngle : Float = 90;private var _steps : Int = 8;private var _yFactor : Float = 2;private var _wrapPanAngle : Bool = false;  /**
		 * Fractional step taken each time the <code>hover()</code> method is called. Defaults to 8.
		 * 
		 * Affects the speed at which the <code>tiltAngle</code> and <code>panAngle</code> resolve to their targets.
		 * 
		 * @see	#tiltAngle
		 * @see	#panAngle
		 */  private function get_Steps() : Int{return _steps;
    }private function set_Steps(val : Int) : Int{val = ((val < 1)) ? 1 : val;if (_steps == val)             return;_steps = val;notifyUpdate();
        return val;
    }  /**
		 * Rotation of the camera in degrees around the y axis. Defaults to 0.
		 */  private function get_PanAngle() : Float{return _panAngle;
    }private function set_PanAngle(val : Float) : Float{val = Math.max(_minPanAngle, Math.min(_maxPanAngle, val));if (_panAngle == val)             return;_panAngle = val;notifyUpdate();
        return val;
    }  // Rob added for immediate updates  private function get_CurrentPanAngle() : Float{return _currentPanAngle;
    }private function set_CurrentPanAngle(value : Float) : Float{_panAngle = value;_currentPanAngle = value;notifyUpdate();
        return value;
    }  /**
		 * Elevation angle of the camera in degrees. Defaults to 90.
		 */  private function get_TiltAngle() : Float{return _tiltAngle;
    }private function set_TiltAngle(val : Float) : Float{val = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, val));if (_tiltAngle == val)             return;_tiltAngle = val;notifyUpdate();
        return val;
    }  // Rob added for immediate updates  private function get_CurrentTiltAngle() : Float{return _currentTiltAngle;
    }private function set_CurrentTiltAngle(value : Float) : Float{_tiltAngle = value;_currentTiltAngle = value;notifyUpdate();
        return value;
    }  /**
		 * Distance between the camera and the specified target. Defaults to 1000.
		 */  private function get_Distance() : Float{return _distance;
    }private function set_Distance(val : Float) : Float{if (_distance == val)             return;_distance = val;notifyUpdate();
        return val;
    }  /**
		 * Minimum bounds for the <code>panAngle</code>. Defaults to -Infinity.
		 * 
		 * @see	#panAngle
		 */  private function get_MinPanAngle() : Float{return _minPanAngle;
    }private function set_MinPanAngle(val : Float) : Float{if (_minPanAngle == val)             return;_minPanAngle = val;panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
        return val;
    }  /**
		 * Maximum bounds for the <code>panAngle</code>. Defaults to Infinity.
		 * 
		 * @see	#panAngle
		 */  private function get_MaxPanAngle() : Float{return _maxPanAngle;
    }private function set_MaxPanAngle(val : Float) : Float{if (_maxPanAngle == val)             return;_maxPanAngle = val;panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
        return val;
    }  /**
		 * Minimum bounds for the <code>tiltAngle</code>. Defaults to -90.
		 * 
		 * @see	#tiltAngle
		 */  private function get_MinTiltAngle() : Float{return _minTiltAngle;
    }private function set_MinTiltAngle(val : Float) : Float{if (_minTiltAngle == val)             return;_minTiltAngle = val;tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
        return val;
    }  /**
		 * Maximum bounds for the <code>tiltAngle</code>. Defaults to 90.
		 * 
		 * @see	#tiltAngle
		 */  private function get_MaxTiltAngle() : Float{return _maxTiltAngle;
    }private function set_MaxTiltAngle(val : Float) : Float{if (_maxTiltAngle == val)             return;_maxTiltAngle = val;tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
        return val;
    }  /**
		 * Fractional difference in distance between the horizontal camera orientation and vertical camera orientation. Defaults to 2.
		 * 
		 * @see	#distance
		 */  private function get_YFactor() : Float{return _yFactor;
    }private function set_YFactor(val : Float) : Float{if (_yFactor == val)             return;_yFactor = val;notifyUpdate();
        return val;
    }  /**
		 * Defines whether the value of the pan angle wraps when over 360 degrees or under 0 degrees. Defaults to false.
		 */  private function get_WrapPanAngle() : Bool{return _wrapPanAngle;
    }private function set_WrapPanAngle(val : Bool) : Bool{if (_wrapPanAngle == val)             return;_wrapPanAngle = val;notifyUpdate();
        return val;
    }  /**
		 * Creates a new <code>HoverController</code> object.
		 */  public function new(targetObject : Entity = null, lookAtObject : ObjectContainer3D = null, panAngle : Float = 0, tiltAngle : Float = 90, distance : Float = 1000, minTiltAngle : Float = -90, maxTiltAngle : Float = 90, minPanAngle : Float = NaN, maxPanAngle : Float = NaN, steps : Int = 8, yFactor : Float = 2, wrapPanAngle : Bool = false)
    {super(targetObject, lookAtObject);this.distance = distance;this.panAngle = panAngle;this.tiltAngle = tiltAngle;this.minPanAngle = minPanAngle || -Infinity;this.maxPanAngle = maxPanAngle || Infinity;this.minTiltAngle = minTiltAngle;this.maxTiltAngle = maxTiltAngle;this.steps = steps;this.yFactor = yFactor;this.wrapPanAngle = wrapPanAngle;  //values passed in contrustor are applied immediately  _currentPanAngle = _panAngle;_currentTiltAngle = _tiltAngle;autoUpdate = false;
    }  /**
		 * Updates the current tilt angle and pan angle values.
		 * 
		 * Values are calculated using the defined <code>tiltAngle</code>, <code>panAngle</code> and <code>steps</code> variables.
		 * 
		 * @see	#tiltAngle
		 * @see	#panAngle
		 * @see	#steps
		 */  override public function update(interpolate : Bool = true) : Void{if (_tiltAngle != _currentTiltAngle || _panAngle != _currentPanAngle) {notifyUpdate();if (_wrapPanAngle) {if (_panAngle < 0)                     _panAngle = (_panAngle % 360) + 360
                else _panAngle = _panAngle % 360;if (_panAngle - _currentPanAngle < -180)                     _currentPanAngle -= 360
                else if (_panAngle - _currentPanAngle > 180)                     _currentPanAngle += 360;
            }_currentTiltAngle += (_tiltAngle - _currentTiltAngle) / (steps + 1);_currentPanAngle += (_panAngle - _currentPanAngle) / (steps + 1);  //snap coords if angle differences are close  if ((Math.abs(tiltAngle - _currentTiltAngle) < 0.01) && (Math.abs(_panAngle - _currentPanAngle) < 0.01)) {_currentTiltAngle = _tiltAngle;_currentPanAngle = _panAngle;
            }
        }var pos : Vector3D = ((lookAtObject != null)) ? lookAtObject.position : ((lookAtPosition)) ? lookAtPosition : _origin;targetObject.x = pos.x + distance * Math.sin(_currentPanAngle * MathConsts.DEGREES_TO_RADIANS) * Math.cos(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS);targetObject.z = pos.z + distance * Math.cos(_currentPanAngle * MathConsts.DEGREES_TO_RADIANS) * Math.cos(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS);targetObject.y = pos.y + distance * Math.sin(_currentTiltAngle * MathConsts.DEGREES_TO_RADIANS) * yFactor;super.update();
    }
}