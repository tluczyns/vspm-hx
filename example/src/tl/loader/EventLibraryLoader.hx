package tl.loader;

import tl.vspm.EventModel;

class EventLibraryLoader extends EventModel {
	
	public static inline var LIBRARIES_LOAD_SUCCESS:String = "librariesLoadSuccess";
	public static inline var LIBRARIES_LOAD_ERROR:String = "librariesLoadError";
	public static inline var LIBRARIES_AND_ASSETS_LOAD_SUCCESS:String = "librariesAndAssetsLoadSuccess";
	public static inline var LIBRARIES_AND_ASSETS_LOAD_ERROR:String = "librariesAndAssetsLoadError";
	
	public function new(type:String, data:Dynamic = null) {
		super(type, data);
	}
}

