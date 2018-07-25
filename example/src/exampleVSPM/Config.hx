package exampleVSPM;

import tl.types.Singleton;

class Config extends Singleton {
	
	public static var HOST:String;
	public static inline var ADD_TO_PATH_SWF:String = "";  //"swf/"  
	
	public static inline var NAME_SECTION_MAIN:String = "main";
	public static var NAME_SECTION_SUBPAGE:String = NAME_SECTION_MAIN + "/subpage";
	public static var NAME_SECTION_TILE:String = NAME_SECTION_SUBPAGE + "/tile";
	public static inline var NAME_PARAMETER_WELCOME:String = "ivw";
	
	public static inline var TIME_HIDE_SHOW:Float = 0.6;
	
	public static var WIDTH:Float;
	public static var HEIGHT:Float;
	
	public static inline var FONT:String = "Verdana";

	public function new() {
		super();
	}
}
