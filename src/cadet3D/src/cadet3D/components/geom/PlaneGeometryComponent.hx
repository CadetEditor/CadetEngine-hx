  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.geom;

import cadet3d.components.geom.PlaneGeometry;
import away3d.core.base.Geometry;import away3d.primitives.CubeGeometry;import away3d.primitives.PlaneGeometry;import cadet.core.Component;class PlaneGeometryComponent extends AbstractGeometryComponent
{
    public var width(get, set) : Float;
    public var height(get, set) : Float;
    public var segmentsW(get, set) : Float;
    public var segmentsH(get, set) : Float;
private var planeGeom : PlaneGeometry;public function new(width : Float = 100, height : Float = 100)
    {
        super();_geometry = planeGeom = new PlaneGeometry();this.width = width;this.height = height;
    }@:meta(Serializable())
@:meta(Inspectable(priority="100",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
private function get_Width() : Float{return planeGeom.width;
    }private function set_Width(value : Float) : Float{planeGeom.width = value;planeGeom.subGeometries;  // Trigger validatation  invalidate(GEOMETRY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="101",editor="NumberInput",min="1",max="9999",numDecimalPlaces="2"))
private function get_Height() : Float{return planeGeom.height;
    }private function set_Height(value : Float) : Float{planeGeom.height = value;planeGeom.subGeometries;  // Trigger validatation  invalidate(GEOMETRY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="102",editor="NumberInput",min="1",max="128",numDecimalPlaces="0"))
private function get_SegmentsW() : Float{return planeGeom.segmentsW;
    }private function set_SegmentsW(value : Float) : Float{planeGeom.segmentsW = value;planeGeom.subGeometries;  // Trigger validatation  invalidate(GEOMETRY);
        return value;
    }@:meta(Serializable())
@:meta(Inspectable(priority="103",editor="NumberInput",min="1",max="128",numDecimalPlaces="0"))
private function get_SegmentsH() : Float{return planeGeom.segmentsH;
    }private function set_SegmentsH(value : Float) : Float{planeGeom.segmentsH = value;planeGeom.subGeometries;  // Trigger validatation  invalidate(GEOMETRY);
        return value;
    }
}