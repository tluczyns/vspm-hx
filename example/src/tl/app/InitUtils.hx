package tl.app;

import tl.types.Singleton;
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.display.InteractiveObject;
import flash.ui.ContextMenu;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.StageQuality;
import flash.display.Shape;

class InitUtils extends Singleton {
	
	private static var scaleMode:String;
	private static var rectMask:Rectangle;
	
	public static function initApp(iObj:DisplayObjectContainer, scaleMode:String = "noScale", rectMask:Rectangle = null):Void {
		InitUtils.rectMask = rectMask;
		InitUtils.setupContextMenu(iObj);
		InitUtils.setupStageAndMask(iObj, scaleMode);
	}
	
	public static function setupContextMenu(iObj:InteractiveObject):Void {
		var contextMenu:ContextMenu = new ContextMenu();
		contextMenu.hideBuiltInItems();
		iObj.contextMenu = contextMenu;
	}
	
	public static function setupStageAndMask(dspObjContainer:DisplayObjectContainer, scaleMode:String = "noScale"):Void {
		InitUtils.scaleMode = scaleMode;
		if (dspObjContainer.stage) {
			InitUtils.setupStageAndMaskOnAddedToStage({
						target: dspObjContainer
					});
		}
		else {
			dspObjContainer.addEventListener(Event.ADDED_TO_STAGE, InitUtils.setupStageAndMaskOnAddedToStage);
		}
	}
	
	private static function setupStageAndMaskOnAddedToStage(e:Dynamic):Void {
		var dspObjContainer:DisplayObjectContainer = cast((e.target), DisplayObjectContainer);
		dspObjContainer.removeEventListener(Event.ADDED_TO_STAGE, InitUtils.setupStageAndMaskOnAddedToStage);
		InitUtils.setupStage(dspObjContainer);
		InitUtils.addMask(dspObjContainer);
	}
	
	private static function setupStage(dspObj:DisplayObject):Void {
		dspObj.x = 0;
		dspObj.y = 0;
		dspObj.stage.align = StageAlign.TOP_LEFT;
		dspObj.stage.scaleMode = InitUtils.scaleMode;
		dspObj.stage.quality = StageQuality.HIGH;
		dspObj.stage.focus = dspObj.stage;
	}
	
	private static function addMask(dspObjContainer:DisplayObjectContainer):Void {
		//InitUtils.rectMask = new Rectangle(0, 0, dspObjContainer.stage.stageWidth, dspObjContainer.stage.stageHeight); {
		if (InitUtils.rectMask != null) {
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0xFFFFFF, 1);
			mask.graphics.drawRect(InitUtils.rectMask.x, InitUtils.rectMask.y, InitUtils.rectMask.width, InitUtils.rectMask.height);
			mask.graphics.endFill();
			dspObjContainer.addChild(mask);
			dspObjContainer.setChildIndex(mask, 0);
			dspObjContainer.mask = mask;
		}
	}

	public function new() {
		super();
	}
}

