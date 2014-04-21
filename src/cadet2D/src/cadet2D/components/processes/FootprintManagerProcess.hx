// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet2d.components.processes;

import cadet2d.components.processes.FootprintManagerEvent;
import cadet2d.components.processes.IFootprint;
import cadet2d.components.behaviours.IFootprint;
import cadet.core.Component;
import cadet2d.events.FootprintManagerEvent;

@:meta(Event(type="cadet2D.events.FootprintManagerEvent",name="change"))
class FootprintManagerProcess extends Component
{
    public var gridSize(get, set) : Int;
	private var _gridSize : Int = 20;
	private var table : Dynamic;
	private var footprints : Array<Dynamic>;
	
	public function new()
    {
        super();
		name = "FootprintManagerProcess";
		footprints = [];
		table = { };
    }
	
	public function getFootprints() : Array<Dynamic>
	{
		return footprints.substring();
    }
	
	public function addFootprint(footprint : IFootprint) : Void
	{
		footprints.push(footprint);
		var changedIndices : Array<Dynamic> = [];
		for (x in 0...footprint.sizeX) {
			var globalX : Int = footprint.x + x;
			for (y in 0...footprint.sizeY) {
				if (footprint.values[x][y] == false) {
					continue;
                }
				var globalY : Int = footprint.y + y;
				var key : String = globalX + "_" + globalY;
				var cell : Array<Dynamic> = Reflect.field(table, key);
				if (cell == null) {
					cell = Reflect.setField(table, key, []);
                }
				if (Lambda.indexOf(cell, footprint) != -1) {
					continue;
                }
				cell.push(footprint);
				changedIndices.push([globalX, globalY]);
            }
        }
		if (changedIndices.length > 0) {
			dispatchEvent(new FootprintManagerEvent(FootprintManagerEvent.CHANGE, changedIndices));
        }
    }
	
	public function getFootprintsAt(x : Int, y : Int) : Array<Dynamic>
	{
		var key : String = x + "_" + y;
		var cell : Array<Dynamic> = Reflect.field(table, key);
		if (cell == null) return null;
		return cell.substring();
    }
	
	public function removeFootprint(footprint : IFootprint) : Void
	{
		var index : Int = Lambda.indexOf(footprints, footprint);
		if (index == -1) return;
		footprints.splice(index, 1);
		var changedIndices : Array<Dynamic> = [];
		for (x in 0...footprint.sizeX) {
			var globalX : Int = footprint.x + x;
			for (y in 0...footprint.sizeY) {
				if (footprint.values[x][y] == false) {
					continue;
                }
				var globalY : Int = footprint.y + y;
				var key : String = globalX + "_" + globalY;
				var cell : Array<Dynamic> = Reflect.field(table, key);
				cell.splice(Lambda.indexOf(cell, footprint), 1);
				if (cell.length == 0) {
					Reflect.setField(table, key, null);;
                }changedIndices.push([globalX, globalY]);
            }
        }
		
		if (changedIndices.length > 0) {
			dispatchEvent(new FootprintManagerEvent(FootprintManagerEvent.CHANGE, changedIndices));
        }
    }
	
	public function getOverlappingFootprints(footprint : IFootprint) : Array<Dynamic>
	{
		var overlappingFootprints : Array<Dynamic> = [];
		var L : Int = 0;
		for (x in 0...footprint.sizeX) {
			var globalX : Int = footprint.x + x;
			for (y in 0...footprint.sizeY) {
				if (footprint.values[x][y] == false) {
					continue;
                }
				var globalY : Int = footprint.y + y;
				var key : String = globalX + "_" + globalY;
				var cell : Array<Dynamic> = Reflect.field(table, key);
				if (cell == null) {
					continue;
                }
				for (cellFootprint in cell) {
					if (Lambda.indexOf(overlappingFootprints, cellFootprint) != -1) {
						continue;
                    }
					if (cellFootprint == footprint) {
						continue;
                    }
					overlappingFootprints[L++] = cellFootprint;
                }
            }
        }
		return overlappingFootprints;
    }
	
	@:meta(Serializer())
	@:meta(Inspectable())
	private function set_GridSize(value : Int) : Int
	{
		_gridSize = value;
        return value;
    }
	
	private function get_GridSize() : Int
	{
		return _gridSize;
    }
}