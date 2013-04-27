package com.ttermeer.ld26;

import com.ttermeer.ld26.data.DataManager;
import com.ttermeer.ld26.interfaces.Game;
import com.ttermeer.ld26.interfaces.HeroSelect;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Thorvald ter Meer
 */

class Main extends Sprite 
{
	var inited:Bool;
	var _heroSelect:HeroSelect;
	var _game:Game;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");;
		
		startSelect();
	}
	
	private function startSelect(?e:Event) {
		if (_game != null) {
			removeChild(_game);
			_game = null;
		}
		
		_heroSelect = new HeroSelect();
		_heroSelect.addEventListener('game', startGame);
		addChild(_heroSelect);
	}

	
	private function startGame(e:Event):Void 
	{			
		removeChild(_heroSelect);
		_game = new Game(DataManager.instance.heroList[_heroSelect.index]);
		_heroSelect = null;
		_game.addEventListener('restart', startSelect);
		addChild(_game);
	
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
