package tl.sound;

import flash.events.EventDispatcher;
import tl.so.SharedObjectInstance;
import tl.vspm.EventModel;
import caurina.transitions.Tweener;

class ModelSoundControl extends EventDispatcher {
	public var levelVolume(get, set):Float;
	public var tweenLevelVolume(get, set):Float;
	public var isSoundOffOn(get, set):Int;

	
	private var _levelVolume:Float = 1;
	private var _tweenLevelVolume:Float;
	private var _isSoundOffOn:Int = 1;
	
	private var name:String;
	private var so:SharedObjectInstance;
	private var stepChangeLevelVolume:Float;
	private var origLevelVolume:Float;
	
	public function new(name:String, so:SharedObjectInstance = null, stepChangeLevelVolume:Float = 0.05, startLevelVolume:Float = 1) {
		super();
		this.name = name;
		this.so = so;
		this.stepChangeLevelVolume = stepChangeLevelVolume;
		var levelVolume:Float = (so != null) ? so.getPropValue("levelVolume", 1):startLevelVolume;
		this.origLevelVolume = levelVolume;
		this.levelVolume = levelVolume;
		this.isSoundOffOn = as3hx.Compat.parseInt(this.levelVolume > 0);
		this.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged);
		this.addEventListener(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, this.onTweenLevelVolumeChanged);
		this.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.setSoundOffOnFade);
	}
	
	private function get_levelVolume():Float {
		return this._levelVolume;
	}
	
	private function set_levelVolume(value:Float):Float {
		if (value != this._levelVolume) {
			this._levelVolume = value;
			this.dispatchEvent(new EventSoundControl(EventSoundControl.LEVEL_VOLUME_CHANGED, value));
		}
		return value;
	}
	
	private function get_tweenLevelVolume():Float {
		return this._tweenLevelVolume;
	}
	
	private function set_tweenLevelVolume(value:Float):Float {
		if (value != this._tweenLevelVolume) {
			this._tweenLevelVolume = value;
			this.dispatchEvent(new EventSoundControl(EventSoundControl.TWEEN_LEVEL_VOLUME_CHANGED, value));
		}
		return value;
	}
	
	private function get_isSoundOffOn():Int {
		return this._isSoundOffOn;
	}
	
	private function set_isSoundOffOn(value:Int):Int {
		if (value != this._isSoundOffOn) {
			this._isSoundOffOn = value;
			this.dispatchEvent(new EventSoundControl(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, value));
		}
		return value;
	}
	
	private function onLevelVolumeChanged(e:EventModel):Void {
		if (this.so) {
			this.so.setPropValue("levelVolume" + this.name, this.levelVolume);
		}
	}
	
	private function onTweenLevelVolumeChanged(e:EventModel):Void
	//if (this.origLevelVolume != this.tweenLevelVolume) this.origLevelVolume = Math.max(0.5, this.levelVolume); {
		
		var numFramesChangeLevelVolume:Float = Math.round(Math.abs(this.levelVolume - this.tweenLevelVolume) / this.stepChangeLevelVolume);
		Tweener.removeTweens(this, "levelVolume");
		Tweener.addTween(this, {
					levelVolume: this.tweenLevelVolume,
					time: numFramesChangeLevelVolume,
					useFrames: true,
					transition: "linear"
				});
		if (this.so) {
			this.so.setPropValue("levelVolume" + this.name, Std.string(this.tweenLevelVolume));
		}
	}
	
	private function setSoundOffOnFade(e:EventModel):Void
	/*if (this.isSoundOffOn == 0) this.origLevelVolume = Math.max(0.5, this.levelVolume);
			this.tweenLevelVolume = [0, this.origLevelVolume][this.isSoundOffOn];*/ {
		
		this.tweenLevelVolume = this.isSoundOffOn;
	}
}

