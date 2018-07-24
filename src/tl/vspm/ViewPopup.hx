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


class ViewPopup extends View {
	
	public function new(description:DescriptionView) {
		super(description);
	}
	
	override private function hideComplete():Void {
		super.hideComplete();
		this.description.removeView();
	}
}

