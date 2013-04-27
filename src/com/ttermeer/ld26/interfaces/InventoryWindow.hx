package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import nme.display.Sprite;
import nme.text.TextField;

/**
 * ...
 * @author Thorvald ter Meer
 */
class InventoryWindow extends Sprite
{
	var _currentWeapon:DWeapon;
	var _currentArmor:DArmor;
	var _currentSkill:DSkill;
	var _weapon:TextField;
	var _armor:TextField;
	var _skill:TextField;

	public function new() 
	{
		super();
		
		_weapon = new TextField();
		_weapon.selectable = false;
		_weapon.height = 30;
		addChild(_weapon);
		
		_armor = new TextField();
		_armor.height = 30;
		_armor.y = _weapon.y + _weapon.height + 20;
		_armor.selectable = false;
		addChild(_armor);
		
		_skill = new TextField();
		_skill.height = 30;
		_skill.y = _armor.y + _armor.height + 20;
		_skill.selectable = false;
		addChild(_skill);
		
		currentWeapon = DataManager.instance.weaponList[0];
		currentArmor = DataManager.instance.armorList[0];
		currentSkill = DataManager.instance.skillList[0];
		
	}
	
	function get_currentWeapon():DWeapon 
	{
		return _currentWeapon;
	}
	
	function set_currentWeapon(value:DWeapon):DWeapon 
	{
		_weapon.text = "Weapon : " + value.name;
		return _currentWeapon = value;
	}
	
	public var currentWeapon(get_currentWeapon, set_currentWeapon):DWeapon;
	
	function get_currentArmor():DArmor 
	{
		return _currentArmor;
	}
	
	function set_currentArmor(value:DArmor):DArmor 
	{
		_armor.text = "Armor : " + value.name;
		return _currentArmor = value;
	}
	
	public var currentArmor(get_currentArmor, set_currentArmor):DArmor;
	
	function get_currentSkill():DSkill 
	{
		return _currentSkill;
	}
	
	function set_currentSkill(value:DSkill):DSkill 
	{
		_skill.text = "Skill : " + value.name;
		return _currentSkill = value;
	}
	
	public var currentSkill(get_currentSkill, set_currentSkill):DSkill;
	
}