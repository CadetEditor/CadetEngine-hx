// =================================================================================================  //    //	CadetEngine Framework    //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    //    //	This program is free software. You can redistribute and/or modify it    //	in accordance with the terms of the accompanying license agreement.    //    // =================================================================================================  package cadet3d.components.core;

import cadet3d.components.core.AbstractGeometryComponent;
import cadet3d.components.core.AbstractMaterialComponent;
import cadet3d.components.core.ColorMaterial;
import cadet3d.components.core.Event;
import cadet3d.components.core.Geometry;
import cadet3d.components.core.Mesh;
import cadet3d.components.core.ObjectContainer3DComponent;
import away3d.core.base.Geometry;import away3d.core.pick.PickingColliderType;import away3d.entities.Mesh;import away3d.materials.ColorMaterial;import cadet.core.Component;import cadet3d.components.geom.AbstractGeometryComponent;import cadet3d.components.geom.GeometryComponent;import cadet3d.components.materials.AbstractMaterialComponent;import nme.events.Event;class MeshComponent extends ObjectContainer3DComponent
{
    public var mesh(get, never) : Mesh;
    public var geometryComponent(get, set) : AbstractGeometryComponent;
    public var materialComponent(get, set) : AbstractMaterialComponent;
private var _mesh : Mesh;private var _geometryComponent : AbstractGeometryComponent;private var _materialComponent : AbstractMaterialComponent;public function new()
    {
        super();_object3D = _mesh = new Mesh(new Geometry());_mesh.material = new ColorMaterial(0xFF00FF);_mesh.geometry = new Geometry();_mesh.mouseEnabled = true;  //_mesh.mouseHitMethod = MouseHitMethod.MESH_CLOSEST_HIT;  _mesh.pickingCollider = PickingColliderType.AUTO_BEST_HIT;
    }override public function dispose() : Void{super.dispose();_mesh.dispose();materialComponent = null;
    }private function get_Mesh() : Mesh{return _mesh;
    }@:meta(Serializable())
@:meta(Inspectable(priority="150",editor="ComponentList",scope="scene"))
private function set_GeometryComponent(value : AbstractGeometryComponent) : AbstractGeometryComponent{if (_geometryComponent == value)             return;if (_geometryComponent != null) {_geometryComponent.removeEventListener(Event.CHANGE, onChangeGeometry);
        }_geometryComponent = value;if (_geometryComponent != null) {_mesh.geometry = _geometryComponent.geometry;_geometryComponent.addEventListener(Event.CHANGE, onChangeGeometry);
        }
        else {_mesh.geometry = new Geometry();
        }
        return value;
    }private function get_GeometryComponent() : AbstractGeometryComponent{return _geometryComponent;
    }@:meta(Serializable())
@:meta(Inspectable(priority="151",editor="ComponentList",scope="scene"))
private function get_MaterialComponent() : AbstractMaterialComponent{return _materialComponent;
    }private function set_MaterialComponent(value : AbstractMaterialComponent) : AbstractMaterialComponent{_materialComponent = value;if (_materialComponent != null) {_mesh.material = _materialComponent.material;
        }
        else {_mesh.material = null;
        }
        return value;
    }  //////////////////////////////////////////////    // PRIVATE    /////////////////////////////////////////////  private function onChangeGeometry(event : Event) : Void{_mesh.geometry = _geometryComponent.geometry;
    }
}