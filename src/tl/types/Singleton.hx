package tl.types;

import flash.errors.Error;

class Singleton extends Dynamic {
	
	/*(function():void {
	trace("static constructor");
        })();*/
	
	public function new() {
		super();
		throw new Error("cannot construct object");
	}
}

