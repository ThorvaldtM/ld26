package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.data.DLoot;
import com.ttermeer.ld26.data.DMonster;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import haxe.Timer;
import nme.display.Sprite;
import nme.events.Event;

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
	var _gold:Int = 100;
	var _xp:Int = 0;
	var _level:Int = 1;
	
	var _monsterHp:Int;
	var _monsterSp:Int;
	var _MonsterStunCounter:Int;
	var _MonsterDefense:Bool = false;
	var _itemPopup:ItemPopup;
	var _encounterCountdown:Int = 0;
	var _heroData:DHero;

	public function new(hero:DHero) 
	{
		super();
		
		_heroData = hero;
		
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
		_combat.addEventListener(CombatLogWindow.FLEE, performFlee);
		addChild(_combat);
		
		_hpMax = _hp = hero.hp;
		_spMax = _sp = hero.sp;
		_hero.setHp(_hp, _hpMax);
		_hero.setSp(_sp, _spMax);
		_inventory.currentWeapon = DataManager.instance.getWeapon(hero.defaultWeapon);
		_inventory.currentArmor = DataManager.instance.getArmor(hero.defaultArmor);
		_inventory.currentSkill = DataManager.instance.getSkill(hero.defaultSkill);
		
		_combat.custom('You are looking for monsters in the area.' );
		move();
	}
	
	private function performFlee(e:Event):Void 
	{
		if (Math.random() < 0.3) {
			//failed to flee
			_combat.flee(false);
			_MonsterDefense = false;
			monsterTurn();
		}else {
			_encounterCountdown = 3;
			_combat.flee(true);
			move();
		}
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
				case 3 :
					attack(_level * 10 + 10, 0, true, _inventory.currentSkill);
					
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
	
	private function attack(atk:Int, def:Int, ?you:Bool = false, ?skill:DSkill) {
	
		//Check if we miss
		if (skill == null && Math.random() < 0.1) {
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
			_combat.attack(_value, _crit, (you) ? "" : _monster.currentMonster.name , (skill == null) ? "" : skill.name);
			if (you) {
				if(_crit){
					_monster.criticalHit((skill == null) ? "" : skill.fx);
				}else {
					_monster.hit((skill == null) ? "" : skill.fx);
				}
				_MonsterDefense = false;
				_monsterHp -= _value;
				if (_monsterHp < 1) {
					//monster is dead !
					Timer.delay(victory, 160);
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
				if(_crit){
					_hero.criticalHit((skill == null) ? "" : skill.fx);
				}else {
					_hero.hit((skill == null) ? "" : skill.fx);
				}
				_defense = false;
				_hp -= _value;
				if (_hp < 1) {
					//you are dead, Game Over
					_hero.setHp(0, _hpMax);
					_combat.dead();
					var _popup:GameOver = new GameOver();
					_popup.addEventListener('restart', dispatchRestart);
					_popup.x = 120;
					_popup.y = 20;
					addChild(_popup);
				}else {
					_hero.setHp(_hp, _hpMax);
					_combat.youTurn();
				}
			}
		}
	}
	
	private function dispatchRestart(e:Event):Void 
	{
		dispatchEvent(new Event('restart'));
	}
	
	function monsterTurn() 
	{
		Timer.delay(monsterRealTurn, 250);
	}
	
	function monsterRealTurn() {
		if (_monster.currentMonster.skillRatio > 0 && Math.random() < _monster.currentMonster.skillRatio) {
			//have enough MP ?
			var _skill:DSkill = DataManager.instance.getSkill(_monster.currentMonster.skill);
			if (_skill.sp >= _monsterSp) {
				//cast skill
				return;
			}			
		}
		
		//if (_monster.currentMonster.defRatio > 0 && Math.random() < _monster.currentMonster.defRatio) {
			//_defense = false;
			//_MonsterDefense = true;
			//var _value:Int  = Math.floor(_monster.currentMonster.sp * 0.2 * (0.8 + Math.random() * 0.4));
			//_monsterSp = Std.int(Math.min(_monsterSp + _value, _monster.currentMonster.sp));
			//_combat.defend(_value, _monster.currentMonster.name);
			//_combat.youTurn();
		//}else{
			attack(_monster.currentMonster.atk, _inventory.currentArmor.value);
		//}	
	}
	
	function victory():Void 
	{
		_encounterCountdown = 3;
		_monster.setHp(0);
		_combat.victory(_monster.currentMonster.xp);
		_xp += _monster.currentMonster.xp;
		//did we level up ?
		var _nextLevel:Int = _level * _level * 100;
		if (_xp >= _nextLevel) {
			//level up
			_xp -= _nextLevel;
			_level++;
			_nextLevel = _level * _level * 100;
			_hero.setLevel(_level);
			_hp = _hpMax = Std.int(Math.floor(_hpMax * 1.2));
			_sp = _spMax = Std.int(Math.floor(_spMax * 1.2));
			_hero.setHp(_hp, _hpMax);
			_hero.setSp(_sp, _spMax);
			_combat.custom('Congratulation ! You are now level '+ _level  +'.');
		}
		_hero.setXp(_xp, _nextLevel);
		
		var _value:Int  = Math.round(_monster.currentMonster.gold * (0.8 + Math.random() * 0.4));
		if(_value > 0){
			this._gold += _value;
			_hero.setGold(this._gold);
			_combat.custom('You looted ' + _value + ' Gold(s).');
		}
		//determine loots
		for ( _loot in _monster.currentMonster.loots) {
			if (Math.random() < _loot.ratio) {
				//we drop the item.
				_itemPopup = new ItemPopup(_loot,_heroData);
				_itemPopup.x = 120;
				_itemPopup.y = 20;
				_itemPopup.addEventListener(ItemPopup.SALE, perfomSale);
				_itemPopup.addEventListener(ItemPopup.EQUIP, perfomEquip);
				addChild(_itemPopup);
				return;
			}
		}
		move();
	}
	
	private function perfomEquip(e:Event):Void 
	{
		if (_itemPopup != null) {
			var _loot = _itemPopup.loot;
			removeChild(_itemPopup);			
			_itemPopup = null;
			
			var _nameSold:String = "";
			var _nameEquip:String = "";
			var _gold:Int = 0;
			switch(_loot.type) {
				case DLoot.WEAPON :
					_nameSold = _inventory.currentWeapon.name;
					_gold = _inventory.currentWeapon.gold;
					_inventory.currentWeapon = DataManager.instance.getWeapon(_loot.id);
					_nameEquip = _inventory.currentWeapon.name;
				case DLoot.ARMOR :
					_nameSold = _inventory.currentArmor.name;
					_gold = _inventory.currentArmor.gold;
					_inventory.currentArmor = DataManager.instance.getArmor(_loot.id);
					_nameEquip = _inventory.currentArmor.name;
				case DLoot.SKILL :
					_nameSold = _inventory.currentSkill.name;
					_gold = _inventory.currentSkill.gold;
					_inventory.currentSkill = DataManager.instance.getSkill(_loot.id);
					_nameEquip = _inventory.currentSkill.name;
			}
			this._gold += _gold;
			_hero.setGold(this._gold);
			_combat.custom('You equipped ' + _nameEquip + '.' );
			_combat.custom('You sold ' + _nameSold + ' for ' + _gold + ' gold(s).' );
			move();
		}
	}
	
	private function perfomSale(e:Event):Void 
	{
		if (_itemPopup != null) {
			var _loot = _itemPopup.loot;
			removeChild(_itemPopup);			
			_itemPopup = null;
			
			var _name:String = "";
			var _gold:Int = 0;
			switch(_loot.type) {
				case DLoot.WEAPON :
					var _weapon:DWeapon = DataManager.instance.getWeapon(_loot.id);
					_name = _weapon.name;
					_gold = _weapon.gold;
				case DLoot.ARMOR :
					var _armor:DArmor = DataManager.instance.getArmor(_loot.id);
					_name = _armor.name;
					_gold = _armor.gold;
				case DLoot.SKILL :
					var _skill:DSkill = DataManager.instance.getSkill(_loot.id);
					_name = _skill.name;
					_gold = _skill.gold;
			}
			this._gold += _gold;
			_hero.setGold(this._gold);
			_combat.custom('You sold ' + _name + ' for ' + _gold + ' gold(s).' );
			
			move();
		}
	}
	
	function move() 
	{
		_monster.walkAnimation();
		Timer.delay(explore, 1000);
	}
	
	function explore() 
	{
		//determine if we make a new encounter
		if (Math.random() < 0.25 || _encounterCountdown <= 0) {
			newEncounter();
		}else {
			_encounterCountdown--;
			_combat.custom('You walked for 5 minutes and did not encounter anyone.' );
			var _valueHp:Int  = Math.floor(_hpMax * 0.1 * (0.8 + Math.random() * 0.3));
			var _valueSp:Int  = Math.floor(_spMax * 0.3 * (0.8 + Math.random() * 0.3));
			if (_hpMax == _hp && _spMax == _sp) {
				//nothing
			}else if (_hpMax == _hp) {
				_combat.custom('You recovered ' + _valueSp + " SP(s)." );
			}else if (_spMax == _sp) {
				_combat.custom('You recovered ' + _valueHp + " HP(s)." );
			}else  {
				_combat.custom('You recovered ' + _valueHp + " HP(s) and " + _valueSp + " SP(s)." );
			}
			_hp = Std.int(Math.min(_hp + _valueHp, _hpMax));
			_hero.setHp(_hp, _hpMax);
			_sp = Std.int(Math.min(_sp + _valueSp, _spMax));
			_hero.setSp(_sp, _spMax);
			Timer.delay(explore, 5000);
		}
	}
	
	function newEncounter() 
	{	
		_monster.stopWalkAnimation();
		
		var _allowedLevel:Int = Math.floor( _level + Math.random() * 6);		
		var _monsterData:DMonster = DataManager.instance.monsterList[Std.int(Math.random() * DataManager.instance.monsterList.length )];
		while (_monsterData.level > _allowedLevel) {
			_monsterData = DataManager.instance.monsterList[Std.int(Math.random() * DataManager.instance.monsterList.length )];
		}
		_monster.currentMonster = _monsterData;
		
		_monsterHp = _monster.currentMonster.hp;
		_combat.newEncounter(_monster.currentMonster.name);
		_combat.youTurn();
	}
	
}