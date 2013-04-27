package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.tools.AssetLoader;
import haxe.Timer;
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
class HeroSelect extends Sprite
{
	var _title:DisplayObject;
	var _start:TextField;
	var _font:Font;
	var _index:Int;
	var _heroName:TextField;
	var _hero:DisplayObject;

	public function new() 
	{
		super();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 0, 480, 320);
		this.graphics.endFill();
		
		displayStart();
		
		_title = AssetLoader.loadGraphic('title', 480, 60);
		_title.y -= 60;
		addChild(_title);
		
		this.addEventListener(MouseEvent.CLICK, startSelect);
		Timer.delay(animIntro, 60);
	}
	
	function animIntro() 
	{
		if (_title != null) {
			_title.y += 5;
			if(_title.y < 80){
				Timer.delay(animIntro, 60);
			}
		}
	}
	
	function displayStart() 
	{
		
		
		_font = Assets.getFont('fonts/vgafix.ttf');
		
		_start = new TextField();
		_start.defaultTextFormat = new TextFormat(_font.fontName, 20);
		_start.textColor = 0xFFFFFF;
		_start.embedFonts = true;
		_start.text = "Click to Start new game";
		_start.selectable = false;
		_start.mouseEnabled = false;
		_start.width = 480;
		_start.height = 50;
		_start.antiAliasType = AntiAliasType.ADVANCED;
		_start.autoSize = TextFieldAutoSize.CENTER;
		_start.y = 260;
		addChild(_start);
		
		Timer.delay(fadeStart, 60);
	}
	
	function fadeStart() 
	{
		if (_start != null) {
			_start.alpha -= 0.1;
			if (_start.alpha <= 0) {
				Timer.delay(unfadeStart, 60);
			}else {
				Timer.delay(fadeStart, 60);
			}
		}
	}
	
	function unfadeStart() 
	{
		if (_start != null) {
			_start.alpha += 0.1;
			if (_start.alpha >= 1) {
				Timer.delay(fadeStart, 60);
			}else {
				Timer.delay(unfadeStart, 60);
			}
		}		
	}
	
	private function startSelect(e:MouseEvent):Void 
	{
		this.removeEventListener(MouseEvent.CLICK, startSelect);
		removeChild(_title);
		_title = null;
		removeChild(_start);
		_start = null;
		
		
		
		var _select:TextField = new TextField();
		_select.defaultTextFormat = new TextFormat(_font.fontName, 20);
		_select.textColor = 0xFFFFFF;
		_select.embedFonts = true;
		_select.text = "Select your hero !";
		_select.selectable = false;
		_select.width = 480;
		_select.height = 50;
		_select.antiAliasType = AntiAliasType.ADVANCED;
		_select.autoSize = TextFieldAutoSize.CENTER;
		_select.y = 10;
		addChild(_select);
		
		
		var _leftBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_left_up', 32, 30), AssetLoader.loadGraphic('btn_left_over', 32, 30), AssetLoader.loadGraphic('btn_left_down', 32, 30), AssetLoader.loadGraphic('btn_left_down', 32, 30));
		_leftBtn.addEventListener(MouseEvent.CLICK, moveLeft);
		_leftBtn.x = 50;
		_leftBtn.y = 90;
		addChild(_leftBtn);
		var _rightBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_right_up', 32, 30), AssetLoader.loadGraphic('btn_right_over', 32, 30), AssetLoader.loadGraphic('btn_right_down', 32, 30), AssetLoader.loadGraphic('btn_right_down', 32, 30));
		_rightBtn.addEventListener(MouseEvent.CLICK, moveRight);
		_rightBtn.x = 390;
		_rightBtn.y = 90;
		addChild(_rightBtn);
		var _startBtn:SimpleButton = new SimpleButton(AssetLoader.loadGraphic('btn_start_up', 80, 30), AssetLoader.loadGraphic('btn_start_over', 80, 30), AssetLoader.loadGraphic('btn_start_down', 80, 30), AssetLoader.loadGraphic('btn_start_down', 80, 30));
		_startBtn.addEventListener(MouseEvent.CLICK, startGame);
		_startBtn.x = 200;
		_startBtn.y = 260;
		addChild(_startBtn);
		
		_index = 0;
		_heroName = new TextField();
		_heroName.defaultTextFormat = new TextFormat(_font.fontName, 20);
		_heroName.textColor = 0xFFFFFF;
		_heroName.embedFonts = true;
		_heroName.text = DataManager.instance.heroList[_index].name;
		_heroName.selectable = false;
		_heroName.width = 480;
		_heroName.height = 50;
		_heroName.antiAliasType = AntiAliasType.ADVANCED;
		_heroName.autoSize = TextFieldAutoSize.CENTER;
		_heroName.y = 210;
		addChild(_heroName);
		
		
		_hero =  AssetLoader.loadGraphic(DataManager.instance.heroList[_index].graphic, 240, 160);
		_hero.y = 40;
		_hero.x = 120;
		addChild(_hero);
	}
	
	private function startGame(e:MouseEvent):Void 
	{
		dispatchEvent(new Event('game'));
	}
	
	private function moveRight(e:MouseEvent):Void 
	{
		_index++;
		if (_index >= DataManager.instance.heroList.length) {
			_index = 0;
		}
		removeChild(_hero);
		_hero =  AssetLoader.loadGraphic(DataManager.instance.heroList[_index].graphic, 240, 160);
		_hero.y = 40;
		_hero.x = 120;
		addChild(_hero);
		_heroName.text = DataManager.instance.heroList[_index].name;
	}
	
	private function moveLeft(e:MouseEvent):Void 
	{
		_index--;
		if (_index < 0) {
			_index = DataManager.instance.heroList.length - 1;
		}
		removeChild(_hero);
		_hero =  AssetLoader.loadGraphic(DataManager.instance.heroList[_index].graphic, 240, 160);
		_hero.y = 40;
		_hero.x = 120;
		addChild(_hero);
		_heroName.text = DataManager.instance.heroList[_index].name;
	}
	
	function get_index():Int 
	{
		return _index;
	}
	
	public var index(get_index, null):Int;
	
}