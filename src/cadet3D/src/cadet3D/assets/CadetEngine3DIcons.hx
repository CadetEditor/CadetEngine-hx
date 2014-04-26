// =================================================================================================  
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.assets;

class CadetEngine3DIcons
{
	@:meta(Embed(source="Camera.png"))
	public static var Camera : Class<Dynamic>;  
	//[Embed( source = 'CameraPan.png' )] 		
	//static public var CameraPan:Class;    
	//[Embed( source = 'CameraRotate.png' )] 		
	//static public var CameraRotate:Class;    
	//[Embed( source = 'CameraZoom.png' )] 		
	//static public var CameraZoom:Class;  
	@:meta(Embed(source="Cube.png"))
	public static var Cube : Class<Dynamic>;
	@:meta(Embed(source="DirectionalLight.png"))
	public static var DirectionalLight : Class<Dynamic>;
	@:meta(Embed(source="Geometry.png"))
	public static var Geometry : Class<Dynamic>;
	@:meta(Embed(source="PointLight.png"))
	public static var PointLight : Class<Dynamic>;
	@:meta(Embed(source="Mesh.png"))
	public static var Mesh : Class<Dynamic>;
	@:meta(Embed(source="Material.png"))
	public static var Material : Class<Dynamic>;	
	@:meta(Embed(source="Plane.png"))
	public static var Plane : Class<Dynamic>;
	@:meta(Embed(source="Renderer.png"))
	public static var Renderer : Class<Dynamic>;  
	//[Embed( source = 'Rotate.png' )] 			
	//static public var Rotate:Class;    
	//[Embed( source = 'Scale.png' )] 			
	//static public var Scale:Class;  
	@:meta(Embed(source="Sphere.png"))
	public static var Sphere : Class<Dynamic>;  
	//[Embed( source = 'Translate.png' )] 		
	//static public var Translate:Class;  

	public function new()
	{
	}
}