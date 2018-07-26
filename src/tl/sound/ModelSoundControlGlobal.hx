package tl.sound;

import haxe.Constraints.Function;
import flash.utils.Dictionary;
import openfl.Vector;
import tl.so.SharedObjectInstance;

class ModelSoundControlGlobal extends ModelSoundControl {
	public static var levelVolumeGlobal(get, set):Float;
	public static var tweenLevelVolumeGlobal(get, set):Float;
	public static var isSoundOffOnGlobal(get, set):Int;
	
	private static var _instance:ModelSoundControlGlobal;
	
	private var dictModelSoundControl:Dictionary;
	
	public function new(vecNameModelSoundControl:Vector<String>, soName:String = "", stepChangeLevelVolume:Float = 0.05) {
		if (ModelSoundControlGlobal._instance == null) {
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
	
	private static function get_levelVolumeGlobal():Float {
		return ModelSoundControlGlobal._instance.levelVolume;
	}
	
	private static function set_levelVolumeGlobal(value:Float):Float {
		ModelSoundControlGlobal._instance.levelVolume = value;
		return value;
	}
	
	private static function get_tweenLevelVolumeGlobal():Float {
		return ModelSoundControlGlobal._instance.tweenLevelVolume;
	}
	
	private static function set_tweenLevelVolumeGlobal(value:Float):Float {
		ModelSoundControlGlobal._instance.tweenLevelVolume = value;
		return value;
	}
	
	private static function get_isSoundOffOnGlobal():Int {
		return ModelSoundControlGlobal._instance.isSoundOffOn;
	}
	
	private static function set_isSoundOffOnGlobal(value:Int):Int {
		ModelSoundControlGlobal._instance.isSoundOffOn = value;
		return value;
	}
	
	public static function addEventListenerGlobal(type:String, listener:Function):Void {
		ModelSoundControlGlobal._instance.addEventListener(type, listener);
	}
	
	public static function removeEventListenerGlobal(type:String, listener:Function):Void {
		ModelSoundControlGlobal._instance.removeEventListener(type, listener);
	}
	
	//
	
	public static function getModel(name:String = ""):ModelSoundControl {
		var model:ModelSoundControl;
		if (ModelSoundControlGlobal._instance == null) {
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

