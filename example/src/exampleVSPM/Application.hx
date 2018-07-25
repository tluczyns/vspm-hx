package exampleVSPM;

import flash.text.Font;
import tl.vspm.ApplicationVSPM;
import tl.loader.Library;

//import tl.vspm.ManagerSection;
class Application extends ApplicationVSPM {
	
	public function new() {
		trace("new Application");
		ContainerApplication;
		super();
	}
	
	override private function registerFonts():Void {
		Font.registerFont(Library.getClassDefinition("vspmExample.font.Verdana"));
	}
	
	override private function initViews(startIndSection:String = ""):Void {
		//ManagerSection.isEngagingParallelViewSections = true; {
		super.initViews(Config.NAME_SECTION_SUBPAGE + "0" + "?" + Config.NAME_PARAMETER_WELCOME + "=" + Std.string(1));
	}
}

