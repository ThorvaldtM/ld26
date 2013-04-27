package com.ttermeer.ld26.interfaces;
import com.ttermeer.ld26.tools.AssetLoader;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.TextField;

/**
 * ...
 * @author Thorvald ter Meer
 */
class CombatLogWindow extends Sprite
{
	static public var ATTACK:String = "attack";
	static public var DEFEND:String = "defend";
	static public var SKILL:String = "skill";
	
	var _attackBtn:SimpleButton;
	var _defendBtn:SimpleButton;
	var _skillBtn:SimpleButton;
	var _log:TextField;

	public function new() 
	{
		super();
		
		_attackBtn = new SimpleButton(AssetLoader.loadGraphic('btn_attack_up', 80, 30), AssetLoader.loadGraphic('btn_attack_over', 80, 30), AssetLoader.loadGraphic('btn_attack_down', 80, 30), AssetLoader.loadGraphic('btn_attack_down', 80, 30));
		_attackBtn.addEventListener(MouseEvent.CLICK, dispatchAttack);
		addChild(_attackBtn);
		_defendBtn = new SimpleButton(AssetLoader.loadGraphic('btn_defend_up', 80, 30), AssetLoader.loadGraphic('btn_defend_over', 80, 30), AssetLoader.loadGraphic('btn_defend_down', 80, 30), AssetLoader.loadGraphic('btn_defend_down', 80, 30));
		_defendBtn.x = 80;
		_defendBtn.addEventListener(MouseEvent.CLICK, dispatchDefend);
		addChild(_defendBtn);
		_skillBtn = new SimpleButton(AssetLoader.loadGraphic('btn_skill_up', 80, 30), AssetLoader.loadGraphic('btn_skill_over', 80, 30), AssetLoader.loadGraphic('btn_skill_down', 80, 30), AssetLoader.loadGraphic('btn_skill_down', 80, 30));
		_skillBtn.x = 160;
		_skillBtn.addEventListener(MouseEvent.CLICK, dispatchSkill);
		addChild(_skillBtn);
		
		_log = new TextField();
		_log.width = 240;
		_log.height = 130;
		_log.y = 30;
		_log.selectable = false;
		_log.borderColor = 0x000000;
		_log.border = true;
		_log.backgroundColor = 0xdddddd;
		_log.background = true;
		_log.multiline = true;
		_log.wordWrap = true;
		addChild(_log);
		_attackBtn.enabled = false;
		_defendBtn.enabled = false;
		_skillBtn.enabled = false;
	}
	
	public function newEncounter(name:String) {
		updateText( "You encoutered a " + name + " !");
	}
	
	public function youTurn() {
		updateText( "It is your turn to act.");
		_attackBtn.enabled = true;
		_defendBtn.enabled = true;
		_skillBtn.enabled = true;
	}
	
	public function miss(?name:String = "") {
		if(name == ""){
			updateText("You missed");
			_attackBtn.enabled = false;
			_defendBtn.enabled = false;
			_skillBtn.enabled = false;
		}else {
			updateText(name + " missed");
		}
	}
	
	public function attack(dmg:Int, crit:Bool, ?name:String = "") {
		if(name == ""){
			if (crit) {
				updateText("You critical hit for " + dmg + " !");
			}else{
				updateText("You hit for " + dmg);
			}
			_attackBtn.enabled = false;
			_defendBtn.enabled = false;
			_skillBtn.enabled = false;
		}else {			
			if (crit) {
				updateText(name + " critical hit for " + dmg + " !");
			}else{
				updateText(name + " hit for " + dmg);
			}
		}
	}
	
	public function isStun(?name:String = "") {
		if(name == ""){
			updateText("You are stunned.");
			_attackBtn.enabled = false;
			_defendBtn.enabled = false;
			_skillBtn.enabled = false;
		}else {
			updateText(name + " is stunned.");
		}
	}
	
	public function custom(str:String) {
		updateText(str);
	}
	
	public function notEnoughSP() {
		updateText("You don't have enough SP to cast this skill.");
	}
	
	public function defend(sp:Int, ?name:String = "") {
		if(name == ""){
			updateText("You defend and recover " + sp + " SP(s).");
			_attackBtn.enabled = false;
			_defendBtn.enabled = false;
			_skillBtn.enabled = false;
		}else {
			updateText(name + " defend.");
		}
	}
	
	public function victory() {
		updateText("Victory !");
		_attackBtn.enabled = false;
		_defendBtn.enabled = false;
		_skillBtn.enabled = false;
	}
	
	public function dead() {
		updateText("You are dead. Game Over !");
	}
	
	function updateText(string:String) 
	{
		_log.appendText(string + "\n");
		
		//remove lines if we have more than 100
		var _logs:Array<String> = _log.text.split('\n');
		if (_logs.length > 100) {
			_logs.shift();
			_log.text = _logs.join('\n');
		}
		
		_log.scrollV = _log.maxScrollV; //This is to scroll down if we keep all text
	}
	
	private function dispatchAttack(e:MouseEvent):Void 
	{
		if(_attackBtn.enabled){
			dispatchEvent(new Event(ATTACK));
		}
	}
	
	private function dispatchDefend(e:MouseEvent):Void 
	{
		if(_defendBtn.enabled){
			dispatchEvent(new Event(DEFEND));
		}
	}
	
	private function dispatchSkill(e:MouseEvent):Void 
	{
		if(_skillBtn.enabled){
			dispatchEvent(new Event(SKILL));
		}
	}
	
}