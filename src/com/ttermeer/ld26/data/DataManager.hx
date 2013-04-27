package com.ttermeer.ld26.data;
import haxe.xml.Fast;
import nme.Assets;

/**
 * ...
 * @author Thorvald ter Meer
 */
class DataManager
{
	private static var _instance:DataManager;
	private var _heroList:Array<DHero>;
	private var _weaponList:Array<DWeapon>;
	private var _armorList:Array<DArmor>;
	private var _skillList:Array<DSkill>;
	private var _monsterList:Array<DMonster>;

	public function new() 
	{
		composeHero();
		composeWeapon();
		composeArmor();
		composeSkill();
		composeMonster();
	}
	
	function composeHero() 
	{
		var _xml:Xml = Xml.parse(Assets.getText('data/hero.xml'));
		var _fast:Fast = new Fast(_xml.firstElement());
		_heroList = new Array<DHero>();
		for ( _hero in _fast.nodes.hero) {
			var _heroData:DHero = new DHero();
			_heroData.id = Std.parseInt(_hero.node.id.innerData);
			_heroData.name = _hero.node.name.innerData;
			_heroData.graphic = _hero.node.graphic.innerData;
			_heroData.defaultWeapon = Std.parseInt(_hero.node.defaults.node.weapon.innerData);
			_heroData.defaultArmor = Std.parseInt(_hero.node.defaults.node.armor.innerData);
			_heroData.defaultSkill = Std.parseInt(_hero.node.defaults.node.skill.innerData);
			_heroList.push(_heroData);
		}
	}
	
	function composeWeapon() 
	{
		var _xml:Xml = Xml.parse(Assets.getText('data/weapon.xml'));
		var _fast:Fast = new Fast(_xml.firstElement());
		_weaponList = new Array<DWeapon>();
		for ( _weapon in _fast.nodes.weapon) {
			var _weaponData:DWeapon = new DWeapon();
			_weaponData.id = Std.parseInt(_weapon.node.id.innerData);
			_weaponData.name = _weapon.node.name.innerData;
			_weaponData.graphic = _weapon.node.graphic.innerData;
			_weaponData.value = Std.parseInt(_weapon.node.value.innerData);
			_weaponList.push(_weaponData);
		}
	}
	
	function composeArmor() 
	{
		var _xml:Xml = Xml.parse(Assets.getText('data/armor.xml'));
		var _fast:Fast = new Fast(_xml.firstElement());
		_armorList = new Array<DArmor>();
		for ( _armor in _fast.nodes.armor) {
			var _armorData:DArmor = new DArmor();
			_armorData.id = Std.parseInt(_armor.node.id.innerData);
			_armorData.name = _armor.node.name.innerData;
			_armorData.graphic = _armor.node.graphic.innerData;
			_armorData.value = Std.parseInt(_armor.node.value.innerData);
			_armorList.push(_armorData);
		}
	}
	
	function composeSkill() 
	{
		var _xml:Xml = Xml.parse(Assets.getText('data/skill.xml'));
		var _fast:Fast = new Fast(_xml.firstElement());
		_skillList = new Array<DSkill>();
		for ( _skill in _fast.nodes.skill) {
			var _skillData:DSkill = new DSkill();
			_skillData.id = Std.parseInt(_skill.node.id.innerData);
			_skillData.name = _skill.node.name.innerData;
			_skillData.graphic = _skill.node.graphic.innerData;
			_skillData.sp = Std.parseInt(_skill.node.sp.innerData);
			_skillList.push(_skillData);
		}
	}
	
	function composeMonster() 
	{
		var _xml:Xml = Xml.parse(Assets.getText('data/monster.xml'));
		var _fast:Fast = new Fast(_xml.firstElement());
		_monsterList = new Array<DMonster>();
		for ( _monster in _fast.nodes.monster) {
			var _monsterData:DMonster = new DMonster();
			_monsterData.id = Std.parseInt(_monster.node.id.innerData);
			_monsterData.name = _monster.node.name.innerData;
			_monsterData.graphic = _monster.node.graphic.innerData;
			_monsterData.hp = Std.parseInt(_monster.node.hp.innerData);
			_monsterData.sp = Std.parseInt(_monster.node.sp.innerData);
			_monsterData.atk = Std.parseInt(_monster.node.atk.innerData);
			_monsterData.def = Std.parseInt(_monster.node.def.innerData);
			_monsterData.skill = Std.parseInt(_monster.node.skill.innerData);
			_monsterData.defRatio = Std.parseFloat(_monster.node.defRatio.innerData);
			_monsterData.skillRatio = Std.parseFloat(_monster.node.skillRatio.innerData);
			for ( _loot in _monster.node.loots.nodes.loot) {
				var _lootData:DLoot = new DLoot();
				_lootData.id = Std.parseInt(_loot.node.id.innerData);
				_lootData.type = Std.parseInt(_loot.node.type.innerData);
				_lootData.ratio = Std.parseFloat(_loot.node.ratio.innerData);
				_monsterData.loots.push(_lootData);
			}
			
			_monsterList.push(_monsterData);
		}
	}
	
	public function getWeapon(id:Int):DWeapon {
		for ( _weapon in _weaponList) {
			if (_weapon.id == id) {
				return _weapon;
			}
		}
		return null;
	}
	
	public function getArmor(id:Int):DArmor {
		for ( _armor in _armorList) {
			if (_armor.id == id) {
				return _armor;
			}
		}
		return null;		
	}
	
	public function getSkill(id:Int):DSkill {		
		for ( _skill in _skillList) {
			if (_skill.id == id) {
				return _skill;
			}
		}
		return null;
	}
	
	static function get_instance():DataManager 
	{
		if (_instance == null) {
			_instance = new DataManager();
		}
		return _instance;
	}
	
	static public var instance(get_instance, null):DataManager;
	
	function get_heroList():Array<DHero> 
	{
		return _heroList;
	}
	
	public var heroList(get_heroList, null):Array<DHero>;
	
	function get_weaponList():Array<DWeapon> 
	{
		return _weaponList;
	}
	
	public var weaponList(get_weaponList, null):Array<DWeapon>;
	
	function get_armorList():Array<DArmor> 
	{
		return _armorList;
	}
	
	public var armorList(get_armorList, null):Array<DArmor>;
	
	function get_skillList():Array<DSkill> 
	{
		return _skillList;
	}
	
	public var skillList(get_skillList, null):Array<DSkill>;
	
	function get_monsterList():Array<DMonster> 
	{
		return _monsterList;
	}
	
	public var monsterList(get_monsterList, null):Array<DMonster>;
	
}