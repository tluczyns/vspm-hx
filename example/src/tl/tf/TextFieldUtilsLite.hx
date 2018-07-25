package tl.tf;

import tl.types.Singleton;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.AntiAliasType;
import flash.text.TextFieldAutoSize;
import flash.text.Font;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

class TextFieldUtilsLite extends Singleton {
	
	public static function createTextField(tFormat:TextFormat = null, isDynamicInput:Int = 0, isSingleMultiLine:Int = 0, isAutoSizeLeftCenterNone:Int = 0, isAntiAliasNormalAdvanced:Int = 1, isSetEventForSelectionInInputTf:Bool = false):TextField {
		var tf:TextField = new TextField();
		tf.type = [TextFieldType.DYNAMIC, TextFieldType.INPUT][isDynamicInput];
		if ((isDynamicInput == 1) && (isSetEventForSelectionInInputTf)) {
			TextFieldUtilsLite.setEventForSelectionInInputTf(tf);
		}
		tf.selectable = [false, true][isDynamicInput];
		tf.multiline = [false, true][isSingleMultiLine];
		tf.wordWrap = [false, true][isSingleMultiLine];
		tf.antiAliasType = [AntiAliasType.NORMAL, AntiAliasType.ADVANCED][isAntiAliasNormalAdvanced];
		tf.autoSize = [[TextFieldAutoSize.LEFT, TextFieldAutoSize.CENTER, TextFieldAutoSize.NONE][isAutoSizeLeftCenterNone], TextFieldAutoSize.LEFT][isDynamicInput];
		if (isDynamicInput == 1) {
			var heightForInputText:Float = tf.height + 5;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.height = heightForInputText;
		}
		var isFont:Bool = ((tFormat != null) && (TextFieldUtilsLite.isFontExists(tFormat.font)));
		tf.embedFonts = isFont;
		if (tFormat != null) {
			tf.defaultTextFormat = tFormat;
			tf.setTextFormat(tFormat);
		}
		return tf;
	}
	
	public static function isFontExists(fontName:String):Bool {
		var arrFont:Array<Dynamic> = Font.enumerateFonts();
		var i:Int = 0;
		while ((i < arrFont.length) && (fontName != cast((arrFont[i]), Font).fontName)) {
			i++;
		}
		return (i < arrFont.length);
	}
	
	public static function setEventForSelectionInInputTf(tf:TextField):Void {
		tf.addEventListener(FocusEvent.FOCUS_IN, TextFieldUtilsLite.onTfFocusIn);
		tf.addEventListener(MouseEvent.MOUSE_UP, TextFieldUtilsLite.onTfMouseUp);
	}
	
	private static function onTfFocusIn(event:FocusEvent):Void {
		var tf:TextField = cast((event.target), TextField);
		tf.setSelection(0, tf.length);
	}
	
	private static function onTfMouseUp(event:MouseEvent):Void {
		var tf:TextField = cast((event.target), TextField);
		if (tf.selectionBeginIndex == tf.selectionEndIndex) {
			tf.setSelection(0, tf.length);
		}
	}
	
	
	public static function fitTextToMaxWidth(tf:Dynamic, text:String, startMaxFontSize:Int, maxWidthTextWhenStartDecreaseFontSize:Float, minFontSize:Int = 4, isSetHtmlText:Bool = false):Float {
		return TextFieldUtilsLite.fitTextToMaxWidthHeight(tf, 0, text, startMaxFontSize, maxWidthTextWhenStartDecreaseFontSize, minFontSize, isSetHtmlText);
	}
	
	public static function fitTextToMaxHeight(tf:Dynamic, text:String, startMaxFontSize:Int, maxHeightTextWhenStartDecreaseFontSize:Float, minFontSize:Int = 4, isSetHtmlText:Bool = false):Float {
		return TextFieldUtilsLite.fitTextToMaxWidthHeight(tf, 1, text, startMaxFontSize, maxHeightTextWhenStartDecreaseFontSize, minFontSize, isSetHtmlText);
	}
	
	public static function fitTextToMaxTextWidth(tf:Dynamic, text:String, startMaxFontSize:Int, maxWidthTextWhenStartDecreaseFontSize:Float, minFontSize:Int = 4, isSetHtmlText:Bool = false):Float {
		return TextFieldUtilsLite.fitTextToMaxWidthHeight(tf, 2, text, startMaxFontSize, maxWidthTextWhenStartDecreaseFontSize, minFontSize, isSetHtmlText);
	}
	
	public static function fitTextToMaxTextHeight(tf:Dynamic, text:String, startMaxFontSize:Int, maxHeightTextWhenStartDecreaseFontSize:Float, minFontSize:Int = 4, isSetHtmlText:Bool = false):Float {
		return TextFieldUtilsLite.fitTextToMaxWidthHeight(tf, 3, text, startMaxFontSize, maxHeightTextWhenStartDecreaseFontSize, minFontSize, isSetHtmlText);
	}
	
	public static function fitTextToMaxWidthHeight(tf:Dynamic, isWidthHeightTextWidthTextHeight:Int, text:String, startMaxFontSize:Int, maxWidthHeightTextWhenStartDecreaseFontSize:Float, minFontSize:Int = 4, isSetHtmlText:Bool = false):Float {
		if (text != null) {
			if (isSetHtmlText) {
				tf.htmlText = text;
			}
			else {
				tf.text = text;
			}
			var tFormat:TextFormat = tf.getTextFormat();
			tFormat.size = startMaxFontSize;
			tf.setTextFormat(tFormat);
			while ((Reflect.field(tf, Std.string(["width", "height", "textWidth", "textHeight"][isWidthHeightTextWidthTextHeight])) > maxWidthHeightTextWhenStartDecreaseFontSize) && (tFormat.size > minFontSize)) {
				tFormat.size = as3hx.Compat.parseFloat(tFormat.size) - 1;
				tf.setTextFormat(tFormat);
			}
			var addXYPos:Float = (maxWidthHeightTextWhenStartDecreaseFontSize - Reflect.field(tf, Std.string(["width", "height", "textWidth", "textHeight"][isWidthHeightTextWidthTextHeight]))) / 2;
			return addXYPos;
		}
		else {
			return -1;
		}
	}
	
	public static function traceFonts():Void {
		var embeddedFonts:Array<Dynamic> = Font.enumerateFonts(false);
		embeddedFonts.sortOn("fontName", Array.CASEINSENSITIVE);
		trace("\n\n----- Enumerate Fonts -----");
		for (i in 0...embeddedFonts.length) {
			var font:Font = embeddedFonts[i];
			trace(font.fontName, font.fontStyle);
		}
		trace("---------------------------\n\n");
	}
	
	//ustawia wysokość pola tekstowego bez zmieniania wielkości czcionki, ale z dostosowaniem pola tekstowego
	public static function setHeightTF(tf:TextField, height:Float):Void {
		tf.width = tf.textWidth;
		tf.height = tf.textHeight;
		tf.multiline = tf.wordWrap = true;
		var step:Float = 3;
		while (tf.height < height) {
			tf.width = as3hx.Compat.parseFloat(tf.width) - step;
			tf.height = tf.textHeight;
		}
		tf.width = as3hx.Compat.parseFloat(tf.width) + step;
	}

	public function new() {
		super();
	}
}

