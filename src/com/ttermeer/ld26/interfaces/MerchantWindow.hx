package com.ttermeer.ld26.interfaces;

import com.ttermeer.ld26.data.DItem;
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
class MerchantWindow extends Sprite
{
	var _item:DItem;
	static public var BUY:String = "buy";
	static public var LEAVE:String = "leave";

	public function new(item:DItem) 
	{
		super();
		addChild(AssetLoader.loadGraphic('popup', 240, 160));
		
		_item = item;
		var _name:String = _item.name;
		if (_item.slot == DItem.WEAPON) {
			_name += " - ATK: " + _item.value;
		}else if (_item.slot == DItem.ARMOR) {
			_name += " - DEF: " + _item.value;			
		}
		
		var _graph:DisplayObject = AssetLoader.loadGraphic(_item.graphic, 80, 80);
		_graph.x = 80;
		_graph.y = 10;
		addChild(_graph);
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		var _title:TextField = new TextField();
		_title.defaultTextFormat = new TextFormat(_font.fontName, 12);
		_title.textColor = 0xFFFFFF;
		_title.embedFonts = true;
		_title.text = "Wandering Merchant";
		_title.selectable = false;
		_title.width = 240;
		_title.height = 30;
		_title.antiAliasType = AntiAliasType.ADVANCED;
		_title.autoSize = TextFieldAutoSize.CENTER;
		_title.y = 5;
		addChild(_title);
		
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
		
		var _buyText:TextField = new TextField();
		_buyText.defaultTextFormat = new TextFormat(_font.fontName,12);
		_buyText.embedFonts = true;
		_buyText.text = "Price: " + (_item.gold * 10) + " Gold(s)";
		_buyText.selectable = false;
		_buyText.textColor = 0xFFFFFF;
		_buyText.width = 240;
		_buyText.height = 30;
		_buyText.autoSize = TextFieldAutoSize.CENTER;
		_buyText.antiAliasType = AntiAliasType.ADVANCED;
		_buyText.y = 105;
		addChild(_buyText);
		
		var _buyBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_buy_up', 80, 30), AssetLoader.loadGraphic('btn_buy_over', 80, 30), AssetLoader.loadGraphic('btn_buy_down', 80, 30), AssetLoader.loadGraphic('btn_buy_down', 80, 30));
		_buyBtn.addEventListener(MouseEvent.CLICK, dispatchBuy);
		_buyBtn.y = 125;
		_buyBtn.x = 30;
		addChild(_buyBtn);
		var _leaveBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_leave_up', 80, 30), AssetLoader.loadGraphic('btn_leave_over', 80, 30), AssetLoader.loadGraphic('btn_leave_down', 80, 30), AssetLoader.loadGraphic('btn_leave_down', 80, 30));
		_leaveBtn.x = 130;
		_leaveBtn.y = 125;
		_leaveBtn.addEventListener(MouseEvent.CLICK, dispatchLeave);
		addChild(_leaveBtn);
	}
	
	private function dispatchLeave(e:MouseEvent):Void 
	{
		dispatchEvent(new Event(LEAVE));
	}
	
	private function dispatchBuy(e:MouseEvent):Void 
	{
		dispatchEvent(new Event(BUY));
	}
	
	function get_item():DItem 
	{
		return _item;
	}
	
	public var item(get_item, null):DItem;
	
}