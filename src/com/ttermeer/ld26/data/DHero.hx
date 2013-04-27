package com.ttermeer.ld26.data;

/**
 * ...
 * @author Thorvald ter Meer
 */
class DHero
{
	public var id:Int;
	public var name:String;
	public var graphic:String;
	public var weapons:Array<Int>;
	public var defaultWeapon:Int;
	public var defaultArmor:Int;
	public var defaultSkill:Int;

	public function new() 
	{
		weapons = new Array<Int>();
	}
	
}