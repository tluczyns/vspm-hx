package tl.utils;

import haxe.Constraints.Function;

class FunctionCallback {
	
	public var func:Function;
	public var scope:Dynamic;
	public var params:Array<Dynamic>;
	
	public function new(func:Function, scope:Dynamic, params:Array<Dynamic> = null) {
		this.func = func;
		this.scope = scope;
		this.params = params;
	}
	
	public function call(params:Array<Dynamic> = null):Void {
		Reflect.callMethod(this.scope, this.func, (params != null) ? params : this.params);
	}
}

