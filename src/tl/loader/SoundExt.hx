package tl.loader;

import haxe.Constraints.Function;
import flash.media.Sound;
import flash.media.SoundChannel;
import tl.sound.ModelSoundControl;
import tl.sound.ModelSoundControlGlobal;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.media.SoundTransform;
import tl.sound.EventSoundControl;
import caurina.transitions.Tweener;
import flash.errors.IOError;

class SoundExt extends Sound {
	public var modelSoundControl(get, set):ModelSoundControl;

	public var channel:SoundChannel;
	private var _modelSoundControl:ModelSoundControl;
	public var isLoop:Bool;
	public var initVolume:Float;
	private var origVolume:Float;
	private var onLoadComplete:Function;
	private var onLoadProgress:Function;
	private var onLoadError:Function;
	private var isPlayFirstTime:Bool;
	private var onSoundComplete:Function;
	private var timeoutSoundComplete:Int;
	public var positionPause:Int = 0;
	
	public function new(objSoundExt:Dynamic = null) {
		objSoundExt = objSoundExt || { };
		this.modelSoundControl = objSoundExt.modelSoundControl || ModelSoundControlGlobal.getModel();
		this.isLoop = cast(objSoundExt.isLoop, Bool);
		this.initVolume = this.origVolume = ((objSoundExt.initVolume != null)) ? objSoundExt.initVolume:1;
		this.onLoadComplete = objSoundExt.onLoadComplete || this.onLoadCompleteDefault;
		this.onLoadProgress = objSoundExt.onLoadProgress || this.onLoadProgressDefault;
		this.onLoadError = objSoundExt.onLoadError || this.onLoadErrorDefault;
		this.addEventListener(Event.COMPLETE, this.onLoadComplete);
		this.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
		this.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		var urlRequest:URLRequest;
		if (objSoundExt.url != null) {
			urlRequest = new URLRequest(objSoundExt.url);
		}
		this.isPlayFirstTime = true;
		super(urlRequest);
	}
	
	//model sound control
	
	private function get_modelSoundControl():ModelSoundControl {
		return this._modelSoundControl;
	}
	
	private function set_modelSoundControl(value:ModelSoundControl):ModelSoundControl {
		this._modelSoundControl = value;
		return value;
	}
	
	//loading and init
	
	private function onLoadCompleteDefault(event:Event):Void {
		this.removeLoadListeners();
	}
	
	private function removeLoadListeners():Void {
		this.removeEventListener(Event.COMPLETE, this.onLoadComplete);
		this.removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
		this.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
	}
	
	private function onLoadProgressDefault(event:ProgressEvent):Void {
		var ratioLoaded:Float = event.bytesLoaded / event.bytesTotal;
		var percentLoaded:Int = Math.round(ratioLoaded * 100);
	}
	
	private function onLoadErrorDefault(errorEvent:IOErrorEvent):Void {
	}
	
	//play and stop
	
	public function playExt(onSoundComplete:Function = null, startTime:Float = 0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		if (this.isPlayFirstTime) {
			this.isPlayFirstTime = false;
			this.modelSoundControl.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.setVolumeGlobal);
			this.setVolumeGlobal();
		}
		as3hx.Compat.clearTimeout(this.timeoutSoundComplete);
		this.onSoundComplete = onSoundComplete || this.onSoundCompleteDefault;
		this.stop();
		this.channel = this.play(startTime, loops, sndTransform);
		if (this.channel) {
			this.channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
		}
		else if (this.onSoundComplete != this.onSoundCompleteDefault) {
			as3hx.Compat.clearTimeout(this.timeoutSoundComplete);
			this.timeoutSoundComplete = as3hx.Compat.setTimeout(this.onSoundComplete, 4000, [null]);
		}
		this.setVolumeSelf();
		return this.channel;
	}
	
	public function stop():Void {
		if (this.channel) {
			this.positionPause = this.channel.position;
			this.channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
			this.channel.stop();
			this.channel = null;
		}
		else {
			as3hx.Compat.clearTimeout(this.timeoutSoundComplete);
		}
	}
	
	private function onSoundCompleteDefault(event:Event):Void {
		if (this.isLoop) {
			this.playExt();
		}
		else {
			this.stop();
		}
	}
	
	//set volume
	
	private function setVolumeGlobal(e:EventSoundControl = null):Void {
		this.setVolume(this.modelSoundControl.levelVolume, true);
	}
	
	private function setVolumeSelf():Void {
		this.setVolume(this.initVolume, false);
	}
	
	public function setVolume(volume:Float, isGlobal:Bool = false):Void {
		if (!isGlobal) {
			this.initVolume = volume;
			volume *= this.modelSoundControl.levelVolume;
		}
		else {
			volume *= this.initVolume;
		}
		//trace("volume:" + volume + ", isGlobal:" + isGlobal)
		if (this.channel != null) {
			var soundTransform:SoundTransform = new SoundTransform();
			soundTransform.volume = volume;
			this.channel.soundTransform = soundTransform;
		}
	}
	
	public function setSoundOffOnFade(isSoundOffOn:Float, stepChangeVolume:Float = 0.1, onComplete:Function = null, onCompleteParams:Array<Dynamic> = null):Void {
		var destVolume:Float;
		if (isSoundOffOn == 0) {
			this.origVolume = this.initVolume;
			destVolume = 0;
		}
		else if (isSoundOffOn == 1) {
			destVolume = this.origVolume;
		}
		this.tweenVolume(destVolume, stepChangeVolume, onComplete, onCompleteParams);
	}
	
	public function tweenVolume(destVolume:Float, stepChangeVolume:Float = 0.1, onComplete:Function = null, onCompleteParams:Array<Dynamic> = null, ease:Dynamic = null):Int {
		var currVolume:Float = (((this.channel) && (this.channel.soundTransform))) ? this.channel.soundTransform.volume:this.initVolume;
		var numFramesChangeVolume:Int = Math.abs(Math.round(Math.abs(destVolume - currVolume) / stepChangeVolume));
		ease = ease || "linear";
		Tweener.removeTweens(this);
		Tweener.addTween(this, {
					initVolume: destVolume,
					time: numFramesChangeVolume,
					useFrames: true,
					transition: ease,
					onUpdate: this.setVolumeSelf,
					onComplete: onComplete,
					onCompleteParams: onCompleteParams
				});
		return numFramesChangeVolume;
	}
	
	//destroy
	
	public function destroy():Void {
		try {
			this.close();
			this.removeLoadListeners();
		} catch (error:IOError) {
		}
		this.modelSoundControl.removeEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.setVolumeGlobal);
		this.stop();
		as3hx.Compat.clearTimeout(this.timeoutSoundComplete);
		Tweener.removeTweens(this);
	}
}

