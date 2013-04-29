package com.ttermeer.ld26.data;

/**
 * ...
 * @author Thorvald ter Meer
 */
class DItem
{
	public static var WEAPON:Int = 1;
	public static var ARMOR:Int = 2;
	public static var SKILL:Int = 3;
	
	public var id:Int;
	public var name:String;
	public var graphic:String;
	public var type:Int;
	public var slot:Int;
	public var gold:Int;
	public var value:Int;

	public function new() 
	{
		value = 0;
	}
	
}