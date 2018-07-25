package tl.types;

import flash.errors.Error;

class Singleton {
	
	/*(function():void {
	trace("static constructor");
        })();*/
	
	public function new() {
		super();
		throw new Error("cannot construct object");
	}
}

