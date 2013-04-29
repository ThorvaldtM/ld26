package com.ttermeer.ld26.system;
import nme.Assets;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;

/**
 * ...
 * @author Thorvald ter Meer
 */
class MusicManager
{
	private static var _instance:MusicManager;
	var _walk:Sound;
	var _fight:Sound;
	var _current:SoundChannel;
	var _walking:Bool;
	var _volume:Float = 0.5;


	public function new() 
	{
		_walk = Assets.getSound('sound/walk3.mp3');
		_fight = Assets.getSound('sound/fight.mp3');
	}
	
	public function playWalk() {
		if (_walking) {
			return;	
		}
		
		if (_current != null) {
			_current.stop();
		}
		_walking = true;
		_current = _walk.play(0,9999,new SoundTransform(_volume));
	}
	
	public function playFight() {
		if (_current != null) {
			_current.stop();
		}
		_walking = false;
		_current = _fight.play(0, 9999,new SoundTransform(_volume));
	}
	
	public function stop() {
		
		if (_current != null) {
			_current.stop();
		}
		_walking = false;
	}
	
	static function get_instance():MusicManager 
	{
		if (_instance == null) {
			_instance = new MusicManager();
		}
		return _instance;
	}
	
	static public var instance(get_instance, null):MusicManager;
	
	function get_volume():Float 
	{
		return _volume;
	}
	
	function set_volume(value:Float):Float 
	{
		if (value > 1) {
			value = 1;
		}else if(value < 0) {
			value = 0;
		}
		if (_current != null) {
			_current.soundTransform = new SoundTransform(value);
		}
		return _volume = value;
	}
	
	public var volume(get_volume, set_volume):Float;
	
}