package tl.sound;

import tl.vspm.EventModel;

class EventSoundControl extends EventModel {
	
	//events to sound engine
	public static inline var SOUND_OFF_ON_STATE_CHANGED:String = "soundOffOnStateChanged";
	//events from sound engine
	public static inline var LEVEL_VOLUME_CHANGED:String = "levelVolumeChanged";
	public static inline var TWEEN_LEVEL_VOLUME_CHANGED:String = "tweenLevelVolumeChanged";
	
	public function new(type:String, data:Dynamic = null) {
		super(type, data);
	}
}

