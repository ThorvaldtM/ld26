package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.tools.AssetLoader;
import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
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
class HeroWindow extends Sprite
{
	var _hero:DisplayObject;
	var _hp:TextField;
	var _sp:TextField;
	var _gold:TextField;
	var _level:TextField;
	var _xp:TextField;
	var _fx:Sprite;
	var _slashSheet:Tilesheet;
	var _indexSlash:Float;
	var _shakeLeft:Float;

	public function new(hero:DHero) 
	{
		super();
		_hero =  AssetLoader.loadGraphic(hero.graphic, 240, 160);
		addChild(_hero);
		
		var _font:Font = Assets.getFont('fonts/vgafix.ttf');
		
		_hp = new TextField();
		_hp.defaultTextFormat = new TextFormat(_font.fontName,12);
		_hp.antiAliasType = AntiAliasType.ADVANCED;
		_hp.embedFonts = true;
		_hp.selectable = false;
		_hp.textColor = 0xFFFFFF;
		_hp.text = "HP : 100/100";
		_hp.height = 20;
		_hp.width = 120;
		_hp.y = 100;
		addChild(_hp);
		
		_sp = new TextField();
		_sp.defaultTextFormat = new TextFormat(_font.fontName,12);
		_sp.antiAliasType = AntiAliasType.ADVANCED;
		_sp.embedFonts = true;
		_sp.selectable = false;
		_sp.textColor = 0xFFFFFF;
		_sp.text = "SP : 10/10";
		_sp.height = 20;
		_sp.width = 120;
		_sp.y = 100;
		_sp.x = _hp.width + _hp.x;
		addChild(_sp);
		
		_level = new TextField();
		_level.defaultTextFormat = new TextFormat(_font.fontName,12);
		_level.antiAliasType = AntiAliasType.ADVANCED;
		_level.embedFonts = true;
		_level.selectable = false;
		_level.textColor = 0xFFFFFF;
		_level.text = "Level : 1";
		_level.height = 20;
		_level.width = 80;
		_level.y = 120;
		addChild(_level);
		
		_xp = new TextField();
		_xp.defaultTextFormat = new TextFormat(_font.fontName,12);
		_xp.antiAliasType = AntiAliasType.ADVANCED;
		_xp.embedFonts = true;
		_xp.selectable = false;
		_xp.textColor = 0xFFFFFF;
		_xp.text = "Exp. : 0/100";
		_xp.height = 20;
		_xp.width = 160;
		_xp.y = 120;
		_xp.x = _level.width + _level.x;
		addChild(_xp);
		
		_gold = new TextField();
		_gold.defaultTextFormat = new TextFormat(_font.fontName,12);
		_gold.antiAliasType = AntiAliasType.ADVANCED;
		_gold.embedFonts = true;
		_gold.selectable = false;
		_gold.textColor = 0xFFFFFF;
		_gold.text = "Gold : 100";
		_gold.height = 20;
		_gold.width = 80;
		_gold.y = 140;
		addChild(_gold);
		
		_fx = new Sprite();
		addChild(_fx);
		
		//load Anim
		
		_slashSheet = new Tilesheet(Assets.getBitmapData('img/slash.png'));
		_slashSheet.addTileRect(new Rectangle(0, 0, 240, 160));
		_slashSheet.addTileRect(new Rectangle(0, 160, 240, 160));
		_slashSheet.addTileRect(new Rectangle(0, 320, 240, 160));
		
	}
	
	public function hit(?skill:String = ""):Void {
		_indexSlash = 0;
		_slashSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
		Timer.delay(updateSlash, 80);
	}
	
	function updateSlash() 
	{
		_fx.graphics.clear();
		_indexSlash++;
		if (_indexSlash < 3) {
			_slashSheet.drawTiles(_fx.graphics, [0, 0, _indexSlash]);
			Timer.delay(updateSlash, 80);
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
			this.x = -2.5 + Math.random() *5;
			this.y = -2.5 + Math.random() *5;
			Timer.delay(shakeIt, 40);
		}else {
			this.x = 0;
			this.y = 0;
		}
	}
	
	public function setHp(currentHp:Int, maxHp:Int) {
		_hp.text = "HP : " + currentHp + "/" + maxHp;
	}
	
	public function setSp(currentSp:Int, maxSp:Int) {
		_sp.text = "SP : " + currentSp + "/" + maxSp;
	}
	
	public function setGold(gold:Int) {
		_gold.text = "Gold : " + gold;
	}
	
	public function setLevel(level:Int) {
		_level.text = "Level : " + level;
	}
	
	public function setXp(xp:Int, nextLevel:Int) {
		_xp.text = "Exp. : " + xp + "/" + nextLevel;
	}
	
}