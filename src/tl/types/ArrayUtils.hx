package tl.types;


class ArrayUtils extends Singleton {
	
	public static function fill(arr:Dynamic, value:Dynamic):Void {
		for (i in 0...arr.length) {
			Reflect.setField(arr, Std.string(i), value);
		}
	}
	
	public static function remove(arr:Dynamic, element:Dynamic):Bool {
		var isRemoved:Bool = false;
		var i:Int = 0;
		while ((i < arr.length) && (!isRemoved)) {
			if (Reflect.field(arr, Std.string(i)) == element) {
				arr.splice(i, 1);
				isRemoved = true;
			}
			i++;
		}
		return isRemoved;
	}
	
	public static function removeByProperty(arr:Dynamic, propertyName:String, propertyValue:Dynamic):Bool {
		var isRemoved:Bool = false;
		var i:Int = 0;
		while ((i < arr.length) && (!isRemoved)) {
			if (Reflect.field(Reflect.field(arr, Std.string(i)), propertyName) == propertyValue) {
				arr.splice(i, 1);
				isRemoved = true;
			}
			i++;
		}
		return isRemoved;
	}
	
	public static function getElementIndexByProperty(arr:Dynamic, propertyName:String, propertyValue:Dynamic):Int {
		var elementIndex:Int = -1;
		var i:Int = 0;
		var arrPropertyName:Array<Dynamic> = [];
		if (propertyName.length) {
			arrPropertyName = propertyName.split(".");
		}
		while ((i < arr.length) && (elementIndex == -1)) {
			var propertyValueInArr:Dynamic = Reflect.field(arr, Std.string(i));
			for (j in 0...arrPropertyName.length) {
				propertyValueInArr = Reflect.field(propertyValueInArr, Std.string(arrPropertyName[j]));
			}
			if (propertyValueInArr == propertyValue) {
				elementIndex = i;
			}
			i++;
		}
		return elementIndex;
	}
	
	public static function getElementArrIndexByProperty(arr:Dynamic, propertyName:String, propertyValue:Dynamic):Array<Dynamic> {
		var elementArrIndex:Array<Dynamic> = [];
		var i:Int = 0;
		var arrPropertyName:Array<Dynamic> = [];
		if (propertyName.length) {
			arrPropertyName = propertyName.split(".");
		}
		while (i < arr.length) {
			var propertyValueInArr:Dynamic = Reflect.field(arr, Std.string(i));
			for (j in 0...arrPropertyName.length) {
				propertyValueInArr = Reflect.field(propertyValueInArr, Std.string(arrPropertyName[j]));
			}
			if (propertyValueInArr == propertyValue) {
				elementArrIndex.push(i);
			}
			i++;
		}
		return elementArrIndex;
	}
	
	public static function move(arr:Dynamic, indexFrom:Int, indexTo:Int):Void {
		var elementMoved:Dynamic = arr.splice(indexFrom, 1);
		arr.splice(indexTo, 0, elementMoved);
	}
	
	public static function generateRandomIndexArray(length:Int, isForceMix:Bool = true):Array<Dynamic> {
		var arrRandomIndex:Array<Dynamic> = new Array<Dynamic>();
		for (i in 0...length) {
			var index:Int;
			do {
				index = Math.floor(Math.random() * length);
			} while (((Lambda.indexOf(arrRandomIndex, index) > -1) || (isForceMix && (arrRandomIndex.length < length - 1) && (index == arrRandomIndex.length))));
			arrRandomIndex.push(index);
		}
		return arrRandomIndex;
	}
	
	public static function generateRandomMixedArray(arrToMix:Dynamic, isForceMix:Bool = true):Array<Dynamic> {
		var arrInd:Array<Dynamic> = ArrayUtils.generateRandomIndexArray(arrToMix.length);
		var arrMix:Array<Dynamic> = new Array<Dynamic>(arrToMix.length);
		for (i in 0...arrToMix.length) {
			arrMix[i] = Reflect.field(arrToMix, Std.string(arrInd[i]));
		}
		return arrMix;
	}
	
	public static function concatUnique(arrToConcat1:Dynamic, arrToConcat2:Dynamic, isNewArray:Bool = true):Dynamic {
		if (isNewArray) {
			arrToConcat1 = arrToConcat1.concat();
		}
		for (i in 0...arrToConcat2.length) {
			if (arrToConcat1.indexOf(Reflect.field(arrToConcat2, Std.string(i))) == -1) {
				arrToConcat1.push(Reflect.field(arrToConcat2, Std.string(i)));
			}
		}
		return arrToConcat1;
	}
	
	public static function compareElements(arr:Dynamic, arrToCompare:Dynamic, isComparedMayBeLonger:Bool = false):Bool {
		if ((arrToCompare.length == arr.length) || ((isComparedMayBeLonger) && (arrToCompare.length > arr.length))) {
			var i:Int = 0;
			while ((i < arr.length) && (Reflect.field(arr, Std.string(i)) == Reflect.field(arrToCompare, Std.string(i)))) {
				i++;
			}
			return cast(i == arr.length, Bool);
		}
		else {
			return false;
		}
	}
	
	public static function convertToArray(iterable:Dynamic):Array<Dynamic> {
		var arr:Array<Dynamic> = [];
		for (elem/* AS3HX WARNING could not determine type for var: elem exp: EIdent(iterable) type: Dynamic */ in iterable) {
			arr.push(elem);
		}
		return arr;
	}

	public function new() {
		super();
	}
}

