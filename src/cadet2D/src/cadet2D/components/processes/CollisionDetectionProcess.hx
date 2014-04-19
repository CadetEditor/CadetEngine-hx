// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet2d.components.processes;

import cadet2d.components.processes.BoundingSphere;
import cadet2d.components.processes.CollisionEvent;
import cadet2d.components.processes.Component;
import cadet2d.components.processes.ComponentEvent;
import cadet2d.components.processes.ICollisionShape;
import cadet2d.components.processes.IComponent;
import cadet2d.components.processes.ISteppableComponent;
import cadet2d.components.processes.Matrix;
import cadet.core.Component;import cadet.core.IComponent;import cadet.core.ISteppableComponent;import cadet.events.ComponentEvent;import cadet.util.ComponentUtil;import cadet2d.components.geom.BoundingSphere;import cadet2d.components.geom.ICollisionShape;import cadet2d.components.transforms.Transform2D;import cadet2d.events.CollisionEvent;import nme.geom.Matrix;class CollisionDetectionProcess extends Component implements ISteppableComponent
{private var boundingSpheres : Array<BoundingSphere>;public function new()
    {
        super();boundingSpheres = new Array<BoundingSphere>();
    }override private function addedToScene() : Void{var collisionShapes : Array<IComponent> = ComponentUtil.getChildrenOfType(scene, ICollisionShape, true);for (collisionShape in collisionShapes){if (Std.is(collisionShape, BoundingSphere)) {boundingSpheres.push(cast((collisionShape), BoundingSphere));
            }
        }scene.addEventListener(ComponentEvent.ADDED_TO_SCENE, onComponentAddedToSceneHandler);scene.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, onComponentRemovedFromScene);
    }override private function removedFromScene() : Void{boundingSpheres = new Array<BoundingSphere>();scene.removeEventListener(ComponentEvent.ADDED_TO_SCENE, onComponentAddedToSceneHandler);scene.removeEventListener(ComponentEvent.REMOVED_FROM_SCENE, onComponentRemovedFromScene);
    }private function onComponentAddedToSceneHandler(event : ComponentEvent) : Void{if (Std.is(event.component, ICollisionShape) == false)             return;if (Std.is(event.component, BoundingSphere)) {boundingSpheres.push(cast((event.component), BoundingSphere));
        }
    }private function onComponentRemovedFromScene(event : ComponentEvent) : Void{if (Std.is(event.component, ICollisionShape) == false)             return;if (Std.is(event.component, BoundingSphere)) {boundingSpheres.splice(Lambda.indexOf(boundingSpheres, cast((event.component), BoundingSphere)), 1);
        }
    }public function step(dt : Float) : Void{var collisions : Array<Dynamic> = new Array<Dynamic>();var L : Int = boundingSpheres.length;for (i in 0...L){var boundingSphereA : BoundingSphere = boundingSpheres[i];if (boundingSphereA.transform == null)                 {i++;continue;
            };for (j in i + 1...L){var boundingSphereB : BoundingSphere = boundingSpheres[j];if (boundingSphereB.transform == null)                     {j++;continue;
                };var mA : Matrix = cast((boundingSphereA.transform), Transform2D).globalMatrix;var mB : Matrix = cast((boundingSphereB.transform), Transform2D).globalMatrix;var dx : Float = mA.tx - mB.tx;var dy : Float = mA.ty - mB.ty;var sqrScaleXA : Float = mA.a * mA.a + mA.b * mA.b;var sqrScaleYA : Float = mA.c * mA.c + mA.d * mA.d;var scaleA : Float = sqrScaleXA > (sqrScaleYA != 0) ? Math.sqrt(sqrScaleXA) : Math.sqrt(sqrScaleYA);var sqrScaleXB : Float = mB.a * mB.a + mB.b * mB.b;var sqrScaleYB : Float = mB.c * mB.c + mB.d * mB.d;var scaleB : Float = sqrScaleXB > (sqrScaleYB != 0) ? Math.sqrt(sqrScaleXB) : Math.sqrt(sqrScaleYB);var d : Float = dx * dx + dy * dy;var r : Float = scaleA * boundingSphereA.radius + scaleB * boundingSphereB.radius;if (d > r * r)                     {j++;continue;
                }  // So we must finish processing all collisions this step before we allow that to happen.    // that ends up removing a bounding sphere from the scene.    // This is because a listener for the event could make a change to the scene    // to a list for processing later.    // A collision has occured. Rather than dispatching the event right away, add it  ;var event : CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION, boundingSphereA, boundingSphereB);collisions.push({
                            event : event,
                            a : boundingSphereA,
                            b : boundingSphereB,

                        });
            }
        }for (collision in collisions){collision.a.dispatchEvent(collision.event);collision.b.dispatchEvent(collision.event);
        }
    }
}