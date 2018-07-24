package tl.vspm.helper;

import tl.types.Singleton;
import tl.vspm.DescriptionViewSection;
import tl.vspm.ManagerSection;
import tl.vspm.LoaderXMLContentView;

class UtilsView extends Singleton {
	
	public static function getTimeTMaxHideShowFromCurrentToTargetViewSection(targetIndSection:String):Float {
		var totalTime:Float = 0;
		var descriptionViewSection:DescriptionViewSection = ManagerSection.getCurrentDescriptionViewSection();
		while ((descriptionViewSection.ind != targetIndSection) && (descriptionViewSection.ind != "")) {
			if ((descriptionViewSection.view) && (descriptionViewSection.view.tMaxHideShow)) {
				totalTime += descriptionViewSection.view.tMaxHideShow.totalTime();
			}
			descriptionViewSection = cast((LoaderXMLContentView.dictIndViewSectionToDescriptionParentViewSection[descriptionViewSection.ind]), DescriptionViewSection);
		}
		return totalTime;
	}

	public function new() {
		super();
	}
}

