package tl.sound;

import flash.display.Sprite;
import tl.vspm.EventModel;

class TestModelSoundControlGlobal extends Sprite {
	
	private var modelSoundControlGlobal:ModelSoundControlGlobal;
	
	public function new() {
		super();
		this.modelSoundControlGlobal = new ModelSoundControlGlobal(Vector.ofArray(cast ["a", "b", "c"]), "sharedobj");
		this.modelSoundControlGlobal.addEventListener(EventSoundControl.LEVEL_VOLUME_CHANGED, this.onLevelVolumeChanged);
		this.modelSoundControlGlobal.addEventListener(EventSoundControl.SOUND_OFF_ON_STATE_CHANGED, this.onSoundOffOnChanged)  //this.modelSoundControlGlobal.levelVolume = 2;  ;
		
		ModelSoundControlGlobal.getModel("a").levelVolume = 4;
		//this.modelSoundControlGlobal.isSoundOffOn = 0;
		trace("start:", this.modelSoundControlGlobal.levelVolume, ModelSoundControlGlobal.getModel("a").levelVolume, ModelSoundControlGlobal.getModel("b").levelVolume, ModelSoundControlGlobal.getModel("c").levelVolume);
	}
	
	public function onLevelVolumeChanged(e:EventModel):Void {
		trace("onLevelVolumeChanged:", cast((e.target), ModelSoundControl).levelVolume, this.modelSoundControlGlobal.levelVolume, ModelSoundControlGlobal.getModel("a").levelVolume, ModelSoundControlGlobal.getModel("b").levelVolume, ModelSoundControlGlobal.getModel("c").levelVolume);
	}
	
	public function onSoundOffOnChanged(e:EventModel):Void {
		trace("onSoundOffOnChanged:", e.data);
	}
}

