package com.ttermeer.ld26.interfaces;

import com.ttermeer.ld26.data.DShrine;
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
class ShrineWindow extends Sprite
{
	static public var PRAY:String = "pray";
	static public var LEAVE:String = "leave";
	
	
	var _shrine:DShrine;

	public function new(shrine:DShrine) 
	{
		super();
		addChild(AssetLoader.loadGraphic('popup', 240, 160));
		
		_shrine = shrine;
		
		var _graph:DisplayObject = AssetLoader.loadGraphic(_shrine.graphic, 80, 80);
		_graph.x = 80;
		_graph.y = 10;
		addChild(_graph);
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		var _title:TextField = new TextField();
		_title.defaultTextFormat = new TextFormat(_font.fontName, 12);
		_title.textColor = 0xFFFFFF;
		_title.embedFonts = true;
		_title.text = "Special";
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
		_lootName.text = _shrine.name;
		_lootName.selectable = false;
		_lootName.width = 240;
		_lootName.height = 30;
		_lootName.antiAliasType = AntiAliasType.ADVANCED;
		_lootName.autoSize = TextFieldAutoSize.CENTER;
		_lootName.y = 90;
		addChild(_lootName);
		
		var _prayBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_pray_up', 80, 30), AssetLoader.loadGraphic('btn_pray_over', 80, 30), AssetLoader.loadGraphic('btn_pray_down', 80, 30), AssetLoader.loadGraphic('btn_pray_down', 80, 30));
		_prayBtn.addEventListener(MouseEvent.CLICK, dispatchPray);
		_prayBtn.y = 125;
		_prayBtn.x = 30;
		addChild(_prayBtn);
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
	
	private function dispatchPray(e:MouseEvent):Void 
	{
		dispatchEvent(new Event(PRAY));
	}
	
	function get_shrine():DShrine 
	{
		return _shrine;
	}
	
	public var shrine(get_shrine, null):DShrine;
	
}