package cadet2d.components.processes;

interface IDebugDrawProcess
{
    var trackCamera(get, set) : Bool;    
	var sprite(get, never) : Dynamic;
}