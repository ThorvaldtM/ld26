package com.ttermeer.ld26.interfaces;

import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.data.DLoot;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.AntiAliasType;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;

/**
 * ...
 * @author Thorvald ter Meer
 */
class ItemPopup extends Sprite
{
	static public var SALE:String = "sale";
	static public var EQUIP:String = "equip";
	
	var _loot:DLoot;
	var _equipBtn:SimpleButton;
	var _saleBtn:SimpleButton;

	public function new(loot:DLoot, heroData:DHero) 
	{
		super();
		addChild(AssetLoader.loadGraphic('popup', 240, 160));
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		var _title:TextField = new TextField();
		_title.defaultTextFormat = new TextFormat(_font.fontName, 12);
		_title.textColor = 0xFFFFFF;
		_title.embedFonts = true;
		_title.text = "Victory !";
		_title.selectable = false;
		_title.width = 240;
		_title.height = 30;
		_title.antiAliasType = AntiAliasType.ADVANCED;
		_title.autoSize = TextFieldAutoSize.CENTER;
		_title.y = 5;
		addChild(_title);
		
		_loot = loot;
		//fetch item info
		var _name:String = "";
		var _graphic:String = "";
		var _canWear:Bool = false;
		switch(loot.type) {
			case DLoot.WEAPON :
				var _weapon:DWeapon = DataManager.instance.getWeapon(loot.id);
				_name = _weapon.name + ' - ' + 'ATK : ' + _weapon.value;
				_graphic = _weapon.graphic;
				if ( Lambda.indexOf(heroData.weapons, _weapon.type) > -1) {
					_canWear = true;
				}
			case DLoot.ARMOR :
				var _armor:DArmor = DataManager.instance.getArmor(loot.id);
				_name = _armor.name + ' - ' + 'DEF : ' + _armor.value;
				_graphic = _armor.graphic;
				if ( Lambda.indexOf(heroData.armors, _armor.type) > -1) {
					_canWear = true;
				}
			case DLoot.SKILL :
				var _skill:DSkill = DataManager.instance.getSkill(loot.id);
				_name = _skill.name;
				_graphic = _skill.graphic;
				if ( Lambda.indexOf(heroData.skills, _skill.type) > -1) {
					_canWear = true;
				}
		}
		
		var _graph:DisplayObject = AssetLoader.loadGraphic(_graphic, 80, 80);
		_graph.x = 80;
		_graph.y = 10;
		addChild(_graph);
		
		var _lootName:TextField = new TextField();
		_lootName.defaultTextFormat = new TextFormat(_font.fontName, 12);
		_lootName.textColor = 0xFFFFFF;
		_lootName.embedFonts = true;
		_lootName.text = _name;
		_lootName.selectable = false;
		_lootName.width = 240;
		_lootName.height = 30;
		_lootName.antiAliasType = AntiAliasType.ADVANCED;
		_lootName.autoSize = TextFieldAutoSize.CENTER;
		_lootName.y = 90;
		addChild(_lootName);
		
		
		if(_canWear){
			_equipBtn = new SimpleButton(AssetLoader.loadGraphic('btn_equip_up', 80, 30), AssetLoader.loadGraphic('btn_equip_over', 80, 30), AssetLoader.loadGraphic('btn_equip_down', 80, 30), AssetLoader.loadGraphic('btn_equip_down', 80, 30));
			_equipBtn.addEventListener(MouseEvent.CLICK, dispatchEquip);
			_equipBtn.y = 125;
			_equipBtn.x = 30;
			addChild(_equipBtn);
			_saleBtn = new SimpleButton(AssetLoader.loadGraphic('btn_sale_up', 80, 30), AssetLoader.loadGraphic('btn_sale_over', 80, 30), AssetLoader.loadGraphic('btn_sale_down', 80, 30), AssetLoader.loadGraphic('btn_sale_down', 80, 30));
			_saleBtn.x = 130;
			_saleBtn.y = 125;
			_saleBtn.addEventListener(MouseEvent.CLICK, dispatchSale);
			addChild(_saleBtn);
		}else {
		
			var _cantEquip:TextField = new TextField();
			_cantEquip.defaultTextFormat = new TextFormat(_font.fontName,12);
			_cantEquip.embedFonts = true;
			_cantEquip.text = "Your class can't wear this item.";
			_cantEquip.selectable = false;
			_cantEquip.textColor = 0xFFFFFF;
			_cantEquip.width = 240;
			_cantEquip.height = 30;
			_cantEquip.autoSize = TextFieldAutoSize.CENTER;
			_cantEquip.antiAliasType = AntiAliasType.ADVANCED;
			_cantEquip.y = 105;
			addChild(_cantEquip);
			_saleBtn = new SimpleButton(AssetLoader.loadGraphic('btn_sale_up', 80, 30), AssetLoader.loadGraphic('btn_sale_over', 80, 30), AssetLoader.loadGraphic('btn_sale_down', 80, 30), AssetLoader.loadGraphic('btn_sale_down', 80, 30));
			_saleBtn.x = 80;
			_saleBtn.y = 125;
			_saleBtn.addEventListener(MouseEvent.CLICK, dispatchSale);
			addChild(_saleBtn);
			
		}
	}
	
	private function dispatchSale(e:MouseEvent):Void 
	{
		dispatchEvent(new Event(SALE));
	}
	
	private function dispatchEquip(e:MouseEvent):Void 
	{
		dispatchEvent(new Event(EQUIP));
	}
	
	function get_loot():DLoot 
	{
		return _loot;
	}
	
	public var loot(get_loot, null):DLoot;
	
}