package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.data.DSkill;
import flash.events.Event;
import nme.display.Sprite;

/**
 * ...
 * @author Thorvald ter Meer
 */
class Game extends Sprite
{
	var _hero:HeroWindow;
	var _monster:MonsterWindow;
	var _inventory:InventoryWindow;
	var _combat:CombatLogWindow;
	
	var _hpMax:Int = 100;
	var _hp:Int = 100;
	var _spMax:Int = 10;
	var _sp:Int = 10;
	var _defense:Bool = false;
	
	var _monsterHp:Int;
	var _monsterSp:Int;
	var _MonsterStunCounter:Int;
	var _MonsterDefense:Bool = false;
	var _itemPopup:ItemPopup;

	public function new(hero:DHero) 
	{
		super();
		
		_hero = new HeroWindow(hero);
		addChild(_hero);
		_monster = new MonsterWindow();
		_monster.x = 240;
		addChild(_monster);
		_inventory = new InventoryWindow();
		_inventory.y = 160;
		addChild(_inventory);
		_combat = new CombatLogWindow();
		_combat.x = 240;
		_combat.y = 160;
		_combat.addEventListener(CombatLogWindow.ATTACK, performAttack);
		_combat.addEventListener(CombatLogWindow.DEFEND, performDefend);
		_combat.addEventListener(CombatLogWindow.SKILL, performSkill);
		addChild(_combat);
		
		_inventory.currentWeapon = DataManager.instance.getWeapon(hero.defaultWeapon);
		_inventory.currentArmor = DataManager.instance.getArmor(hero.defaultArmor);
		_inventory.currentSkill = DataManager.instance.getSkill(hero.defaultSkill);
		
		_monster.currentMonster = DataManager.instance.monsterList[0];
		_monsterHp = _monster.currentMonster.hp;
		_monsterSp = _monster.currentMonster.sp;
		_combat.newEncounter(_monster.currentMonster.name);
		_combat.youTurn();
	}
	
	private function performSkill(e:Event):Void 
	{
		if (_sp < _inventory.currentSkill.sp) {
			//not enough SP
			_combat.notEnoughSP();
		}else {
			_sp -= _inventory.currentSkill.sp;
			_hero.setSp(_sp, _spMax);
			switch(_inventory.currentSkill.id) {
				case 1 :
					_combat.custom('You cast Mighty Blow and stun ' + _monster.currentMonster.name + ' for 2 turns');
					_MonsterStunCounter = 1;
					_combat.isStun(_monster.currentMonster.name);
					_combat.youTurn();
			}
			_MonsterDefense = false;
		}
	}
	
	private function performDefend(e:Event):Void 
	{
		_MonsterDefense = false;
		_defense = true;
		var _value:Int  = Math.floor(_spMax * 0.2 * (0.8 + Math.random() * 0.4));
		_sp = Std.int(Math.min(_sp + _value, _spMax));
		_hero.setSp(_sp, _spMax);
		_combat.defend(_value);
		if (_MonsterStunCounter > 0) {
			_MonsterStunCounter--;
			_combat.isStun(_monster.currentMonster.name);
			_combat.youTurn();
		}else{
			monsterTurn();
		}
	}
	
	private function performAttack(e:Event):Void 
	{
		attack(_inventory.currentWeapon.value, _monster.currentMonster.def, true);
	}
	
	private function attack(atk:Int, def:Int, ?you:Bool = false) {
	
		//Check if we miss
		if (Math.random() < 0.1) {
			//we missed
			_combat.miss((you) ? "" : _monster.currentMonster.name);
			if(you){
				if (_MonsterStunCounter > 0) {
					_MonsterStunCounter--;
					_combat.isStun(_monster.currentMonster.name);
					_combat.youTurn();
				}else{
					monsterTurn();
				}
			}else {
				_combat.youTurn();
			}
		}else {
			//Critical ?
			var _value:Int = Std.int(Math.max(atk - def * ((you) ? ((_MonsterDefense) ? 2 : 1) : ((_defense) ? 2 : 1)), 1));
			var _crit:Bool = false;
			if (Math.random() < 0.1) {
				//we have a critical hit
				_value = Math.floor( _value * 1.75);
				_crit = true;
			}
			
			//randomized the value
			_value = Math.round(_value * (0.8 + Math.random() * 0.4));
			_combat.attack(_value, _crit, (you) ? "" : _monster.currentMonster.name );
			if (you) {
				_MonsterDefense = false;
				_monsterHp -= _value;
				if (_monsterHp < 1) {
					//monster is dead !
					victory();
				}else {
					_monster.setHp(_monsterHp);
					if (_MonsterStunCounter > 0) {
						_MonsterStunCounter--;
						_combat.isStun(_monster.currentMonster.name);
						_combat.youTurn();
					}else{
						monsterTurn();
					}
				}
			}else {
				_defense = false;
				_hp -= _value;
				if (_hp < 1) {
					//you are dead, Game Over
					_hero.setHp(0, _hpMax);
					_combat.dead();
				}else {
					_hero.setHp(_hp, _hpMax);
					_combat.youTurn();
				}
			}
		}	
	}
	
	function monsterTurn() 
	{
		if (_monster.currentMonster.skillRatio > 0 && Math.random() < _monster.currentMonster.skillRatio) {
			//have enough MP ?
			var _skill:DSkill = DataManager.instance.getSkill(_monster.currentMonster.skill);
			if (_skill.sp >= _monsterSp) {
				//cast skill
				return;
			}			
		}
		
		if (_monster.currentMonster.defRatio > 0 && Math.random() < _monster.currentMonster.defRatio) {
			_defense = false;
			_MonsterDefense = true;
			var _value:Int  = Math.floor(_monster.currentMonster.sp * 0.2 * (0.8 + Math.random() * 0.4));
			_monsterSp = Std.int(Math.min(_monsterSp + _value, _monster.currentMonster.sp));
			_combat.defend(_value, _monster.currentMonster.name);
			_combat.youTurn();
		}else{
			attack(_monster.currentMonster.atk, _inventory.currentArmor.value);
		}
	}
	
	function victory():Void 
	{
		_monster.setHp(0);
		_combat.victory();
		
		//determine loots
		for ( _loot in _monster.currentMonster.loots) {
			if (Math.random() < _loot.ratio) {
				//we drop the item.
				_itemPopup = new ItemPopup(_loot);
				_itemPopup.x = 120;
				_itemPopup.y = 20;
				addChild(_itemPopup);
				return;
			}
		}
		newEncounter();
	}
	
	function newEncounter() 
	{	
		//_monster.currentMonster = DataManager.instance.monsterList[Std.int(Math.random() * DataManager.instance.monsterList.length )];
		_monster.currentMonster = DataManager.instance.monsterList[0];
		_monsterHp = _monster.currentMonster.hp;
		_combat.newEncounter(_monster.currentMonster.name);
		_combat.youTurn();
	}
	
}