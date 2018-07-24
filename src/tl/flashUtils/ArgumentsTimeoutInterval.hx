package tl.flashUtils;

import haxe.Constraints.Function;
import flash.utils.Timer;

class ArgumentsTimeoutInterval extends Dynamic {
	
	@:allow(tl.flashUtils)
	private var id:Int;
	@:allow(tl.flashUtils)
	private var timer:Timer;
	@:allow(tl.flashUtils)
	private var onComplete:Function;
	@:allow(tl.flashUtils)
	private var onCompleteScope:Dynamic;
	@:allow(tl.flashUtils)
	private var params:Array<Dynamic>;
	
	public function new(id:Int, timer:Timer, onComplete:Function, onCompleteScope:Dynamic, params:Array<Dynamic>) {
		super();
		this.id = id;
		this.timer = timer;
		this.onComplete = onComplete;
		this.onCompleteScope = onCompleteScope;
		this.params = params;
	}
}

