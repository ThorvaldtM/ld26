package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.data.DArmor;
import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.data.DHero;
import com.ttermeer.ld26.data.DItem;
import com.ttermeer.ld26.data.DLoot;
import com.ttermeer.ld26.data.DMonster;
import com.ttermeer.ld26.data.DShrine;
import com.ttermeer.ld26.data.DSkill;
import com.ttermeer.ld26.data.DWeapon;
import com.ttermeer.ld26.system.MusicManager;
import haxe.Timer;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.events.Event;
import nme.media.Sound;
import nme.media.SoundTransform;

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
	var _stunCounter:Int = 0;
	var _poisontCounter:Int = 0;
	
	var _monsterHp:Int;
	var _monsterSp:Int;
	var _MonsterStunCounter:Int;
	var _MonsterDefense:Bool = false;
	var _itemPopup:ItemPopup;
	var _popup:DisplayObject;
	var _encounterCountdown:Int = 0;
	var _heroData:DHero;
	var _monsterPoisonCounter:Int;

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
			if (_MonsterStunCounter > 0) {
				_MonsterStunCounter--;
				_combat.isStun(_monster.currentMonster.name);
				yourTurn();
			}else{
				monsterTurn();
			}
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
			if (_inventory.currentSkill.sound != "") {
				var _snd:Sound = Assets.getSound('sound/' + _inventory.currentSkill.sound + '.wav');
				_snd.play(0,0,new SoundTransform(MusicManager.instance.volume));
			}
			switch(_inventory.currentSkill.id) {
				case 1 :
					if(_monster.currentMonster.immunity == 0){
						_combat.custom('You cast Mighty Blow and stun ' + _monster.currentMonster.name + ' for 2 turns.');
						_MonsterStunCounter = 1;
						_combat.isStun(_monster.currentMonster.name);
						yourTurn();
					}else {
						_combat.custom('You cast Mighty Blow but ' + _monster.currentMonster.name + " is immune !");
						monsterTurn();
					}
				case 2 :
					attack(_inventory.currentWeapon.value , Std.int(_monster.currentMonster.def / 2), true, _inventory.currentSkill);
				case 3 :
					attack(Std.int(Math.min(_level * 5,50)), 0, true, _inventory.currentSkill);
				case 5 :
					attack(Std.int(Math.min(_level * 10,200)), 0, true, _inventory.currentSkill);
				case 6 :
					attack(_level * 30 + 30, 0, true, _inventory.currentSkill);
				case 13 :
					attack(Std.int(_inventory.currentWeapon.value * 1.25), _monster.currentMonster.def, true, _inventory.currentSkill);
				case 7 :
					attack(_inventory.currentWeapon.value, _monster.currentMonster.def, true, _inventory.currentSkill);
				case 9 :
					if (_monster.currentMonster.immunity < 2) {
						_monsterPoisonCounter = 4;
						_combat.custom('You cast Poison on '+ _monster.currentMonster.name);
					}else {
						_combat.custom('You cast Poison but ' + _monster.currentMonster.name + " is immune !");
					}
					monsterTurn();
					
				case 14 :
					var _spDrain:Int = Std.int(Math.min(_monster.currentMonster.sp * 0.2, _monsterSp));
					_monsterSp -= _spDrain;
					_combat.custom('You cast Drain and removed ' + _spDrain +' SP(s) from your ennemy.');
					monsterTurn();
				case 4 :
					_hp += 80;
					if (_hp > _hpMax) {
						_hp = _hpMax;
					}
					_hero.setHp(_hp, _hpMax);
					_combat.custom('You cast Heal and regained 80 HPs.');
					monsterTurn();
				case 12 :
					_hp += 300;
					if (_hp > _hpMax) {
						_hp = _hpMax;
					}
					_hero.setHp(_hp, _hpMax);
					_combat.custom('You cast Heal and regained 300 HPs.');
					monsterTurn();
				case 11 :
					if (Math.random() < 0.1) {
						_combat.custom('You cast Death and killed ' +_monster.currentMonster.name + " !" );
						Timer.delay(victory, 160);
					}else {
						_combat.custom('You cast Death but failed.');
						monsterTurn();
					}
					
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
			yourTurn();
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
					yourTurn();
				}else{
					monsterTurn();
				}
			}else {
				yourTurn();
			}
		}else {
			//Critical ?
			var _value:Int = Std.int(Math.max(atk - def * ((you) ? ((_MonsterDefense) ? 2 : 1) : ((_defense) ? 2 : 1)), 1));
			var _crit:Bool = false;
			if (Math.random() < 0.1 || (skill != null && skill.id == 7)) {
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
						yourTurn();
					}else{
						monsterTurn();
					}
				}
			}else {
				_monster.attack();
				if(_crit){
					_hero.criticalHit((skill == null) ? "" : skill.fx);
				}else {
					_hero.hit((skill == null) ? "" : skill.fx);
				}
				_defense = false;
				_hp -= _value;
				if (_hp < 1) {
					//you are dead, Game Over
					gameOver();
				}else {
					_hero.setHp(_hp, _hpMax);
					yourTurn();
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
		
		if (_monsterPoisonCounter > 0) {
			_monsterPoisonCounter--;
			var _value:Int = Std.int(_monster.currentMonster.hp * 0.1);
			_combat.custom(_monster.currentMonster.name + ' is poisoned and loose ' + _value + " HP(s)." );
			_monsterHp -= _value;
			if (_monsterHp < 1) {
				//monster is dead !
				Timer.delay(victory, 160);
				return;
			}
			_monster.setHp(_monsterHp);
		}
	
		
		if (_MonsterStunCounter == 0 && _monster.currentMonster.skillRatio > 0 && Math.random() < _monster.currentMonster.skillRatio) {
			//have enough MP ?
			var _skill:DSkill = DataManager.instance.getSkill(_monster.currentMonster.skill);
			if (_skill.sp >= _monsterSp) {
				//cast skill
				_monsterSp -= _skill.sp;
				if (_skill.sound != "") {
					var _snd:Sound = Assets.getSound('sound/' + _skill.sound + '.wav');
					_snd.play(0,0,new SoundTransform(MusicManager.instance.volume));
				}
				switch(_skill.id) {
					case 1 :
						_combat.custom(_monster.currentMonster.name + ' cast Mighty Blow and stun you for 2 turns.');
						_stunCounter = 1;
						_combat.isStun();
						monsterTurn();
					case 2 :
						attack(_monster.currentMonster.atk , Std.int( _inventory.currentArmor.value / 2), false, _skill);
					case 3 :
						attack(Std.int(Math.min(_monster.currentMonster.level * 5,50)), 0, true, _skill);
					case 5 :
						attack(Std.int(Math.min(_monster.currentMonster.level * 10,200)), 0, true, _skill);
					case 6 :
						attack(_monster.currentMonster.level * 30 + 30, 0, false, _skill);
					case 13 :
						attack(Std.int(_monster.currentMonster.atk * 1.25), _inventory.currentArmor.value, false, _skill);
					case 7 :
						attack(_monster.currentMonster.atk, _inventory.currentArmor.value, false, _skill);
					case 9 :
						_poisontCounter = 4;
						_combat.custom(_monster.currentMonster.name + ' cast Poison on you.');
						yourTurn();
						
					case 14 :
						var _spDrain:Int = Std.int(Math.min(_spMax * 0.2, _sp));
						_sp -= _spDrain;
						_hero.setSp(_sp, _spMax);
						_combat.custom(_monster.currentMonster.name + ' cast Drain and removed ' + _spDrain +' SP(s) from you.');
						yourTurn();
					case 4 :
						_monsterHp += 80;
						if (_monsterHp > _monster.currentMonster.hp) {
							_monsterHp = _monster.currentMonster.hp;
						}
						_monster.setHp(_monsterHp);
						_combat.custom(_monster.currentMonster.name + ' cast Heal and regained 80 HPs.');
						yourTurn();
					case 12 :
						_monsterHp += 300;
						if (_monsterHp > _monster.currentMonster.hp) {
							_monsterHp = _monster.currentMonster.hp;
						}
						_monster.setHp(_monsterHp);
						_combat.custom(_monster.currentMonster.name + ' cast Heal and regained 300 HPs.');
						yourTurn();
					case 11 :
						if (Math.random() < 0.1) {
							_combat.custom(_monster.currentMonster.name + ' cast Death and you died !' );
							Timer.delay(gameOver, 160);
						}else {
							_combat.custom(_monster.currentMonster.name + ' cast Death but failed.');
							yourTurn();
						}
						
				}
				
				
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
	
	function gameOver() 
	{		
		_hero.setHp(0, _hpMax);
		_combat.dead();
		var _popup:GameOver = new GameOver();
		_popup.addEventListener('restart', dispatchRestart);
		_popup.x = 120;
		_popup.y = 20;
		addChild(_popup);
	}
	
	function yourTurn() 
	{
		if (_poisontCounter > 0) {
			_poisontCounter--;
			var _value:Int = Std.int(_hpMax * 0.1);
			_combat.custom('You are poisoned and loose ' + _value + " HP(s)." );
			_hp -= _value;
			if (_hp < 1) {
				//monster is dead !
				Timer.delay(gameOver, 160);
				return;
			}else {
				_hero.setHp(_hp, _hpMax);
			}
		}
		
		if (_stunCounter > 0) {
			_stunCounter--;
			_combat.isStun();
			monsterTurn();
			return;
		}
		
		_combat.youTurn();
	}
	
	function victory():Void 
	{
		_encounterCountdown = 3;
		_monster.setHp(0);
		_combat.victory(_monster.currentMonster.xp);
		addXp( _monster.currentMonster.xp);
		
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
		MusicManager.instance.playWalk();
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
		if (Math.random() < 0.12) {
			//special event
			if (Math.random() < 0.4) {
				//shrine event
				_combat.custom('You found a shrine !');
				_popup = new ShrineWindow(DataManager.instance.shrineList[Std.int(Math.random() * DataManager.instance.shrineList.length )]);
				_popup.x = 120;
				_popup.y = 20;
				_popup.addEventListener(ShrineWindow.PRAY, perfomPray);
				_popup.addEventListener(ShrineWindow.LEAVE, performLeave);
				addChild(_popup);
				
			}else {
				//merchant event
				_combat.custom('You found a merchant !');
				
				//look for an item we can wear
				var _slot:Int = Std.int(Math.random() * 3) + 1;
				var _item:DItem = null;
				switch(_slot) {
					case DItem.WEAPON :
						_item = DataManager.instance.weaponList[Std.int(Math.random() * DataManager.instance.weaponList.length )];
						while ( Lambda.indexOf(_heroData.weapons, _item.type) == -1) {
							_item = DataManager.instance.weaponList[Std.int(Math.random() * DataManager.instance.weaponList.length )];
						}
					case DItem.ARMOR :
						_item = DataManager.instance.armorList[Std.int(Math.random() * DataManager.instance.armorList.length )];
						while ( Lambda.indexOf(_heroData.armors, _item.type) == -1) {
							_item = DataManager.instance.armorList[Std.int(Math.random() * DataManager.instance.armorList.length )];
						}
					case DItem.SKILL :
						_item = DataManager.instance.skillList[Std.int(Math.random() * DataManager.instance.skillList.length )];
						while ( Lambda.indexOf(_heroData.skills, _item.type) == -1) {
							_item = DataManager.instance.skillList[Std.int(Math.random() * DataManager.instance.skillList.length )];
						}
						
				}
				
				_popup = new MerchantWindow(_item);
				_popup.x = 120;
				_popup.y = 20;
				_popup.addEventListener(MerchantWindow.BUY, performBuy);
				_popup.addEventListener(MerchantWindow.LEAVE, performLeave);
				addChild(_popup);
			}
		}else {
			MusicManager.instance.playFight();
			_MonsterStunCounter = 0;
			_monsterPoisonCounter = 0;
			_stunCounter = 0;
			_poisontCounter = 0;
			
			var _allowedRarity:Int =  Std.int( Math.random() * 10) + 1;
			var _allowedLevel:Int = _level;
			if (Math.random() < 0.1) {
				//We found a monster of higher level
				_allowedLevel += 1 + Std.int( Math.random() * 2);
			}else if (Math.random() < 0.2) {
				//we found a low level monster
				_allowedLevel = Std.int(Math.random() * _level) + 1;
			}else {
				_allowedLevel = _level + Std.int(Math.random() * 3) - 1;
			}
			if (_allowedLevel < 1) {
				_allowedLevel = 1;
			}
			
			var _monsterData:DMonster = null;
			for (monsterData in DataManager.instance.monsterList) {
				if (monsterData.rarity <= _allowedRarity && monsterData.level <= _allowedLevel) {
					_monsterData = monsterData;
				}
			}
			
			_monster.currentMonster = _monsterData;
			
			_monsterHp = _monster.currentMonster.hp;
			_combat.newEncounter(_monster.currentMonster.name);
			if(Math.random() < 0.5){
				yourTurn();
			}else {
				monsterRealTurn();
			}
		}
	}
	
	private function performBuy(e:Event):Void 
	{
		if (_popup != null) {
			var _item:DItem = cast(_popup, MerchantWindow).item;
			if (_item.gold * 10 <= _gold) {
				_gold -= _item.gold * 10;
				
				var _old:DItem = null;
				switch(_item.slot) {
					
					case DItem.WEAPON :
						_old = _inventory.currentWeapon;
						_inventory.currentWeapon = cast(_item,DWeapon);
					case DItem.ARMOR :
						_old = _inventory.currentArmor;
						_inventory.currentArmor =  cast(_item,DArmor);
					case DItem.SKILL :
						_old = _inventory.currentSkill;
						_inventory.currentSkill =  cast(_item,DSkill);
				}
				_gold += _old.gold;
				_hero.setGold(this._gold);
				_combat.custom('You equipped ' + _item.name + '.' );
				_combat.custom('You sold ' + _old.name + ' for ' + _old.gold + ' gold(s).' );
				
			}else {
				_combat.custom('Unfortunately you could not afford it.');
			}
			
			removeChild(_popup);
			_popup = null;
			move();
		}
		
	}
	
	private function performLeave(e:Event):Void 
	{
		if (_popup != null) {			
			removeChild(_popup);
			_popup = null;
			move();
		}
	}
	
	private function perfomPray(e:Event):Void 
	{
		if (_popup != null) {
			var _shrine:DShrine = cast(_popup, ShrineWindow).shrine;
			var _value:Int;
			switch(_shrine.id) {
				case 1:
					var _nextLevel:Int = _level * _level * 50;
					_value = Math.floor(_nextLevel * 0.1);
					_combat.custom('You prayed and gained ' + _value + ' experience point(s).');
					addXp(_value);
				case 2:
					var _nextLevel:Int = _level * _level * 50;
					_value = Math.floor(_nextLevel * 0.1);
					_combat.custom('You prayed and lost ' + _value + ' experience point(s).');
					addXp(-_value);
				case 3:
					_hpMax += 5;
					_hp += 5;
					_hero.setHp(_hp, _hpMax);
					_combat.custom('You prayed and increased your HP by 5.');
				case 4:
					_sp += 2;
					_spMax += 2;
					_hero.setSp(_sp, _spMax);
					_combat.custom('You prayed and increased your SP by 2.');
				case 6:
					_hpMax += 15;
					_hp += 15;
					_hero.setHp(_hp, _hpMax);
					_spMax -= Std.int(2 + Math.random() * 4);
					if (_spMax < 0)
					{
						_spMax = 0;
					}
					if (_sp > _spMax) {
						_sp = _spMax;
					}
					_hero.setSp(_sp, _spMax);
					_combat.custom('You prayed and increased your HP by 15 but lost some SP.');
				case 5:
					_spMax += 5;
					_sp += 5;
					_hero.setSp(_sp, _spMax);
					_hpMax -= Std.int(5 + Math.random() * 12);
					if (_hpMax < 1)
					{
						_hpMax = 1;
					}
					if (_hp > _spMax) {
						_hp = _spMax;
					}
					_hero.setHp(_hp, _hpMax);
					_combat.custom('You prayed and increased your SP by 5 but lost some HP.');
				case 7:
					
					var _item:DSkill = DataManager.instance.skillList[Std.int(Math.random() * DataManager.instance.skillList.length )];
					while ( Lambda.indexOf(_heroData.skills, _item.type) == -1) {
						_item = DataManager.instance.skillList[Std.int(Math.random() * DataManager.instance.skillList.length )];
					}
					_inventory.currentSkill = _item;
					_combat.custom('You prayed and obtained a new skill.');
				case 8:
					_gold += 50;
					_hero.setGold(_gold);
					_combat.custom('You prayed and gained 50 Golds.');
			}
			
			removeChild(_popup);
			_popup = null;
			move();
		}
		
	}
	
	function addXp(xpGained:Int):Void 
	{
		_xp += xpGained;
		if (_xp < 0) {
			_xp = 0;
		}
		//did we level up ?
		var _nextLevel:Int = _level * _level * 50;
		if (_xp >= _nextLevel) {
			//level up
			_xp -= _nextLevel;
			_level++;
			_nextLevel = _level * _level * 50;
			_hero.setLevel(_level);
			_hp = _hpMax = Std.int(Math.floor(_hpMax * 1.1));
			_sp = _spMax = Std.int(Math.floor(_spMax * 1.2));
			_hero.setHp(_hp, _hpMax);
			_hero.setSp(_sp, _spMax);
			_combat.custom('Congratulation ! You are now level '+ _level  +'.');
		}
		_hero.setXp(_xp, _nextLevel);
	}
	
}