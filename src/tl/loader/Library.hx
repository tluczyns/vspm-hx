package tl.loader;

import flash.errors.Error;
import tl.types.Singleton;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.media.Sound;
import flash.display.BitmapData;
import flash.system.ApplicationDomain;
import flash.display.Bitmap;

class Library extends Singleton {
	
	private static var arrSwf:Array<Dynamic> = [];
	
	public function new() {
		super();
	}
	
	public static function addSwf(swf:DisplayObject):Void {
		Library.arrSwf.push(swf);
	}
	
	public static function getClassDefinition(nameClass:String):Class<Dynamic> {
		var i:Int = 0;
		var classDef:Class<Dynamic>;
		while ((i < Library.arrSwf.length) && (classDef == null)) {
			try {
				classDef = cast((cast((Library.arrSwf[i]), DisplayObject).loaderInfo.applicationDomain.getDefinition(nameClass)), Class);
			} catch (e:Error) {
			}
			i++;
		}
		return classDef;
	}
	
	public static function getMovieClip(nameClass:String, params:Array<Dynamic> = null):Dynamic {
		var classDef:Class<Dynamic> = Library.getClassDefinition(nameClass);
		var mc:Dynamic;
		if (classDef != null) {
			try {
				if (params.length) {
					mc = Type.createInstance(classDef, [params]);
				}
				else {
					mc = Type.createInstance(classDef, []);
				}
				if (!((Std.is(mc, MovieClip)) || (Std.is(mc, Sound)))) {
					mc = null;
				}
			} catch (e:Error) {
				trace("Element |", nameClass, "| is not a movieclip.");
			}
		}
		else {
			trace("Element |", nameClass, "| not exists in library.");
		}
		return mc;
	}
	
	public static function getBitmapData(nameClass:String):BitmapData {
		var classDef:Class<Dynamic> = Library.getClassDefinition(nameClass);
		var bmpData:BitmapData;
		if (classDef != null) {
			try {
				bmpData = Type.createInstance(classDef, [0, 0]);
			} catch (e:Error) {
				trace("Element |", nameClass, "| is not a BitmapData.");
			}
		}
		else {
			trace("Element |", nameClass, "| not exists in library.");
		}
		return bmpData;
	}
	
	public static function getBitmap(nameClass:String):Bitmap {
		var bmpData:BitmapData = Library.getBitmapData(nameClass);
		if (bmpData != null) {
			return new Bitmap(bmpData, "auto", true);
		}
		else {
			return null;
		}
	}
	
	public static function getDisplayObject(nameClass:String):DisplayObject {
		var dspObj:DisplayObject = Library.getMovieClip(nameClass);
		if (dspObj == null) {
			dspObj = Library.getBitmap(nameClass);
		}
		return dspObj;
	}
}
