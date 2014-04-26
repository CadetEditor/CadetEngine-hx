/*
set material() function implemented by Rob Silverton to allow Cadet deserialization.
SkyBoxNode is passed a reference to "this", so also needed to be duplicated, though not otherwise changed.
*/

package cadet3d.primitives;

import cadet3d.primitives.BoundingVolumeBase;
import cadet3d.primitives.Camera3D;
import cadet3d.primitives.CubeTextureBase;
import cadet3d.primitives.Entity;
import cadet3d.primitives.EntityNode;
import cadet3d.primitives.IAnimator;
import cadet3d.primitives.IRenderable;
import cadet3d.primitives.IndexBuffer3D;
import cadet3d.primitives.MaterialBase;
import cadet3d.primitives.Matrix;
import cadet3d.primitives.Matrix3D;
import cadet3d.primitives.NullBounds;
import cadet3d.primitives.SkyBoxMaterial;
import cadet3d.primitives.SkyBoxNode;
import cadet3d.primitives.Stage3DProxy;
import cadet3d.primitives.SubGeometry;
import nme.display3d.IndexBuffer3D;
import nme.geom.Matrix;
import nme.geom.Matrix3D;
import away3d.Arcane;
import away3d.animators.IAnimator;
import away3d.bounds.BoundingVolumeBase;
import away3d.bounds.NullBounds;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.base.SubGeometry;
import away3d.core.managers.Stage3DProxy;
import away3d.core.partition.EntityNode;
import away3d.entities.Entity;
import away3d.errors.AbstractMethodError;
import away3d.library.assets.AssetType;
import away3d.materials.MaterialBase;
import away3d.materials.SkyBoxMaterial;
import away3d.textures.CubeTextureBase;  

/**
 * A SkyBox class is used to render a sky in the scene. It's always considered static and 'at infinity', and as
 * such it's always centered at the camera's position and sized to exactly fit within the camera's frustum, ensuring
 * the sky box is always as large as possible without being clipped.
 */  

class SkyBox extends Entity implements IRenderable
{
	public var animator(get, never) : IAnimator;
	public var numTriangles(get, never) : Int;
	public var sourceEntity(get, never) : Entity;
	public var material(get, set) : MaterialBase;
	public var castsShadows(get, never) : Bool;
	public var uvTransform(get, never) : Matrix;
	public var vertexData(get, never) : Array<Float>;
	public var indexData(get, never) : Array<Int>;
	public var UVData(get, never) : Array<Float>;
	public var numVertices(get, never) : Int;
	public var vertexStride(get, never) : Int;
	public var vertexNormalData(get, never) : Array<Float>;
	public var vertexTangentData(get, never) : Array<Float>;
	public var vertexOffset(get, never) : Int;
	public var vertexNormalOffset(get, never) : Int;
	public var vertexTangentOffset(get, never) : Int;
	// todo: remove SubGeometry, use a simple single buffer with offsets  
	private var _geometry : SubGeometry; 
	private var _material : SkyBoxMaterial;
	private var _uvTransform : Matrix = new Matrix();
	private var _animator : IAnimator;
	
	private function get_animator() : IAnimator
	{
		return _animator;
	}
	
	override private function getDefaultBoundingVolume() : BoundingVolumeBase
	{
		return new NullBounds();
	}  
	
	/**
	 * Create a new SkyBox object.
	 * @param cubeMap The CubeMap to use for the sky box's texture.
	 */  
	
	public function new(cubeMap : CubeTextureBase)
	{
		super();
		_material = new SkyBoxMaterial(cubeMap);
		_material.addOwner(this);
		_geometry = new SubGeometry();
		buildGeometry(_geometry);
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	public function activateVertexBuffer(index : Int, stage3DProxy : Stage3DProxy) : Void
	{
		_geometry.activateVertexBuffer(index, stage3DProxy);
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	public function activateUVBuffer(index : Int, stage3DProxy : Stage3DProxy) : Void
	{
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	public function activateVertexNormalBuffer(index : Int, stage3DProxy : Stage3DProxy) : Void
	{
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	public function activateVertexTangentBuffer(index : Int, stage3DProxy : Stage3DProxy) : Void
	{
	}
	
	public function activateSecondaryUVBuffer(index : Int, stage3DProxy : Stage3DProxy) : Void
	{
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	public function getIndexBuffer(stage3DProxy : Stage3DProxy) : IndexBuffer3D
	{
		return _geometry.getIndexBuffer(stage3DProxy);
	}  
	
	/**
	 * The amount of triangles that comprise the SkyBox geometry.
	 */  
	
	private function get_numTriangles() : Int
	{
		return _geometry.numTriangles;
	}  
	
	/**
	 * The entity that that initially provided the IRenderable to the render pipeline.
	 */  
	
	private function get_sourceEntity() : Entity
	{
		return null;
	}  
	
	/**
	 * The material with which to render the object.
	 */  
	
	private function get_material() : MaterialBase
	{
		return _material;
	}  
	
	//Added by RS  
	private function set_material(value : MaterialBase) : MaterialBase
	{
		if (_material == value) return;
		if (_material != null) {
			_material.dispose();
		}  
		//throw new AbstractMethodError("Unsupported method!");  
		_material = cast((value), SkyBoxMaterial);
		_material.addOwner(this);
		return value;
	}
	
	override private function get_assetType() : String
	{
		return AssetType.SKYBOX;
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	override private function invalidateBounds() : Void
	{  
		// dead end  
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	override private function createEntityPartitionNode() : EntityNode
	{
		return new SkyBoxNode(this);
	}  
	
	/**
	 * @inheritDoc
	 */  
	
	override private function updateBounds() : Void
	{
		_boundsInvalid = false;
	}  
	
	/**
	 * Builds the geometry that forms the SkyBox
	 */  
	
	private function buildGeometry(target : SubGeometry) : Void
	{
		var vertices : Array<Float> = [ -1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1];
		vertices.fixed = true;
		var indices : Array<Int> = [0, 1, 2, 2, 3, 0, 6, 5, 4, 4, 7, 6, 2, 6, 7, 7, 3, 2, 4, 5, 1, 1, 0, 4, 4, 0, 3, 3, 7, 4, 2, 1, 5, 5, 6, 2];
		target.updateVertexData(vertices);
		target.updateIndexData(indices);
	}
	
	private function get_castsShadows() : Bool
	{
		return false;
	}
	
	private function get_uvTransform() : Matrix
	{
		return _uvTransform;
	}
	
	private function get_vertexData() : Array<Float>
	{
		return _geometry.vertexData;
	}
	
	private function get_indexData() : Array<Int>
	{
		return _geometry.indexData;
	}
	
	private function get_UVData() : Array<Float>
	{
		return _geometry.UVData;
	}
	
	private function get_numVertices() : Int
	{
		return _geometry.numVertices;
	}
	
	private function get_vertexStride() : Int
	{
		return _geometry.vertexStride;
	}
	
	private function get_vertexNormalData() : Array<Float>
	{
		return _geometry.vertexNormalData;
	}
	
	private function get_vertexTangentData() : Array<Float>
	{
		return _geometry.vertexTangentData;
	}
	
	private function get_vertexOffset() : Int
	{
		return _geometry.vertexOffset;
	}
	
	private function get_vertexNormalOffset() : Int
	{
		return _geometry.vertexNormalOffset;
	}
	
	private function get_vertexTangentOffset() : Int
	{
		return _geometry.vertexTangentOffset;
	}
	
	public function getRenderSceneTransform(camera : Camera3D) : Matrix3D
	{
		return _sceneTransform;
	}
}