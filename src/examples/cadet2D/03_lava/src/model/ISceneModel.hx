package model;

import model.CadetScene;
import model.DisplayObject;
import nme.display.DisplayObject;import cadet.core.CadetScene;interface ISceneModel
{
    var cadetScene(never, set) : CadetScene;
function init(parent : DisplayObject) : Void;
}