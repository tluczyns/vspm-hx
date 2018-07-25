package exampleVSPM.viewSection;

import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import tl.tf.TextFieldUtilsLite;
import flash.text.TextFormat;
import exampleVSPM.Config;
import flash.text.TextFormatAlign;

class TileColorAndLabel extends Sprite {
	
	public static inline var DIMENSION_TILE:Float = 150;
	
	private var shpRectColor:Shape;
	private var tfLabel:TextField;
	
	public function new(colorRect:Int, strLabel:String) {
		super();
		this.createShpRectColor(colorRect);
		this.createTfLabel(strLabel);
		this.useHandCursor = true;
	}
	
	private function createShpRectColor(colorRect:Int):Void {
		this.shpRectColor = new Shape();
		this.shpRectColor.graphics.clear();
		this.shpRectColor.graphics.beginFill(colorRect, 1);
		this.shpRectColor.graphics.drawRect(0, 0, TileColorAndLabel.DIMENSION_TILE, TileColorAndLabel.DIMENSION_TILE)  //this.shpRectColor.graphics.endFill();  ;
		
		this.addChild(this.shpRectColor);
	}
	
	private function removeShpRectColor():Void {
		this.removeChild(this.shpRectColor);
		this.shpRectColor = null;
	}
	
	private function createTfLabel(strLabel:String):Void {
		var offset:Int = 10;
		this.tfLabel = TextFieldUtilsLite.createTextField(new TextFormat(Config.FONT, 16, 0x333333, null, null, null, null, null, TextFormatAlign.CENTER), 0, 1);
		this.tfLabel.width = TileColorAndLabel.DIMENSION_TILE - 2 * offset;
		this.tfLabel.height = TileColorAndLabel.DIMENSION_TILE - 2 * offset;
		this.tfLabel.text = strLabel;
		this.tfLabel.x = offset;
		this.tfLabel.y = (TileColorAndLabel.DIMENSION_TILE - this.tfLabel.height) / 2;
		this.addChild(this.tfLabel);
	}
	
	private function removeTfLabel():Void {
		this.removeChild(this.tfLabel);
		this.tfLabel = null;
	}
	
	public function destroy():Void {
		this.removeTfLabel();
		this.removeShpRectColor();
	}
}

