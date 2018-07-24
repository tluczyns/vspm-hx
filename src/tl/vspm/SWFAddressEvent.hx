/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Matthew J Tretter <http://www.exanimo.com>
 * @author Piotr Zema <http://felixz.marknaegeli.com>
 */
package tl.vspm;

import flash.events.Event;

/**
     * Event class for SWFAddress.
     */
class SWFAddressEvent extends Event {
	public var value(get, never):String;
	public var path(get, never):String;
	public var pathNames(get, never):Array<Dynamic>;
	public var parameters(get, never):Dynamic;
	public var parameterNames(get, never):Array<Dynamic>;

	
	/**
         * Defines the <code>value</code> of the type property of a <code>init</code> event object.
         */
	public static inline var INIT:String = "init";
	
	/**
         * Defines the <code>value</code> of the type property of a <code>change</code> event object.
         */
	public static inline var CHANGE:String = "change";
	
	/**
         * Defines the <code>value</code> of the type property of a <code>internalChange</code> event object.
         */
	public static inline var INTERNAL_CHANGE:String = "internalChange";
	
	/**
         * Defines the <code>value</code> of the type property of a <code>externalChange</code> event object.
         */
	public static inline var EXTERNAL_CHANGE:String = "externalChange";
	
	private var _value:String;
	private var _path:String;
	private var _pathNames:Array<Dynamic>;
	private var _parameterNames:Array<Dynamic>;
	private var _parameters:Dynamic;
	
	/**
         * Creates a new SWFAddress event.
         * @param type Type of the event.
         */
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
	}
	
	/**
         * The current target of this event.
         */
	override private function get_currentTarget():Dynamic {
		return SWFAddress;
	}
	
	/**
         * The type of this event.
         */
	override private function get_type():String {
		return super.type;
	}
	
	/**
         * The target of this event.
         */
	override private function get_target():Dynamic {
		return SWFAddress;
	}
	
	/**
         * The value of this event.
         */
	private function get_value():String {
		if (_value == null) {
			_value = SWFAddress.getValue();
		}
		return _value;
	}
	
	/**
         * The path of this event.
         */
	private function get_path():String {
		if (_path == null) {
			_path = SWFAddress.getPath();
		}
		return _path;
	}
	
	/**
         * The folders in the deep linking path of this event.
         */
	private function get_pathNames():Array<Dynamic> {
		if (_pathNames == null) {
			_pathNames = SWFAddress.getPathNames();
		}
		return _pathNames;
	}
	
	/**
         * The parameters of this event.
         */
	private function get_parameters():Dynamic {
		if (_parameters == null) {
			_parameters = {};
			for (i in 0...parameterNames.length) {
				Reflect.setField(_parameters, Std.string(parameterNames[i]), SWFAddress.getParameter(parameterNames[i]));
			}
		}
		return _parameters;
	}
	
	/**
         * The parameters names of this event.
         */
	private function get_parameterNames():Array<Dynamic> {
		if (_parameterNames == null) {
			_parameterNames = SWFAddress.getParameterNames();
		}
		return _parameterNames;
	}
	
	/**
         * Creates a copy of the <code>SWFAddressEvent</code> object and sets the value of each parameter to match the original.
         */
	override public function clone():Event {
		return new SWFAddressEvent(type, bubbles, cancelable);
	}
	
	/**
         * Returns a string that contains all the properties of the SWFAddressEvent object.
         * The string has the following format:
         * 
         * <p>[<code>SWFAddressEvent type=<em>value</em> bubbles=<em>value</em>
         * cancelable=<em>value</em> eventPhase= value=<em>value</em> path=<em>value</em>
         * paths=<em>value</em> parameters=<em>value</em></code>]</p>
         * 
         * @return A string representation of the <code>SWFAddressEvent</code> object.
         */
	override public function toString():String {
		return formatToString("SWFAddressEvent", "type", "bubbles", "cancelable", 
				"eventPhase", "value", "path", "pathNames", "parameterNames", "parameters"
		);
	}
}
