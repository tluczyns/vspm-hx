package tl.loader;

import tl.vspm.EventModel;

class EventLoaderXML extends EventModel {
	
	public static inline var XML_LOADED:String = "xmlLoaded";
	public static inline var XML_NOT_LOADED:String = "xmlNotLoaded";
	
	public function new(type:String, data:Dynamic = null) {
		super(type, data);
	}
}

