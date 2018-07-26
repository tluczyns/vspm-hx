package tl.loader.progress;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.events.ProgressEvent;
import motion.Actuate;
import motion.easing.Cubic;
import tl.loader.QueueLoadContent;

class LoaderProgress extends Sprite implements ILoaderProgress {
	private var basePosXTfPercent(get, set):Float;
	
	private var weightForCurrentElement:Float;
	private var weightLoaded:Float;
	private var weightTotal:Float;
	private var arrWeightContentToLoad:Array<Dynamic>;
	private var numContentToLoad:Int;
	
	private var containerElements:Sprite;
	private var tfPercent:TextField;
	private var timeFramesTweenPercent:Float;
	private var isTLOrCenterAnchorPointWhenCenterOnStage:Int;
	public var ratioProgress:Float;
	private var prevRatioLoadedElement:Float;
	private var _basePosXTfPercent:Float;
	
	
	public function new(tfPercent:TextField = null, isTLOrCenterAnchorPointWhenCenterOnStage:Int = 0, timeFramesTweenPercent:Float = 0.5) {
		super();
		this.timeFramesTweenPercent = timeFramesTweenPercent;
		this.isTLOrCenterAnchorPointWhenCenterOnStage = isTLOrCenterAnchorPointWhenCenterOnStage;
		this.createContainerElements();
		this.initTfPercent(tfPercent);
		this.ratioProgress = this.prevRatioLoadedElement = 0;
		this.arrWeightContentToLoad = [];
		this.numContentToLoad = -1;
		this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
	}
	
	private function onAddedToStage(e:Event):Void {
		this.containerElements.x = [0, -this.containerElements.width / 2][isTLOrCenterAnchorPointWhenCenterOnStage];
		this.setLoadProgress(0);
		this.stage.addEventListener(Event.RESIZE, this.onStageResize);
		this.stage.dispatchEvent(new Event(Event.RESIZE));
	}
	
	private function onRemovedFromStage(e:Event):Void {
		this.stage.removeEventListener(Event.RESIZE, this.onStageResize);
	}
	
	public function onStageResize(e:Event):Void {
		this.x = (this.stage.stageWidth - [this.width, 0][this.isTLOrCenterAnchorPointWhenCenterOnStage]) / 2;
		this.y = (this.stage.stageHeight - [this.height, 0][this.isTLOrCenterAnchorPointWhenCenterOnStage]) / 2;
	}
	
	//container elements
	
	private function createContainerElements():Void {
		this.containerElements = new Sprite();
		this.addChild(this.containerElements);
	}
	
	private function removeContainerElements():Void {
		this.removeChild(this.containerElements);
		this.containerElements = null;
	}
	
	//textfield percent
	
	private function initTfPercent(tfPercent:TextField = null):Void {
		if (this.tfPercent == null) {
			this.tfPercent = tfPercent;
		}
		if (this.tfPercent != null) {
			tfPercent.x = Math.round(tfPercent.x);
			tfPercent.y = Math.round(tfPercent.y);
			this.tfPercent.text = "0 %";
			this.containerElements.addChild(this.tfPercent);
			this.basePosXTfPercent = this.tfPercent.x + this.tfPercent.width / 2;
		}
	}
	
	private function removeTfPercent():Void {
		if (this.tfPercent != null) {
			this.containerElements.removeChild(this.tfPercent);
			this.tfPercent = null;
		}
	}
	
	private function get_basePosXTfPercent():Float {
		return this._basePosXTfPercent;
	}
	
	private function set_basePosXTfPercent(value:Float):Float {
		this._basePosXTfPercent = value;
		this.tfPercent.x = value - this.tfPercent.width / 2;
		return value;
	}
	
	//load progress
	
	public function addWeightContent(weight:Float):Void {
		this.arrWeightContentToLoad.push(weight);
		this.weightTotal = 0;
		for (i in 0...this.arrWeightContentToLoad.length) {
			this.weightTotal += this.arrWeightContentToLoad[i];
		}
	}
	
	public function initNextLoad():Void {
		this.numContentToLoad++;
		this.weightForCurrentElement = this.arrWeightContentToLoad[this.numContentToLoad];
		this.weightLoaded = 0;
		for (i in 0...this.numContentToLoad) {
			this.weightLoaded += this.arrWeightContentToLoad[i];
		}
		this.setLoadProgress(this.weightLoaded / this.weightTotal);
	}
	
	public function onLoadProgress(event:ProgressEvent):Void {
		var ratioLoadedElement:Float = event.bytesLoaded / event.bytesTotal;
		if (Math.isNaN(ratioLoadedElement)) {
			ratioLoadedElement = this.prevRatioLoadedElement;
		}
		ratioLoadedElement = Math.max(0, Math.min(1, ratioLoadedElement));
		this.prevRatioLoadedElement = ratioLoadedElement;
		var ratioLoaded:Float = (this.weightLoaded + ratioLoadedElement * this.weightForCurrentElement) / this.weightTotal;
		this.setLoadProgress(ratioLoaded);
	}
	
	public function setLoadProgress(ratioLoaded:Float):Void {
		this.updateAndCheckIsFinished();
		Actuate.stop(this);
		Actuate.tween(this, this.timeFramesTweenPercent, {ratioProgress: ratioLoaded}).ease(Cubic.easeOut).onUpdate(this.updateAndCheckIsFinished);
	}
	
	private function updateAndCheckIsFinished():Void {
		this.update();
		if (this.ratioProgress == 1) {
			this.dispatchEvent(new Event(QueueLoadContent.FINISHED_PROGRESS));
		}
	}
	
	private function update():Void {
		if (this.tfPercent != null) {
			this.tfPercent.text = Std.string(Math.round(this.ratioProgress * 100)) + "%";
			this.tfPercent.x = this.basePosXTfPercent - this.tfPercent.width / 2;
		}
	}
	
	//destroy
	
	public function destroy():Void {
		if (this.stage != null) {
			this.stage.removeEventListener(Event.RESIZE, this.onStageResize);
		}
		this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		Actuate.stop(this);
		this.removeTfPercent();
		this.removeContainerElements();
	}
}

