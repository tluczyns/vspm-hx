package tl.types;

import haxe.Constraints.Function;
import tl.types.DictionaryExt;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import com.adobe.crypto.MD5;
import tl.other.Tricks;
import flash.events.EventDispatcher;
import flash.events.Event;
import tl.vspm.EventModel;
import flash.utils.Proxy;

class DictEventDispatcher extends DictionaryExt implements IEventDispatcher {
	
	private var _dictDescriptionEventListener:Dictionary;
	
	public function new() {
		super();
		this._dictDescriptionEventListener = new Dictionary();
	}
	
	public function addEventListener(type:String, func:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		this._dictDescriptionEventListener[MD5.hash(type + Tricks.getFunctionName2(func))] = new DescriptionEventListener(type, func, priority);
		for (dispatcher/* AS3HX WARNING could not determine type for var: dispatcher exp: EIdent(this) type: null */ in this) {
			dispatcher.addEventListener(type, func, false, priority);
		}
	}
	
	public function removeEventListener(type:String, func:Function, useCapture:Bool = false):Void {
		;
		for (dispatcher/* AS3HX WARNING could not determine type for var: dispatcher exp: EIdent(this) type: null */ in this) {
			dispatcher.removeEventListener(type, func);
		}
	}
	
	public function dispatchEvent(event:Event):Bool {
		for (dispatcher/* AS3HX WARNING could not determine type for var: dispatcher exp: EIdent(this) type: null */ in this) {
			dispatcher.dispatchEvent(event);
		}
		return true;
	}
	
	//if name == "" then dispatch on all dispatchers
	public function dispatchEventModel(type:String, data:Dynamic = null, name:Dynamic = null):Void {
		if (name != null) {
			if (Reflect.field(this, Std.string(name)) != null) {
				cast((Reflect.field(this, Std.string(name))), EventDispatcher).dispatchEvent(new EventModel(type, data));
			}
		}
		else {
			for (dispatcher/* AS3HX WARNING could not determine type for var: dispatcher exp: EIdent(this) type: null */ in this) {
				dispatcher.dispatchEvent(new EventModel(type, data));
			}
		}
	}
	
	public function hasEventListener(type:String):Bool
	//to do {
		
		return false;
	}
	
	public function willTrigger(type:String):Bool
	//to do {
		
		return false;
	}
	
	override private function deleteProperty(name:Dynamic):Bool
	//(name: String) {
		
		var value:EventDispatcher = Reflect.field(this, Std.string(name));
		if (value != null) {
			for (descriptionEventListener/* AS3HX WARNING could not determine type for var: descriptionEventListener exp: EField(EIdent(this),_dictDescriptionEventListener) type: null */ in this._dictDescriptionEventListener) {
				value.removeEventListener(descriptionEventListener.type, descriptionEventListener.func);
			}
		}
		return super.deleteProperty(name);
	}
	
	override private function setProperty(name:Dynamic, value:Dynamic):Void
	//(name: String , value: EventDispatcher): void { {
		
		if (value == null) {
			;
		}
		else {
			for (descriptionEventListener/* AS3HX WARNING could not determine type for var: descriptionEventListener exp: EField(EIdent(this),_dictDescriptionEventListener) type: null */ in this._dictDescriptionEventListener) {
				value.addEventListener(descriptionEventListener.type, descriptionEventListener.func, false, descriptionEventListener.priority);
			}
		}
		super.setProperty(name, value);
	}
	
	override private function nextValue(index:Int):Dynamic {
		return this.dictionary[this.nextName(index)];
	}
}



class DescriptionEventListener extends Dynamic {
	
	public var type:String;
	public var func:Function;
	public var priority:Int;
	
	public function new(type:String, func:Function, priority:Int) {
		super();
		this.type = type;
		this.func = func;
		this.priority = priority;
	}
}