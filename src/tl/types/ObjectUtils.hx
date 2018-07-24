package tl.types;

import tl.types.Singleton;
import flash.geom.Matrix;

class ObjectUtils extends Singleton {
	
	public static function cloneObj(objSrc:Dynamic):Dynamic {
		var objClone:Dynamic = { };
		for (prop in Reflect.fields(objSrc)) {
			if (ObjectUtils.isObjClonable(Reflect.field(objSrc, prop))) {
				Reflect.setField(objClone, prop, ObjectUtils.cloneObj(Reflect.field(objSrc, prop)));
			}
			else {
				Reflect.setField(objClone, prop, Reflect.field(objSrc, prop));
			}
		}
		return objClone;
	}
	
	public static function populateObj(objBase:Dynamic, objPopulate:Dynamic):Dynamic {
		objBase = objBase || { };
		for (prop in Reflect.fields(objPopulate)) {
			if (ObjectUtils.isObjClonable(Reflect.field(objPopulate, prop))) {
				if (Std.is(Reflect.field(objPopulate, prop), Array)) {
					if (Reflect.field(objBase, prop) == null) {
						Reflect.setField(objBase, prop, []);
					}
					else if (!(Std.is(Reflect.field(objBase, prop), Array))) {
						Reflect.setField(objBase, prop, [Reflect.field(objBase, prop)]);
					}
					var i:Int = as3hx.Compat.parseInt(Reflect.field(objPopulate, prop).length - 1);
					while (i >= 0) {
						if (Reflect.field(objBase, prop).indexOf(Reflect.field(Reflect.field(objPopulate, prop), Std.string(i))) == -1) {
							Reflect.field(objBase, prop).unshift(Reflect.field(Reflect.field(objPopulate, prop), Std.string(i)));
						}
						i--;
					}
				}
				else {
					Reflect.setField(objBase, prop, ObjectUtils.populateObj(Reflect.field(objBase, prop), Reflect.field(objPopulate, prop)));
				}
			}
			else {
				Reflect.setField(objBase, prop, Reflect.field(objPopulate, prop));
			}
		}
		return objBase;
	}
	
	private static function isObjClonable(obj:Dynamic):Bool {
		return ((as3hx.Compat.typeof((obj)) == "object") && (!(Std.is(obj, Class))) && (!(Std.is(obj, Matrix))));
	}
	
	public static function equals(obj1:Dynamic, obj2:Dynamic):Bool {
		var prop:String;
		var isEquals:Bool;
		for (prop in Reflect.fields(obj1)) {
			isEquals = isEquals && (!((Reflect.field(obj1, prop) == null) || (!ObjectUtils.equals(Reflect.field(obj1, prop), Reflect.field(obj2, prop)))));
		}
		for (prop in Reflect.fields(obj2)) {
			isEquals = isEquals && (!((Reflect.field(obj2, prop) == null) || (!ObjectUtils.equals(Reflect.field(obj1, prop), Reflect.field(obj2, prop)))));
		}
		return isEquals;
	}
	
	public static function toString(obj:Dynamic):String {
		var str:String = "{";
		for (prop in Reflect.fields(obj)) {
			str += (prop + ": " + Reflect.field(obj, prop) + ",");
		}
		if (str.length > 1) {
			str = str.substr(0, str.length - 1);
		}
		str += "}";
		return str;
	}

	public function new() {
		super();
	}
}

