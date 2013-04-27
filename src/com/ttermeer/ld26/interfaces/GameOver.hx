package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.Assets;
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
class GameOver extends Sprite
{

	public function new() 
	{
		super();
		addChild(AssetLoader.loadGraphic('popup', 240, 160));
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		var _lootName:TextField = new TextField();
		_lootName.defaultTextFormat = new TextFormat(_font.fontName, 20);
		_lootName.textColor = 0xFFFFFF;
		_lootName.embedFonts = true;
		_lootName.text = "Game Over !";
		_lootName.selectable = false;
		_lootName.width = 240;
		_lootName.height = 50;
		_lootName.antiAliasType = AntiAliasType.ADVANCED;
		_lootName.autoSize = TextFieldAutoSize.CENTER;
		_lootName.y = 60;
		addChild(_lootName);
		
		var _restart:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_restart_up', 80, 30), AssetLoader.loadGraphic('btn_restart_over', 80, 30), AssetLoader.loadGraphic('btn_restart_down', 80, 30), AssetLoader.loadGraphic('btn_restart_down', 80, 30));
		_restart.addEventListener(MouseEvent.CLICK, dispatchRestart);
		_restart.y = 125;
		_restart.x = 80;
		addChild(_restart);
	}
	
	private function dispatchRestart(e:MouseEvent):Void 
	{
		dispatchEvent(new Event('restart'));
	}
	
}