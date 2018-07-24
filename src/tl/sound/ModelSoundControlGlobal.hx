package tl.sound;

import haxe.Constraints.Function;
import flash.utils.Dictionary;
import tl.so.SharedObjectInstance;

class ModelSoundControlGlobal extends ModelSoundControl {
	public static var levelVolume(get, set):Float;
	public static var tweenLevelVolume(get, set):Float;
	public static var isSoundOffOn(get, set):Int;

	
	private static var _instance:ModelSoundControlGlobal;
	
	private var dictModelSoundControl:Dictionary;
	
	public function new(vecNameModelSoundControl:Vector<String>, soName:String = "", stepChangeLevelVolume:Float = 0.05) {
		super();
		if (!ModelSoundControlGlobal._instance) {
			this.dictModelSoundControl = new Dictionary();
			var so:SharedObjectInstance;
			if (soName != "") {
				so = new SharedObjectInstance(soName);
			}
			super("", so, stepChangeLevelVolume, 1);
			var nameModelSoundControl:String;
			var maxLevelVolumeModelSoundControl:Float = [1, 0][as3hx.Compat.parseInt(vecNameModelSoundControl.length > 0)];
			for (i in 0...vecNameModelSoundControl.length) {
				nameModelSoundControl = vecNameModelSoundControl[i];
				this.dictModelSoundControl[nameModelSoundControl] = new ModelSoundControl(nameModelSoundControl, so, stepChangeLevelVolume, this.levelVolume);
				maxLevelVolumeModelSoundControl = Math.max(maxLevelVolumeModelSoundControl, this.dictModelSoundControl[nameModelSoundControl].levelVolume);
			}
			this.isSoundOffOn = as3hx.Compat.parseInt(maxLevelVolumeModelSoundControl > 0);
			ModelSoundControlGlobal._instance = this;
		}
	}
	
	override private function set_levelVolume(value:Float):Float {
		for (modelSoundControl/* AS3HX WARNING could not determine type for var: modelSoundControl exp: EField(EIdent(this),dictModelSoundControl) type: null */ in this.dictModelSoundControl) {
			modelSoundControl.levelVolume = value;
		}
		super.levelVolume = value;
		return value;
	}
	
	override private function set_tweenLevelVolume(value:Float):Float {
		for (modelSoundControl/* AS3HX WARNING could not determine type for var: modelSoundControl exp: EField(EIdent(this),dictModelSoundControl) type: null */ in this.dictModelSoundControl) {
			modelSoundControl.tweenLevelVolume = value;
		}
		super.tweenLevelVolume = value;
		return value;
	}
	
	//static access to global model
	
	private static function get_levelVolume():Float {
		return ModelSoundControlGlobal._instance.levelVolume;
	}
	
	private static function set_levelVolume(value:Float):Float {
		ModelSoundControlGlobal._instance.levelVolume = value;
		return value;
	}
	
	private static function get_tweenLevelVolume():Float {
		return ModelSoundControlGlobal._instance.tweenLevelVolume;
	}
	
	private static function set_tweenLevelVolume(value:Float):Float {
		ModelSoundControlGlobal._instance.tweenLevelVolume = value;
		return value;
	}
	
	private static function get_isSoundOffOn():Int {
		return ModelSoundControlGlobal._instance.isSoundOffOn;
	}
	
	private static function set_isSoundOffOn(value:Int):Int {
		ModelSoundControlGlobal._instance.isSoundOffOn = value;
		return value;
	}
	
	public static function addEventListener(type:String, listener:Function):Void {
		ModelSoundControlGlobal._instance.addEventListener(type, listener);
	}
	
	public static function removeEventListener(type:String, listener:Function):Void {
		ModelSoundControlGlobal._instance.removeEventListener(type, listener);
	}
	
	//
	
	public static function getModel(name:String = ""):ModelSoundControl {
		var model:ModelSoundControl;
		if (!ModelSoundControlGlobal._instance) {
			new ModelSoundControlGlobal(new Vector<String>());
		}
		if (name == "") {
			model = ModelSoundControlGlobal._instance;
		}
		else if (ModelSoundControlGlobal._instance) {
			model = ModelSoundControlGlobal._instance.dictModelSoundControl[name];
		}
		return model;
	}
}

