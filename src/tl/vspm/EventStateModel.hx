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

import flash.events.Event;

class EventStateModel extends EventModel {
	
	public static inline var START_CHANGE_SECTION:String = "startChangeSection";
	public static inline var CHANGE_SECTION:String = "changeSection";
	public static inline var CHANGE_CURR_SECTION:String = "changeCurrSection";
	public static inline var CHANGE_PARAMETERS:String = "changeParameters";
	
	public function new(type:String, data:Dynamic = null) {
		super(type, data);
	}
}

