package tl.so;

import flash.net.SharedObject;

class SharedObjectInstance {
	
	private var so:SharedObject;
	
	public function new(soName:String) {
		super();
		if (soName != null) {
			this.so = SharedObject.getLocal(soName, "/");
		}
	}
	
	public function setPropValue(propName:String, propValue:Dynamic):Bool {
		if (this.so != null) {
			this.so.data[propName] = propValue;
			this.so.flush();
			return true;
		}return false;
	}
	
	public function getPropValue(propName:String, defaultValue:Dynamic = null):Dynamic {
		return (((this.so != null) && (this.so.data[propName] != null))) ? this.so.data[propName]:defaultValue;
	}
	
	public function destroy():Void {
		this.so.flush();
		this.so.close();
		this.so = null;
	}
}

