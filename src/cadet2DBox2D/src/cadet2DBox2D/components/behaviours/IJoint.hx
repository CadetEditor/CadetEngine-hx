package cadet2dbox2d.components.behaviours;

import cadet2dbox2d.components.behaviours.IComponent;
import cadet.core.IComponent;
import cadet2dbox2d.components.processes.PhysicsProcess;

interface IJoint extends IComponent
{
    var physicsProcess(get, set) : PhysicsProcess;

}