package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.text.TextField;

/**
 * ...
 * @author Thorvald ter Meer
 */
class HeroWindow extends Sprite
{
	var _hero:DisplayObject;
	var _hp:TextField;
	var _sp:TextField;

	public function new(hero:DHero) 
	{
		super();
		_hero =  AssetLoader.loadGraphic(hero.graphic, 240, 160);
		addChild(_hero);
		
		_hp = new TextField();
		_hp.selectable = false;
		_hp.textColor = 0xFFFFFF;
		_hp.text = "HP : 100 / 100";
		_hp.height = 20;
		_hp.width = 120;
		_hp.y = 140;
		addChild(_hp);
		
		_sp = new TextField();
		_sp.selectable = false;
		_sp.textColor = 0xFFFFFF;
		_sp.text = "SP : 10 / 10";
		_sp.height = 20;
		_sp.width = 120;
		_sp.y = 140;
		_sp.x = _hp.width + _hp.x;
		addChild(_sp);
		
	}
	
	public function setHp(currentHp:Int, maxHp:Int) {
		_hp.text = "HP : " + currentHp + " / " + maxHp;
	}
	
	public function setSp(currentSp:Int, maxSp:Int) {
		_sp.text = "SP : " + currentSp + " / " + maxSp;
	}
	
}