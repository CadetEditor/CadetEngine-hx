  // =================================================================================================    
  //    
  //	CadetEngine Framework    
  //	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
  //    
  //	This program is free software. You can redistribute and/or modify it    
  //	in accordance with the terms of the accompanying license agreement.    
  //    
  // =================================================================================================  
  
package cadet.components.behaviours;

interface IEntityUserControlledBehaviour
{
	function up() : Void;
	function down() : Void;
	function left() : Void;
	function right() : Void;
	function space() : Void;
}