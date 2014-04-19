  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.serialize;

import away3d.core.base.Object3D;class TraceSerializer implements ISerializer
{public function new()
    {
    }public function export(object3d : Object3D) : String{SceneParser.parse(object3d);var containers : Array<Dynamic> = SceneParser.containers;var meshes : Array<Dynamic> = SceneParser.meshes;var wireframes : Array<Dynamic> = SceneParser.wireframes;var segmentSets : Array<Dynamic> = SceneParser.segmentSets;var segments : Array<Dynamic> = SceneParser.segments;var geometries : Array<Dynamic> = SceneParser.geometries;var materials : Array<Dynamic> = SceneParser.materials;var cameras : Array<Dynamic> = SceneParser.cameras;var lights : Array<Dynamic> = SceneParser.lights;var messages : Array<Dynamic> = SceneParser.messages;var numSegmentSets : Int = SceneParser.numSegmentSets;var str : String = "";  // Write messages  if (messages.length > 0) {for (i in 0...messages.length){var msg : String = messages[i];str += "// " + msg + "\n";
            }
        }str += writeObjects("Geometries", geometries);str += writeObjects("Materials", materials);str += writeObjects("Segments", segments);str += writeObjects("Containers", containers);str += writeObjects("Lights", lights);str += writeObjects("Cameras", cameras);str += writeObjects("Wireframes", wireframes);str += writeObjects("SegmentSets", segmentSets);str += writeObjects("Meshes", meshes);return str;
    }private function writeObjects(title : String, array : Array<Dynamic>) : String{var str : String = "";if (array.length > 0) {str += newLine("// " + title, 0);for (i in 0...array.length){var obj : SerializedObject = array[i];str += Std.string(obj);if (i != array.length - 1) {str += newLine();
                }
            }str += newLine();
        }return str;
    }private function newLine(value : String = "", numTabs : Int = 0) : String{var str : String = "\n";for (i in 0...numTabs){str += "\t";
        }str += value;return str;
    }
}