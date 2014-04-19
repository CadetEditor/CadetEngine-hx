  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.geom;

class VertexList extends Vertex
{public var next : VertexList;public function new(x : Float = 0, y : Float = 0)
    {super(x, y);next = this;
    }public function toArray() : Array<Dynamic>{var array : Array<Dynamic> = [];var v : VertexList = this;do{array.push(v.clone());v = v.next;
        }        while ((v != this));return array;
    }
}