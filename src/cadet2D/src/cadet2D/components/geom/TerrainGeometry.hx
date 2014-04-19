  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.geom;

import cadet2d.components.geom.ArrayCollection;
import cadet2d.geom.Vertex;import cadet2d.util.VertexUtil;import core.data.ArrayCollection;import core.app.datastructures.ObjectPool;class TerrainGeometry extends CompoundGeometry
{
    public var buckets(get, never) : Array<Dynamic>;
    public var invalidatedBuckets(get, never) : Dynamic;
    public var samples(get, set) : Array<Dynamic>;
    public var serializedSamples(get, set) : String;
    public var sampleWidth(get, set) : Int;
    public var numSamples(get, set) : Int;
    public var bucketSize(get, set) : Int;
  // Invalidation Types  public static inline var GEOMETRY : String = "geometry";public static inline var SAMPLES : String = "samples";public static inline var ALL_BUCKETS : String = "allBuckets";public static inline var SOME_BUCKETS : String = "someBuckets";private var _sampleWidth : Int;private var _numSamples : Int;private var _bucketSize : Int;private var _samples : Array<Dynamic>;private var _buckets : Array<Dynamic>;private var _invalidatedBuckets : Dynamic;public function new()
    {
        super();init();
    }private function init() : Void{name = "TerrainGeometry";sampleWidth = 80;numSamples = 10;bucketSize = 10;_buckets = [];_invalidatedBuckets = { };_samples = [];
    }override public function dispose() : Void{super.dispose();init();
    }private function get_Buckets() : Array<Dynamic>{return _buckets;
    }private function get_InvalidatedBuckets() : Dynamic{return _invalidatedBuckets;
    }private function set_Samples(value : Array<Dynamic>) : Array<Dynamic>{_samples = value;invalidate(ALL_BUCKETS);
        return value;
    }private function get_Samples() : Array<Dynamic>{return _samples;
    }@:meta(Serializable(alias="samples"))
private function set_SerializedSamples(value : String) : String{var split : Array<Dynamic> = value.split(",");samples = [];var L : Int = split.length;for (i in 0...L){_samples[i] = as3hx.Compat.parseInt(split[i]);
        }
        return value;
    }private function get_SerializedSamples() : String{return Std.string(_samples);
    }@:meta(Serializable())
@:meta(Inspectable(editor="NumericStepper",min="1",max="100",stepSize="1"))
private function set_SampleWidth(value : Int) : Int{_sampleWidth = value;invalidate(ALL_BUCKETS);
        return value;
    }private function get_SampleWidth() : Int{return _sampleWidth;
    }@:meta(Serializable())
@:meta(Inspectable(editor="NumericStepper",min="1",max="99999999",stepSize="1"))
private function set_NumSamples(value : Int) : Int{_numSamples = value;invalidate(ALL_BUCKETS);invalidate(SAMPLES);
        return value;
    }private function get_NumSamples() : Int{return _numSamples;
    }@:meta(Serializable())
@:meta(Inspectable(editor="NumericStepper",min="1",max="1000",stepSize="1"))
private function set_BucketSize(value : Int) : Int{_bucketSize = value;invalidate(ALL_BUCKETS);
        return value;
    }private function get_BucketSize() : Int{return _bucketSize;
    }public function setHeight(index : Int, value : Float) : Void{index = index < (0) ? 0 : index;value = value < (0) ? 0 : value;if (index >= _numSamples) {numSamples = (index + 1);validateNow();
        }_samples[index] = value;  // Determine which bucket(s) have been invalidated.    // Usually only one bucket will be invalidated, but its    // possible that 2 have, if a sample on the edge between    // 2 buckets has been changed.  var bucketIndex : Int = index / _bucketSize;_invalidatedBuckets[bucketIndex] = true;if (bucketIndex > 0 && index % _bucketSize == 0) {_invalidatedBuckets[bucketIndex - 1] = true;
        }invalidate(SOME_BUCKETS);
    }override public function validateNow() : Void{if (isInvalid(SAMPLES)) {validateSamples();
        }if (isInvalid(ALL_BUCKETS)) {validateAllBuckets();
        }if (isInvalid(SOME_BUCKETS)) {validateSomeBuckets();
        }super.validateNow();
    }private function validateAllBuckets() : Void{for (bucket in _buckets){for (polygon/* AS3HX WARNING could not determine type for var: polygon exp: EIdent(bucket) type: Dynamic */ in bucket){ObjectPool.returnInstances(polygon.vertices, true);ObjectPool.returnInstance(polygon, PolygonGeometry);children.removeItem(polygon);polygon.dispose();
            }
        }_buckets = [];var numBuckets : Int = Math.ceil((_numSamples / _bucketSize));for (i in 0...numBuckets){_invalidatedBuckets[i] = true;_buckets[i] == [];
        }invalidate(SOME_BUCKETS);
    }private function validateSomeBuckets() : Void{for (bucketIndex in Reflect.fields(_invalidatedBuckets)){validateBucket(as3hx.Compat.parseInt(bucketIndex));
        }_invalidatedBuckets = { };
    }private function validateBucket(bucketIndex : Int) : Void{var bucket : Array<Dynamic> = _buckets[bucketIndex];for (polygon in bucket){ObjectPool.returnInstances(polygon.vertices, true);ObjectPool.returnInstance(polygon, PolygonGeometry);children.removeItem(polygon);polygon.dispose();
        }bucket = _buckets[bucketIndex] = [];var firstSampleIndex : Int = bucketIndex * _bucketSize;var lastSampleIndex : Int = Math.min(firstSampleIndex + _bucketSize, _samples.length - 1);var lowestPoint : Float = Float.POSITIVE_INFINITY;for (i in firstSampleIndex...lastSampleIndex + 1){var sample : Float = _samples[i];if (sample < lowestPoint) {lowestPoint = sample;
            }
        }var left : Float = firstSampleIndex * _sampleWidth;var right : Float = lastSampleIndex * _sampleWidth;if (lowestPoint != 0) {var baseRect : PolygonGeometry = ObjectPool.getInstance(PolygonGeometry);baseRect.vertices = ObjectPool.getInstances(Vertex, 4);baseRect.vertices[0].setValues(left, -lowestPoint);baseRect.vertices[1].setValues(right, -lowestPoint);baseRect.vertices[2].setValues(right, 0);baseRect.vertices[3].setValues(left, 0);bucket.push(baseRect);children.addItem(baseRect);
        }var prevVertex : Vertex;polygon = ObjectPool.getInstance(PolygonGeometry);for (lastSampleIndex + 1){sample = _samples[i];var vertex : Vertex = ObjectPool.getInstance(Vertex);vertex.setValues(i * _sampleWidth, -sample);if (vertex.y == -lowestPoint) {if (polygon.vertices.length > 0 && polygon.vertices[polygon.vertices.length - 1].y != -lowestPoint) {polygon.vertices.push(vertex.clone());finishShape(polygon, lowestPoint);bucket.push(polygon);children.addItem(polygon);polygon = ObjectPool.getInstance(PolygonGeometry);polygon.vertices.push(vertex.clone());
                }
                else {polygon.vertices = [vertex.clone()];
                }
            }
            else if (i == lastSampleIndex) {if (polygon.vertices.length > 0 && polygon.vertices[polygon.vertices.length - 1].y != -lowestPoint) {polygon.vertices.push(vertex.clone());finishShape(polygon, lowestPoint);bucket.push(polygon);children.addItem(polygon);
                }
            }
            else if (prevVertex != null) {var nextSample : Float = _samples[i + 1];var nextVertex : Vertex = ObjectPool.getInstance(Vertex);nextVertex.setValues((i + 1) * _sampleWidth, -nextSample);if (vertex.y == prevVertex.y && nextVertex.y == vertex.y) {prevVertex = vertex.clone();{i++;continue;
                    }
                }polygon.vertices.push(vertex.clone());if (VertexUtil.isLeft(prevVertex, vertex, nextVertex.x, nextVertex.y)) {if (polygon.vertices.length <= 1)                         {i++;continue;
                    };finishShape(polygon, lowestPoint);bucket.push(polygon);children.addItem(polygon);polygon = ObjectPool.getInstance(PolygonGeometry);polygon.vertices = [vertex.clone()];
                }  //ObjectPool.returnInstance(nextVertex, Vertex);  
            }
            else {polygon.vertices.push(vertex.clone());
            }prevVertex = vertex.clone();
        }
    }private function finishShape(polygon : PolygonGeometry, y : Float) : Void{var firstVertex : Vertex = polygon.vertices[0];var lastVertex : Vertex = polygon.vertices[polygon.vertices.length - 1];var v : Vertex;if (lastVertex.y != -y) {v = ObjectPool.getInstance(Vertex);v.setValues(lastVertex.x, -y);polygon.vertices.push(v);
        }if (firstVertex.y != -y) {v = ObjectPool.getInstance(Vertex);v.setValues(firstVertex.x, -y);polygon.vertices.push(v);
        }
    }private function validateSamples() : Void{var diff : Int = _numSamples - _samples.length;  // Need to expand vertices array  if (diff > 0) {for (i in 0...diff){_samples.push(0);
            }
        }
        else if (diff < 0) {diff *= -1;for (diff){var index : Int = (_samples.length - 1) - diff;_samples.length--;
            }
        }
    }  // Override the get/set children method, and override the [Serializable] metadata.    // Because this Component is a CompoundGeometry, and all its children are derived from the sample    // data, there's no need to serialize all the generated polygon data too, as it can be regenerated    // during validation.  @:meta(Serializable(inherit="false"))
override private function set_Children(value : ArrayCollection) : ArrayCollection{super.children = value;
        return value;
    }override private function get_Children() : ArrayCollection{return _children;
    }
}