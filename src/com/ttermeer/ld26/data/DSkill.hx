package com.ttermeer.ld26.data;

/**
 * ...
 * @author Thorvald ter Meer
 */
class DSkill extends DItem
{
	public var fx:String;
	public var sp:Int;
	public var sound:String;

	public function new() 
	{
		super();
		slot = DItem.SKILL;
		sound = "";
		fx = "";
	}
	
}