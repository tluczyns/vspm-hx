package exampleVSPM;

import exampleVSPM.viewPopup.ViewPopupHeader;
import exampleVSPM.viewPopup.ViewPopupWelcome;
import exampleVSPM.viewSection.ViewSectionMain;
import exampleVSPM.viewSection.ViewSectionSubpage;
import tl.vspm.ContainerApplicationVSPM;
import vspmExample.viewPopup.*;
import vspmExample.viewSection.*;

class ContainerApplication extends ContainerApplicationVSPM {
	
	public function new() {
		ViewPopupHeader;ViewPopupWelcome;
		ViewSectionMain;ViewSectionSubpage;
		super();
	}
}

