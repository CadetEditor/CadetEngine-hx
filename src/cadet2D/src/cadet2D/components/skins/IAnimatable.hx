package cadet2d.components.skins;

import cadet2d.components.skins.IRenderable;

interface IAnimatable extends IRenderable
{
    var previewAnimation(get, never) : Bool;
	function addToJuggler() : Bool;
}