// =================================================================================================    
//    
//	CadetEngine Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package cadet.util;

/**
 * Class for rad2deg
 */
@:final class ClassForRad2deg
{  
	/** Converts an angle from radions into degrees. */  
	public function rad2deg(rad : Float) : Float
	{
		return rad / Math.PI * 180.0;
    }

    public function new()
    {
    }
}