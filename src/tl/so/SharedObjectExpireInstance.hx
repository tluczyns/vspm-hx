package tl.so;

import flash.net.SharedObject;

class SharedObjectExpireInstance extends SharedObjectInstance {
	
	private var timeExpire:Int;
	private var soTimeStart:SharedObjectInstance;
	private var soTimeExpire:SharedObjectInstance;
	
	public function new(soName:String, timeExpire:Int = 3600000) {
		super(soName);
		this.soTimeStart = new SharedObjectInstance(soName + "TimeStart");
		this.soTimeExpire = new SharedObjectInstance(soName + "TimeExpire");
		this.timeExpire = timeExpire;
	}
	
	public function setPropValueWithExpire(propName:String, propValue:Dynamic, timeExpire:Int = 0):Void {
		if (super.setPropValue(propName, propValue)) {
			if (timeExpire == 0) {
				timeExpire = this.timeExpire;
			}
			this.soTimeStart.setPropValue(propName, (Date.now()).getTime());
			this.soTimeExpire.setPropValue(propName, timeExpire);
		}
	}
	
	override public function setPropValue(propName:String, propValue:Dynamic):Bool {
		This is an intentional compilation error. See the README for handling the delete keyword
		delete this.soTimeStart.setPropValue(propName, null);
		return super.setPropValue(propName, propValue);
	}
	
	override public function getPropValue(propName:String, defaultValue:Dynamic = null):Dynamic {
		var isExpired:Bool = false;
		var timeStart:Int = as3hx.Compat.parseInt(this.soTimeStart.getPropValue(propName));
		var timeExpire:Int = as3hx.Compat.parseInt(this.soTimeExpire.getPropValue(propName));
		if ((timeStart > 0) && (timeExpire > 0)) {
			var timeLive:Int = as3hx.Compat.parseInt((Date.now()).getTime() - timeStart);
			if (timeLive > timeExpire) {
				isExpired = true;
			}
		}
		if (isExpired) {
			this.setPropValue(propName, null);
		}
		return super.getPropValue(propName, defaultValue);
	}
}

