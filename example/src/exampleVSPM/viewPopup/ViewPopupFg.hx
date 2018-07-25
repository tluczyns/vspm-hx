package exampleVSPM.viewPopup;

import tl.vspm.ViewPopup;
import exampleVSPM.viewSection.TileColorAndLabel;
import tl.vspm.DescriptionViewPopup;
import flash.events.MouseEvent;
import flash.geom.Point;
import tl.vspm.SWFAddress;

class ViewPopupFg extends ViewPopup {
	
	@:allow(vspmExample.viewPopup)
	private static inline var MARGIN_BETWEEN_TILES:Float = 20;
	
	private var tileColorAndLabel:TileColorAndLabel;
	
	public function new(description:DescriptionViewPopup) {
		if (!description.content.dataClick) {
			description.content.dataClick = "";
		}
		super(description);
	}
	
	override public function init():Void {
		this.createTileColorAndLabel();
		super.init();
	}
	
	private function createTileColorAndLabel():Void {
		this.tileColorAndLabel = new TileColorAndLabel(this.content.color, this.content.label);
		this.tileColorAndLabel.addEventListener(MouseEvent.CLICK, this.onClick);
		this.addChild(this.tileColorAndLabel);
	}
	
	private function onClick(e:MouseEvent):Void
	//SWFAddress.setPathWithParameters(this.content.indSectionTarget, JSON.parse(this.dataClick2), false); {
		
		//SWFAddress.setValue(this.content.indSectionTarget);
		SWFAddress.setCurrentValueWithParameters(haxe.Json.parse(this.content.dataClick), false);
	}
	
	private function removeTileColorAndLabel():Void {
		this.removeChild(this.tileColorAndLabel);
		this.tileColorAndLabel.removeEventListener(MouseEvent.CLICK, this.onClick);
		this.tileColorAndLabel.destroy();
		this.tileColorAndLabel = null;
	}
	
	override private function hideComplete():Void {
		this.removeTileColorAndLabel();
		super.hideComplete();
	}
}

