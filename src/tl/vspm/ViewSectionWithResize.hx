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

import flash.errors.Error;
import flash.events.Event;

class ViewSectionWithResize extends ViewSection {
	
	public function new(description:DescriptionViewSection) {
		super(description);
	}
	
	override public function init():Void {
		super.init();
		this.stage.addEventListener(Event.RESIZE, this.onStageResize);
		this.onStageResize(null);
	}
	
	private function onStageResize(e:Event):Void {
		throw new Error("onStageResize must be implemented");
	}
	
	override private function hideComplete():Void {
		this.stage.removeEventListener(Event.RESIZE, this.onStageResize);
		super.hideComplete();
	}
}

