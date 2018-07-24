package tl.utils;

import haxe.Constraints.Function;

class FunctionCallback extends Dynamic {
	
	public var func:Function;
	public var scope:Dynamic;
	public var params:Array<Dynamic>;
	
	public function new(func:Function, scope:Dynamic, params:Array<Dynamic> = null) {
		super();
		this.func = func;
		this.scope = scope;
		this.params = params;
	}
	
	public function call(params:Array<Dynamic> = null):Void {
		this.func.apply(this.scope, params || this.params);
	}
}

