package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.Assets;
import nme.display.Sprite;
import nme.text.AntiAliasType;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;

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
		
		addChild(AssetLoader.loadGraphic('inventory', 240, 160));
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		_weapon = new TextField();
		_weapon.defaultTextFormat = new TextFormat(_font.fontName,12);
		_weapon.textColor = 0xFFFFFF;
		_weapon.selectable = false;
		_weapon.height = 40;
		_weapon.width = 180;
		_weapon.multiline = true;
		_weapon.antiAliasType = AntiAliasType.ADVANCED;
		_weapon.embedFonts = true;
		_weapon.x = 36;
		_weapon.y = 12;
		addChild(_weapon);
		
		_armor = new TextField();
		_armor.defaultTextFormat = new TextFormat(_font.fontName,12);
		_armor.antiAliasType = AntiAliasType.ADVANCED;
		_armor.embedFonts = true;
		_armor.textColor = 0xFFFFFF;
		_armor.height = 40;
		_armor.width = 180;
		_armor.y = _weapon.y + _weapon.height + 10;
		_armor.selectable = false;
		_armor.multiline = true;
		_armor.x = 36;
		_armor.y = 62;
		addChild(_armor);
		
		_skill = new TextField();
		_skill.defaultTextFormat = new TextFormat(_font.fontName,12);
		_skill.antiAliasType = AntiAliasType.ADVANCED;
		_skill.embedFonts = true;
		_skill.textColor = 0xFFFFFF;
		_skill.height = 40;
		_skill.width = 180;
		_skill.y = _armor.y + _armor.height + 10;
		_skill.selectable = false;
		_skill.multiline = true;
		_skill.x = 36;
		_skill.y = 112;
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
		_weapon.text = "Weapon : " + value.name + '\nATK : ' + value.value;
		return _currentWeapon = value;
	}
	
	public var currentWeapon(get_currentWeapon, set_currentWeapon):DWeapon;
	
	function get_currentArmor():DArmor 
	{
		return _currentArmor;
	}
	
	function set_currentArmor(value:DArmor):DArmor 
	{
		_armor.text = "Armor : " + value.name + '\nDEF : ' + value.value;
		return _currentArmor = value;
	}
	
	public var currentArmor(get_currentArmor, set_currentArmor):DArmor;
	
	function get_currentSkill():DSkill 
	{
		return _currentSkill;
	}
	
	function set_currentSkill(value:DSkill):DSkill 
	{
		_skill.text = "Skill : " + value.name + '\nSP : ' + value.sp;
		return _currentSkill = value;
	}
	
	public var currentSkill(get_currentSkill, set_currentSkill):DSkill;
	
}