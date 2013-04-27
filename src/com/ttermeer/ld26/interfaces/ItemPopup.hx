package com.ttermeer.ld26.interfaces;

import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DLoot;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import nme.display.Sprite;
import nme.text.TextField;

/**
 * ...
 * @author Thorvald ter Meer
 */
class ItemPopup extends Sprite
{
	var _loot:DLoot;

	public function new(loot:DLoot) 
	{
		super();
		this.graphics.beginFill(0xc5c5c5);
		this.graphics.drawRoundRect(0, 0, 240, 160, 10, 10);
		this.graphics.endFill();
		
		_loot = loot;
		//fetch item info
		var _name:String = "";
		var _graphic:String = "";
		switch(loot.type) {
			case DLoot.WEAPON :
				var _weapon:DWeapon = DataManager.instance.getWeapon(loot.id);
				_name = _weapon.name;
				_graphic = _weapon.graphic;
			case DLoot.ARMOR :
				var _armor:DArmor = DataManager.instance.getArmor(loot.id);
				_name = _armor.name;
				_graphic = _armor.graphic;
			case DLoot.SKILL :
				var _skill:DSkill = DataManager.instance.getSkill(loot.id);
				_name = _skill.name;
				_graphic = _skill.graphic;
		}
		
		var _lootName:TextField = new TextField();
		_lootName.text = _name;
		addChild(_lootName);
	}
	
}