/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.2
 */
package tl.vspm;


class ViewSectionEmpty extends ViewSection {
	
	public function new(description:DescriptionViewSection) {
		super(description);
	}
	
	override public function init():Void {
	}
	
	override private function hideShow(isHideShow:Int):Void {
		if (isHideShow == 0) {
			this.hideComplete();
		}
		else if (isHideShow == 1) {
			this.startAfterShow();
		}
	}
	
	override private function startAfterShow():Void {
		super.startAfterShow();
	}
	
	override private function stopBeforeHide():Void {
	}
	
	override private function hideComplete():Void {
		super.hideComplete();
	}
}

