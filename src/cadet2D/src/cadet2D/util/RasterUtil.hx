  // =================================================================================================    //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.util;

import cadet2d.util.BitmapData;
import cadet2d.util.ColorTransform;
import nme.display.BitmapData;import nme.geom.ColorTransform;import nme.geom.Matrix;import cadet2d.geom.Vertex;class RasterUtil
{private static var labelTable : Array<Dynamic>;private static var loops : Array<Dynamic>;private static inline var UNLABELED : Int = 0;private static var VISITED_WHITE : Int = -1;private static var offsetTableX : Dynamic;private static var offsetTableY : Dynamic;private static var nextPosTable : Dynamic;public static function bitmapToVertices(bmpData : BitmapData) : Array<Dynamic>{if (offsetTableX == null) {offsetTableX = { };offsetTableY = { };nextPosTable = { };offsetTableX[0] = 1;offsetTableY[0] = 0;offsetTableX[1] = 1;offsetTableY[1] = 1;offsetTableX[2] = 0;offsetTableY[2] = 1;offsetTableX[3] = -1;offsetTableY[3] = 1;offsetTableX[4] = -1;offsetTableY[4] = 0;offsetTableX[5] = -1;offsetTableY[5] = -1;offsetTableX[6] = 0;offsetTableY[6] = -1;offsetTableX[7] = 1;offsetTableY[7] = -1;nextPosTable[0] = 4;nextPosTable[1] = 5;nextPosTable[2] = 6;nextPosTable[3] = 7;nextPosTable[4] = 0;nextPosTable[5] = 1;nextPosTable[6] = 2;nextPosTable[7] = 3;
        }  //var startTime:int = flash.utils.getTimer();  var bitmap : BitmapData = new BitmapData(bmpData.width + 2, bmpData.height + 2, false, 0xFFFFFF);bitmap.draw(bmpData, new Matrix(1, 0, 0, 1, 1, 1), new ColorTransform(0, 0, 0));var w : Int = bitmap.width;var h : Int = bitmap.height;labelTable = [];loops = [];var C : Int = 1;for (y in 1...h){for (x in 0...w){var isBlack : Bool = bitmap.getPixel(x, y) == 0;if (!isBlack)                     {x++;continue;
                };var currentLabel : Int = UNLABELED;if (labelTable[x] != null) {currentLabel = labelTable[x][y];
                }var isPixelAboveBlack : Bool = bitmap.getPixel(x, y - 1) == 0;var isContour : Bool = false;  // Step 1  if (currentLabel == UNLABELED && isPixelAboveBlack == false) {if (labelTable[x] == null)                         labelTable[x] = [];labelTable[x][y] = C;traceContour(x, y, C, bitmap, true);C++;isContour = true;
                }var isPixelBelowBlack : Bool = bitmap.getPixel(x, y + 1) == 0;var pixelBelowLabel : Int = labelTable[x][y];if (isPixelBelowBlack == false && pixelBelowLabel == UNLABELED) {if (currentLabel == UNLABELED) {if (labelTable[x] == null)                             labelTable[x] = [];labelTable[x][y] = labelTable[x - 1][y];
                    }traceContour(x, y, C, bitmap, false);C++;isContour = true;
                }if (!isContour) {if (labelTable[x] == null)                         labelTable[x] = [];labelTable[x][y] = labelTable[x - 1][y];
                }
            }
        }  //trace(flash.utils.getTimer() - startTime);  return loops;
    }private static function traceContour(x : Int, y : Int, C : Int, bitmap : BitmapData, contourType : Bool) : Void{var loop : Array<Dynamic> = [];var s : Vertex = new Vertex(x, y);loop.push(s);var loopLength : Int = 1;var t : Vertex;var pos : Int = (contourType) ? 7 : 3;var sx : Float = s.x;var sy : Float = s.y;do{var i : Int = 8;while (i-- > -1){var localX : Int = x;var localY : Int = y;localX += offsetTableX[pos];localY += offsetTableY[pos];var isLocalBlack : Bool = bitmap.getPixel(localX, localY) == 0;if (isLocalBlack) {if (labelTable[localX] == null)                         labelTable[localX] = [];labelTable[localX][localY] = C;t = new Vertex(localX, localY);loop[loopLength++] = t;pos = (nextPosTable[pos] + 2) % 8;x = localX;y = localY;break;
                }
                else {if (labelTable[localX] == null)                         labelTable[localX] = [];labelTable[localX][localY] = VISITED_WHITE;
                }pos = (pos + 1) % 8;
            }if (t == null) {t = new Vertex(s.x, s.y);
            }
        }        while ((t.x != sx || t.y != sy));if (loop.length > 2) {loops.push(loop);
        }
    }

    public function new()
    {
    }
}