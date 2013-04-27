package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DMonster;
import com.ttermeer.ld26.tools.AssetLoader;
import haxe.Timer;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.geom.Rectangle;
import nme.text.AntiAliasType;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author Thorvald ter Meer
 */
class MonsterWindow extends Sprite
{
	private var _currentMonster:DMonster;
	private var _monster:DisplayObject;
	var _hp:TextField;
	var _walkSheet:Tilesheet;
	var _index:Int = 0;
	var _indexSlash:Int = 0;
	var _walking:Bool = false;
	var _slashSheet:Tilesheet;
	var _fxSheet:Tilesheet;
	var _fx:Sprite;
	var _shakeLeft:Int;

	public function new() 
	{
		super();
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		_hp = new TextField();
		_hp.defaultTextFormat = new TextFormat(_font.fontName,12);
		_hp.antiAliasType = AntiAliasType.ADVANCED;
		_hp.embedFonts = true;
		_hp.selectable = false;
		_hp.textColor = 0xFFFFFF;
		_hp.text = "HP : 100/100";
		_hp.height = 20;
		_hp.width = 240;
		_hp.y = 140;
		_hp.visible = false;
		addChild(_hp);
		
		_fx = new Sprite();
		addChild(_fx);
		
		//load Anim
		
		_slashSheet = new Tilesheet(Assets.getBitmapData('img/slash.png'));
		_slashSheet.addTileRect(new Rectangle(0, 0, 240, 160));
		_slashSheet.addTileRect(new Rectangle(0, 160, 240, 160));
		_slashSheet.addTileRect(new Rectangle(0, 320, 240, 160));
		
		
		_walkSheet = new Tilesheet(Assets.getBitmapData('img/walk.png'));
		_walkSheet.addTileRect(new Rectangle(0, 0, 240, 160));
		_walkSheet.addTileRect(new Rectangle(0, 160, 240, 160));
		_walkSheet.addTileRect(new Rectangle(0, 320, 240, 160));
		_walkSheet.drawTiles(this.graphics, [0,0,_index]);		
		//walkAnimation();
		Timer.delay(updateWalk, 250);
	}
	
	public function walkAnimation() 
	{
		//TODO ANIMATION
		if (_monster != null ) {
			_monster.visible =  false;
			_hp.visible = false;
		}
		_walking = true;
	}
	
	public function stopWalkAnimation() 
	{
		_walking = false;
	}
	
	private function updateWalk() {
		if (_walking) {
			_index++;
			if (_index > 2) {
				_index = 0;
			}
			this.graphics.clear();
			_walkSheet.drawTiles(this.graphics, [0,0,_index]);
		}
		Timer.delay(updateWalk, 250);
	}
	
	public function hit(?skill:String = ""):Void {
		if (skill != "") {	
			_fxSheet = new Tilesheet(Assets.getBitmapData('img/' + skill +'.png'));
			_fxSheet.addTileRect(new Rectangle(0, 0, 240, 160));
			_fxSheet.addTileRect(new Rectangle(0, 160, 240, 160));
			_fxSheet.addTileRect(new Rectangle(0, 320, 240, 160));	
		}
		
		_indexSlash = 0;
		if (_fxSheet != null) {
			_fxSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
		}else{
			_slashSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
		}
		Timer.delay(updateSlash, 80);
	}
	
	function updateSlash() 
	{
		_fx.graphics.clear();
		_indexSlash++;
		if (_indexSlash < 3) {
			if (_fxSheet != null) {
				_fxSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
			}else{
				_slashSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
			}
			Timer.delay(updateSlash, 80);
		}else {
			_fxSheet = null;
		}
	}
	
	public function criticalHit(?skill:String = ""):Void {
		hit();
		_shakeLeft = 6;
		shakeIt();
	}
	
	function shakeIt() 
	{
		_shakeLeft--;
		if(_shakeLeft> 0){
			this.x = 237.5 + Math.random() *5;
			this.y = -2.5 + Math.random() *5;
			Timer.delay(shakeIt, 40);
		}else {
			this.x = 240;
			this.y = 0;
		}
	}
	
	public function setHp(hp:Int) {
		_hp.text = "HP : " + hp + "/" + _currentMonster.hp;
	}
	
	function get_currentMonster():DMonster 
	{
		return _currentMonster;
	}
	
	function set_currentMonster(value:DMonster):DMonster 
	{
		stopWalkAnimation();
		if (_monster != null) {
			removeChild(_monster);
		}
		_monster = AssetLoader.loadGraphic(value.graphic, 240, 160);
		addChildAt(_monster,numChildren - 2);
		_hp.text = "HP : " + value.hp + "/" + value.hp;
		_hp.visible = true;
		return _currentMonster = value;
	}
	
	public var currentMonster(get_currentMonster, set_currentMonster):DMonster;
	
}