package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DMonster;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.text.TextField;

/**
 * ...
 * @author Thorvald ter Meer
 */
class MonsterWindow extends Sprite
{
	private var _currentMonster:DMonster;
	private var _monster:DisplayObject;
	var _hp:TextField;

	public function new() 
	{
		super();
		
		_hp = new TextField();
		_hp.selectable = false;
		_hp.textColor = 0xFFFFFF;
		_hp.text = "HP : 100 / 100";
		_hp.height = 20;
		_hp.width = 240;
		_hp.y = 140;
		_hp.visible = false;
		addChild(_hp);
		
		walkAnimation();
	}
	
	function walkAnimation() 
	{
		//TODO ANIMATION
		if (_monster != null ) {
			_monster.visible =  false;
			_hp.visible = false;
		}
	}
	
	function stopWalkAnimation() 
	{
		
	}
	
	public function setHp(hp:Int) {
		_hp.text = "HP : " + hp + " / " + _currentMonster.hp;
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
		addChildAt(_monster,numChildren - 1);
		_hp.text = "HP : " + value.hp + " / " + value.hp;
		_hp.visible = true;
		return _currentMonster = value;
	}
	
	public var currentMonster(get_currentMonster, set_currentMonster):DMonster;
	
}