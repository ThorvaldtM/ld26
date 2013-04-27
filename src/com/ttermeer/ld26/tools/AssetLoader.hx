package com.ttermeer.ld26.tools;
import haxe.Md5;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author Thorvald ter Meer
 */
class AssetLoader
{
	
	public static function loadGraphic(name:String, width:Int = 10, height:Int = 10):DisplayObject {
		var _result:DisplayObject;
		var _graphic:BitmapData = Assets.getBitmapData('img/' + name + '.png');
		if (_graphic == null) {
			var _hash:String = Md5.encode(name);
			var _color:Int = Std.parseInt('0x' + _hash.substr(0, 6));
			var _sprite:Sprite = new Sprite();
			_sprite.graphics.beginFill(_color);
			_sprite.graphics.drawRect(0, 0, width, height);
			_sprite.graphics.endFill();
			
			var _text:TextField = new TextField();
			_text.width = width;
			_text.y = height / 2 - 10;
			_text.text = name;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_sprite.addChild(_text);
			
			_result = _sprite;
		}else {
			_result = new Bitmap(_graphic);
		}
		
		
		return _result;
	}
	
}