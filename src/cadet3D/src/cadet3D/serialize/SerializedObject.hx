// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet3d.serialize;

class SerializedObject
{
	public var id : Int;public var setId : Int;  
	// currently only used by Segments  
	public var containerId : Int;
	public var className : String;
	public var instanceName : String;
	public var props : Array<NameValuePair>;
	public var constructorArgs : Array<NameValuePair>;
	public var source : Dynamic;
	public var type : Class<Dynamic>;
	
	public function new()
	{
		props = new Array<NameValuePair>();
		constructorArgs = new Array<NameValuePair>();
	}
	
	public function getPropByName(name : String) : NameValuePair
	{
		return _getPropByName(name);
	}
	
	public function getConstructorArgByName(name : String) : NameValuePair
	{
		return _getPropByName(name);
	}
	
	private function _getPropByName(name : String) : NameValuePair
	{
		var vector : Array<NameValuePair> = props.concat(constructorArgs);
		for (i in 0...vector.length) {
			var nvp : NameValuePair = vector[i];
			if (nvp.name == name) {
				return nvp;
			}
		}
		return null;
	}
	
	public function toString(numTabs : Int = 0) : String
	{
		var str : String = "";
		str += newLine("SerializedObject", numTabs);
		str += newLine("className : " + className, numTabs + 1);
		str += newLine("type : " + type, numTabs + 1);
		str += newLine("source : " + source, numTabs + 1);
		str += newLine("instanceName : " + instanceName, numTabs + 1);
		str += newLine("id : " + id, numTabs + 1);
		str += newLine("setId : " + setId, numTabs + 1);
		str += newLine("containerId : " + containerId, numTabs + 1);
		str += newLine("constructorArgs : length = " + constructorArgs.length, numTabs + 1);
		str += vectorToString(constructorArgs, numTabs);
		str += newLine("props : length = " + props.length, numTabs + 1);
		str += vectorToString(props, numTabs);
		return str;
	}
	
	private function vectorToString(v : Array<NameValuePair>, numTabs : Int = 0) : String
	{
		var str : String = "";
		
		for (i in 0...v.length) {
			var nvp : NameValuePair = v[i];
			var value : Dynamic = Std.string(nvp.value);
			if (Std.is(nvp.value, SerializedObject)) {
				value = Std.string(nvp.value);
			} else if (Std.is(nvp.value, Array/*Vector.<T> call?*/)) {
				value = "";
				var v2 : Array<SerializedObject> = nvp.value;
				for (j in 0...v2.length) {
					var vSO : SerializedObject = v2[j];
					value += Std.string(vSO);
				}
			}
			str += newLine(nvp.name + " : " + value, numTabs + 2);
		}
		return str;
	}
	
	private function newLine(value : String = "", numTabs : Int = 0) : String
	{
		var str : String = "\n";
		for (i in 0...numTabs) {
			str += "\t";
		}
		str += value;
		return str;
	}
}