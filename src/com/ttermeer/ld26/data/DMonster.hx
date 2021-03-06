package com.ttermeer.ld26.data;

/**
 * ...
 * @author Thorvald ter Meer
 */
class DMonster
{
	public var id:Int;
	public var name:String;
	public var graphic:String;
	public var hp:Int;
	public var sp:Int;
	public var atk:Int;
	public var def:Int;
	public var skill:Int;
	public var defRatio:Float;
	public var skillRatio:Float;
	public var loots:Array<DLoot>;
	public var gold:Int;
	public var xp:Int;
	public var level:Int;
	public var immunity:Int;
	public var rarity:Int;


	public function new() 
	{
		loots = new Array<DLoot>();
	}
	
}