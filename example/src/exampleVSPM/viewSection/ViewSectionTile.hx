package exampleVSPM.viewSection;

import tl.vspm.ViewSection;
import tl.vspm.DescriptionViewSection;
import tl.vspm.ContentViewSection;
import flash.events.MouseEvent;
import flash.geom.Point;
import tl.vspm.SWFAddress;

class ViewSectionTile extends ViewSection {
	
	@:allow(vspmExample.viewSection)
	private static inline var MARGIN_BETWEEN_TILES:Float = 20;
	
	private var tileColorAndLabel:TileColorAndLabel;
	
	public function new(description:DescriptionViewSection) {
		super(description);
	}
	
	override public function init():Void {
		this.createTileColorAndLabel();
		super.init();
	}
	
	private function createTileColorAndLabel():Void {
		this.tileColorAndLabel = new TileColorAndLabel(this.content.color, this.content.label);
		this.tileColorAndLabel.x = cast((this.content), ContentViewSection).order * (TileColorAndLabel.DIMENSION_TILE + ViewSectionTile.MARGIN_BETWEEN_TILES);
		this.tileColorAndLabel.y = (cast((this.content), ContentViewSection).depth + 1) * (TileColorAndLabel.DIMENSION_TILE + ViewSectionTile.MARGIN_BETWEEN_TILES);
		this.tileColorAndLabel.addEventListener(MouseEvent.CLICK, this.onClick);
		this.addChild(this.tileColorAndLabel);
	}
	
	private function onClick(e:MouseEvent):Void {
		SWFAddress.setValue(this.content.indSectionTarget);
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

