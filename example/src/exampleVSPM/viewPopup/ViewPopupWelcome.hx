package exampleVSPM.viewPopup;

import tl.vspm.DescriptionViewPopup;
import exampleVSPM.viewSection.TileColorAndLabel;

class ViewPopupWelcome extends ViewPopupFg {
	
	public function new(description:DescriptionViewPopup) {
		super(description);
	}
	
	override private function createTileColorAndLabel():Void {
		super.createTileColorAndLabel();
		this.tileColorAndLabel.x = (this.stage.stageWidth - TileColorAndLabel.DIMENSION_TILE) / 2;
		this.tileColorAndLabel.y = (this.stage.stageHeight - TileColorAndLabel.DIMENSION_TILE) / 2;
	}
}

