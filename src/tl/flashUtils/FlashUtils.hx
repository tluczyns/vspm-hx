package tl.flashUtils;

import haxe.Constraints.Function;
import tl.types.Singleton;
import flash.utils.*;

class FlashUtils extends Singleton {
	
	//timeout
	
	private static var arrArgumentsTimeout:Array<Dynamic> = [];
	private static inline var TIMER_DELAY:Int = 50;
	
	public static function setTimeout(onComplete:Function,  /*onCompleteScope: Object, */   delay:Float, params:Array<Dynamic> = null):Int {
		var idTimeout:Int = flash.utils.setTimeout(FlashUtils.onCompleteCall, delay, FlashUtils.arrArgumentsTimeout.length);
		var timerTimeout:Timer = FlashUtils.createTimerForDelay(delay);
		FlashUtils.arrArgumentsTimeout.push(new ArgumentsTimeoutInterval(idTimeout, timerTimeout, onComplete, null  /*onCompleteScope*/  , params[0]));
		timerTimeout.start();
		return as3hx.Compat.parseInt(FlashUtils.arrArgumentsTimeout.length - 1);
	}
	
	public static function pauseTimeout(numArguments:Int):Void {
		if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) {
			var argumentsTimeout:ArgumentsTimeoutInterval = cast((FlashUtils.arrArgumentsTimeout[numArguments]), ArgumentsTimeoutInterval);
			var timerTimeout:Timer = argumentsTimeout.timer;
			if (timerTimeout.running) {
				flash.utils.clearTimeout(argumentsTimeout.id);
				timerTimeout.stop();
			}
		}
	}
	
	public static function continueTimeout(numArguments:Int):Void {
		if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) {
			var argumentsTimeout:ArgumentsTimeoutInterval = cast((FlashUtils.arrArgumentsTimeout[numArguments]), ArgumentsTimeoutInterval);
			var timerTimeout:Timer = argumentsTimeout.timer;
			if (!timerTimeout.running) {
				argumentsTimeout.id = flash.utils.setTimeout(FlashUtils.onCompleteCall, FlashUtils.TIMER_DELAY * (timerTimeout.repeatCount - timerTimeout.currentCount), numArguments);
				timerTimeout.start();
			}
		}
	}
	
	public static function clearTimeout(numArguments:Int):Void {
		FlashUtils.pauseTimeout(numArguments);
		if ((numArguments < FlashUtils.arrArgumentsTimeout.length) && (FlashUtils.arrArgumentsTimeout[numArguments] != null)) {
			FlashUtils.deleteTimeout(numArguments);
		}
	}
	
	private static function createTimerForDelay(delay:Float):Timer {
		var timerTimeout:Timer = new Timer(FlashUtils.TIMER_DELAY, delay / FlashUtils.TIMER_DELAY);
		return timerTimeout;
	}
	
	private static function onCompleteCall(numArguments:Int):Void {
		var argumentsTimeout:ArgumentsTimeoutInterval = cast((FlashUtils.arrArgumentsTimeout[numArguments]), ArgumentsTimeoutInterval);
		argumentsTimeout.onComplete.apply(null, /*argumentsTimeout.onCompleteScope*/argumentsTimeout.params);
		FlashUtils.deleteTimeout(numArguments);
	}
	
	private static function deleteTimeout(numArguments:Int):Void {
		FlashUtils.arrArgumentsTimeout[numArguments] = null;
	}
	
	//TODO: intervals
	
	
	//class names
	
	public static function isSuperclass(classCheck:Class<Dynamic>, classSuper:Class<Dynamic>):Bool {
		var result:Bool;
		result = cast(classCheck == classSuper, Bool);
		if (!result) {
			var nameClassCheck:String;
			do {
				nameClassCheck = Type.getClassName(Type.getSuperClass(classCheck));
				if (nameClassCheck != null) {
					classCheck = cast((Type.resolveClass(nameClassCheck)), Class);
				}
			} while (((classCheck != classSuper) && (nameClassCheck != null)));
			result = cast(classCheck == classSuper, Bool);
		}
		return result;
	}
	
	private static var VEC_NAME_TYPE_FIELD:Vector<String> = Vector.ofArray(cast ["constant", "variable", "accessor", "method"]);

	public function new() {
		super();
	}
}

