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

class EventModel extends Event implements IEventModel {
	public var data(get, never):Dynamic;

	
	private var _data:Dynamic;
	
	public function new(type:String, data:Dynamic = null, bubbles:Bool = false) {
		super(type, bubbles);
		this._data = data;
	}
	
	private function get_data():Dynamic {
		return this._data;
	}
	
	override public function clone():Event {
		return new EventModel(type, this._data, bubbles);
	}
	
	override public function toString():String {
		return formatToString("EventLoaderContent", "_data", "type", "bubbles", "cancelable", "eventPhase");
	}
}

