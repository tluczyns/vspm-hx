package tl.service;

import tl.types.Singleton;
import flash.system.Security;
import flash.system.Capabilities;
import flash.external.ExternalInterface;

class ExternalInterfaceExt extends Singleton {
	public static var isBrowser(get, never):Bool;

	
	/*{
	Security.allowDomain("*");
	}*/
	
	private static function get_isBrowser():Bool {
		return ((Capabilities.playerType == "PlugIn") || (Capabilities.playerType == "ActiveX"));
	}
	
	public static function addCallbackAndCall(nameFunction:String, scopeFunction:Dynamic, arrParams:Array<Dynamic> = null):Void {
		if (ExternalInterfaceExt.isBrowser) {
			as3hx.Compat.arraySplice(arrParams, 0, 0, [nameFunction]);
			ExternalInterface.addCallback(nameFunction, Reflect.field(scopeFunction, nameFunction));
			ExternalInterface.call.apply(ExternalInterface, arrParams);
		}
		else {
			as3hx.Compat.setTimeout(function():Void {
						Reflect.field(scopeFunction, nameFunction).apply(scopeFunction, arrParams);
					}, 500, [arrParams]);
		}
	}
	
	public static function addCallback(nameFunction:String, scopeFunction:Dynamic):Void {
		if (ExternalInterfaceExt.isBrowser) {
			ExternalInterface.addCallback(nameFunction, Reflect.field(scopeFunction, nameFunction));
		}
	}
	
	public static function removeCallback(nameFunction:String):Void {
		if (ExternalInterfaceExt.isBrowser) {
			ExternalInterface.addCallback(nameFunction, null);
		}
	}
	
	public static function call(nameJSFunction:String, arrParams:Array<Dynamic> = null):Void {
		if (ExternalInterfaceExt.isBrowser) {
		//ExternalInterface.call(nameJSFunction, arrParams);{
			
			arrParams.unshift(nameJSFunction);
			ExternalInterface.call.apply(ExternalInterface, arrParams);
		}
	}

	public function new() {
		super();
	}
}

