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


class ViewSection extends View {
	public var num(get, never):Int;

	
	public function new(description:DescriptionView) {
		super(description);
	}
	
	private function get_num():Int {
		return cast((this.description), DescriptionViewSection).num;
	}
	
	override private function startAfterShow():Void {
		ManagerSection.startSection();
	}
	
	override private function hideComplete():Void {
		super.hideComplete();
		ManagerSection.finishStopSection(cast((this.description), DescriptionViewSection));
	}
}

