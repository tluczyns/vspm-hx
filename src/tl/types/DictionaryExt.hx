package tl.types;

import haxe.Constraints.Function;
import flash.utils.Proxy;
import flash.utils.Dictionary;


class DictionaryExt extends Proxy {
	public var length(get, never):Int;

	
	private var funcSort:Function;
	public var dictionary:Dictionary;
	private var _arrNameProp:Array<Dynamic>;
	
	public function new(funcSort:Function = null) {
		super();
		this.dictionary = new Dictionary();
		this._arrNameProp = new Array<Dynamic>();
		this.funcSort = funcSort;
	}
	
	override private function getProperty(name:Dynamic):Dynamic {
		return this.dictionary[name];
	}
	
	override private function setProperty(name:Dynamic, value:Dynamic):Void {
		if ((value != null) && (this.dictionary[name] == null)) {
			this._arrNameProp.push(name);
		}
		else if ((value == null) && (this.dictionary[name] != null)) {
			this._arrNameProp.splice(this._arrNameProp.indexOf(name), 1);
		}
		if (this.funcSort != null) {
			this._arrNameProp.sort(this.funcSort);
		}
		this.dictionary[name] = value;
	}
	
	override private function callProperty(name:Dynamic, rest:Array<Dynamic> = null):Dynamic {
		return Std.string(name);
	}
	
	//klasa DictionaryExt (w przeciwieństwie do klasy Dictionary) w pętli for..in wyświetla elementy w kolejności takiej jakiej zostały dodane do słownika (a w klasie Dictionary jest losowa kolejność)
	override private function nextNameIndex(index:Int):Int {
		if (index < this._arrNameProp.length) {
			return as3hx.Compat.parseInt(index + 1);
		}
		else {
			return 0;
		}
	}
	
	override private function nextName(index:Int):String {
		return this._arrNameProp[index - 1];
	}
	
	override private function nextValue(index:Int):Dynamic {
		return this[this._arrNameProp[index - 1]];
	}
	
	private function get_length():Int {
		return this._arrNameProp.length;
	}
}

