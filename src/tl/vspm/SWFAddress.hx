/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Mark Ross <http://www.therossman.org>
 * @author Piotr Zema <http://felixz.marknaegeli.com>
 */
package tl.vspm;

import flash.errors.Error;
import haxe.Constraints.Function;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.utils.Timer;

/**
     * Dispatched when <code>SWFAddress</code> initializes.
     */
@:meta(Event(name="init",type="SWFAddressEvent"))

/**
     * Dispatched when any value change.
     */
@:meta(Event(name="change",type="SWFAddressEvent"))

/**
     * Dispatched when value was changed by Flash.
     */
@:meta(Event(name="internalChange",type="SWFAddressEvent"))

/**
     * Dispatched when value was changed by Browser.
     */
@:meta(Event(name="externalChange",type="SWFAddressEvent"))

/**
     * SWFAddress class. 
     */
class SWFAddress {
	
	private static var _init:Bool = false;
	private static var _initChange:Bool = false;
	private static var _initChanged:Bool = false;
	private static var _strict:Bool = true;
	private static var _value:String = "";
	private static var _queue:Array<Dynamic> = new Array<Dynamic>();
	private static var _queueTimer:Timer = new Timer(10);
	private static var _initTimer:Timer = new Timer(10);
	public static var _availability:Bool = ExternalInterface.available;
	private static var _dispatcher:EventDispatcher = new EventDispatcher();
	
	/**
         * Init event.
         */
	public static var onInit:Function;
	
	/**
         * Change event.
         */
	public static var onChange:Function;
	
	/**
         * @throws IllegalOperationError The class cannot be instantiated.
         */
	public function new() {
		throw new IllegalOperationError("SWFAddress cannot be instantiated.");
	}
	
	private static function _initialize():Bool {
		if (_availability) {
			try {
				_availability =
						try cast(ExternalInterface.call("function() { return (typeof SWFAddress != \"undefined\"); }"), Bool) catch(e:Dynamic) null;
				ExternalInterface.addCallback("getSWFAddressValue", 
						function():String {
							return _value;
						}
			);
				ExternalInterface.addCallback("setSWFAddressValue", 
						_setValue
			);
			} catch (e:Error) {
				_availability = false;
			}
		}
		_queueTimer.addEventListener(TimerEvent.TIMER, _callQueue);
		_initTimer.addEventListener(TimerEvent.TIMER, _check);
		_initTimer.start();
		return true;
	}
	private static var _initializer:Bool = _initialize();
	
	private static function _check(event:TimerEvent):Void {
		if ((as3hx.Compat.typeof(Reflect.field(SWFAddress, "onInit")) == "function" || _dispatcher.hasEventListener(SWFAddressEvent.INIT)) && !_init) {
			SWFAddress._setValueInit(_getValue());
			SWFAddress._init = true;
		}
		if (as3hx.Compat.typeof(Reflect.field(SWFAddress, "onChange")) == "function" || _dispatcher.hasEventListener(SWFAddressEvent.CHANGE) || 
			as3hx.Compat.typeof(Reflect.field(SWFAddress, "onExternalChange")) == "function" || _dispatcher.hasEventListener(SWFAddressEvent.EXTERNAL_CHANGE)) {
			_initTimer.stop();
			SWFAddress._init = true;
			SWFAddress._setValueInit(_getValue());
		}
	}
	
	private static function _strictCheck(value:String, force:Bool):String {
		if (SWFAddress.getStrict()) {
			if (force) {
				if (value.substr(0, 1) != "/") {
					value = "/" + value;
				}
			}
			else if (value == "") {
				value = "/";
			}
		}
		return value;
	}
	
	private static function _getValue():String {
		var value:String;
		var ids:String = null;
		if (_availability) {
			value = Std.string(ExternalInterface.call("SWFAddress.getValue"));
			var arr:Array<Dynamic> = try cast(ExternalInterface.call("SWFAddress.getIds"), Array</*AS3HX WARNING no type*/>) catch(e:Dynamic) null;
			if (arr != null) {
				ids = Std.string(arr);
			}
		}
		if (ids == null || !_availability || _initChanged) {
			value = SWFAddress._value;
		}
		else if (value == "undefined" || value == null) {
			value = "";
		}
		return _strictCheck(value || "", false);
	}
	
	private static function _setValueInit(value:String):Void {
		SWFAddress._value = value;
		if (!_init) {
			_dispatchEvent(SWFAddressEvent.INIT);
		}
		else {
			_dispatchEvent(SWFAddressEvent.CHANGE);
			_dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
		}
		_initChange = true;
	}
	
	private static function _setValue(value:String):Void {
		if (value == "undefined" || value == null) {
			value = "";
		}
		if (SWFAddress._value == value && SWFAddress._init) {
			return;
		}
		if (!SWFAddress._initChange) {
			return;
		}
		SWFAddress._value = value;
		if (!_init) {
			SWFAddress._init = true;
			if (as3hx.Compat.typeof(Reflect.field(SWFAddress, "onInit")) == "function" || _dispatcher.hasEventListener(SWFAddressEvent.INIT)) {
				_dispatchEvent(SWFAddressEvent.INIT);
			}
		}
		_dispatchEvent(SWFAddressEvent.CHANGE);
		_dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
	}
	
	private static function _dispatchEvent(type:String):Void {
		if (_dispatcher.hasEventListener(type)) {
			_dispatcher.dispatchEvent(new SWFAddressEvent(type));
		}
		type = type.substr(0, 1).toUpperCase() + type.substring(1);
		if (as3hx.Compat.typeof(SWFAddress["on" + type]) == "function") {
			SWFAddress["on" + type]();
		}
	}
	
	private static function _callQueue(event:TimerEvent):Void {
		if (_queue.length != 0) {
			var script:String = "";
			var i:Int = 0;
			var obj:Dynamic;
			while (obj = _queue[i]) {
				if (Std.is(obj.param, String)) {
					obj.param = "\"" + obj.param + "\"";
				}
				script += obj.fn + "(" + obj.param + ");";
				i++;
			}
			_queue = new Array<Dynamic>();
			flash.Lib.getURL(new URLRequest("javascript:" + script + "void(0);"), "_self");
		}
		else {
			_queueTimer.stop();
		}
	}
	
	private static function _call(fn:String, param:Dynamic = ""):Void {
		if (_availability) {
			if (Capabilities.os.indexOf("Mac") != -1) {
				if (_queue.length == 0) {
					_queueTimer.start();
				}
				_queue.push({
							fn: fn,
							param: param
						});
			}
			else {
				ExternalInterface.call(fn, param);
			}
		}
	}
	
	/**
         * Loads the previous URL in the history list.
         */
	public static function back():Void {
		_call("SWFAddress.back");
	}
	
	/**
         * Loads the next URL in the history list.
         */
	public static function forward():Void {
		_call("SWFAddress.forward");
	}
	
	/**
         * Navigates one level up in the deep linking path.
         */
	public static function up():Void {
		var path:String = SWFAddress.getPath();
		SWFAddress.setValue(path.substr(0, path.lastIndexOf("/", path.length - 2) + ((path.substr(path.length - 1) == "/") ? 1:0)));
	}
	
	/**
         * Loads a URL from the history list.
         * @param delta An integer representing a relative position in the history list.
         */
	public static function go(delta:Int):Void {
		_call("SWFAddress.go", delta);
	}
	
	/**
         * Opens a new URL in the browser. 
         * @param url The resource to be opened.
         * @param target Target window.
         */
	public static function href(url:String, target:String = "_self"):Void {
		if (_availability && Capabilities.playerType == "ActiveX") {
			ExternalInterface.call("SWFAddress.href", url, target);
			return;
		}
		flash.Lib.getURL(new URLRequest(url), target);
	}
	
	/**
         * Opens a browser popup window. 
         * @param url Resource location.
         * @param name Name of the popup window.
         * @param options Options which get evaluted and passed to the window.open() method.
         * @param handler Optional JavsScript handler code for popup handling.    
         */
	public static function popup(url:String, name:String = "popup", options:String = "\"\"", handler:String = ""):Void
	/*if (_availability && (Capabilities.playerType == 'ActiveX' || ExternalInterface.call('asual.util.Browser.isSafari'))) {
                ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
                return;
            }*/ {
		
		flash.Lib.getURL(new URLRequest("javascript:popup=window.open(\"" + url + "\",\"" + name + "\"," + options + ");" + handler + ";void(0);"), "_self");
	}
	
	/**
         * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. 
         * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
         * @param type The type of event.
         * @param listener The listener function that processes the event. This function must accept an Event object as its only parameter and must return nothing.
         * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
         * @param priority The priority level of the event listener.
         * @param useWeakReference Determines whether the reference to the listener is strong or weak.
         * @throws ArgumentError The listener specified is not a function. 
         */
	public static function addEventListener(type:String, listener:Function, useCapture:Bool = false, priority:Int = 0,
			useWeakReference:Bool = false):Void {
		_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	/**
         * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
         * @param type The type of event. 
         * @param listener The listener object to remove.
         * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases. 
         * If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, 
         * one call with useCapture() set to true, and another call with useCapture() set to false. 
         */
	public static function removeEventListener(type:String, listener:Function, useCapture:Bool = false):Void {
		_dispatcher.removeEventListener(type, listener, useCapture);
	}
	
	/**
         * Dispatches an event to all the registered listeners. 
         * @param event Event object.
         * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise.
         * @throws Error The event dispatch recursion limit has been reached. 
         */
	public static function dispatchEvent(event:Event):Bool {
		return _dispatcher.dispatchEvent(event);
	}
	
	/**
         * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. This allows you to determine where an EventDispatcher object has 
         * altered handling of an event type in the event flow hierarchy.
         * @param event The type of event.  
         * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise. 
         */
	public static function hasEventListener(type:String):Bool {
		return _dispatcher.hasEventListener(type);
	}
	
	/**
         * Provides the base address of the document. 
         */
	public static function getBaseURL():String {
		var url:String = null;
		if (_availability) {
			url = Std.string(ExternalInterface.call("SWFAddress.getBaseURL"));
		}
		return ((url == null || url == "null" || !_availability)) ? "":url;
	}
	
	/**
         * Provides the state of the strict mode setting. 
         */
	public static function getStrict():Bool {
		var strict:String = null;
		if (_availability) {
			strict = Std.string(ExternalInterface.call("SWFAddress.getStrict"));
		}
		return ((strict == null)) ? _strict:(strict == "true");
	}
	
	/**
         * Enables or disables the strict mode.
         * @param strict Strict mode state.
         */
	public static function setStrict(strict:Bool):Void {
		_call("SWFAddress.setStrict", strict);
		_strict = strict;
	}
	
	/**
         * Provides the state of the history setting. 
         */
	public static function getHistory():Bool {
		return ((_availability)) ? 
		try cast(ExternalInterface.call("SWFAddress.getHistory"), Bool) catch(e:Dynamic) null:false;
	}
	
	/**
         * Enables or disables the creation of history entries.
         * @param history History state.
         */
	public static function setHistory(history:Bool):Void {
		_call("SWFAddress.setHistory", history);
	}
	
	/**
         * Provides the tracker function.
         */
	public static function getTracker():String {
		return ((_availability)) ? 
		Std.string(ExternalInterface.call("SWFAddress.getTracker")):"";
	}
	
	/**
         * Sets a function for page view tracking. The default value is 'urchinTracker'.
         * @param tracker Tracker function.
         */
	public static function setTracker(tracker:String):Void {
		_call("SWFAddress.setTracker", tracker);
	}
	
	/**
         * Provides the title of the HTML document.
         */
	public static function getTitle():String {
		var title:String = ((_availability)) ? 
		Std.string(ExternalInterface.call("SWFAddress.getTitle")):"";
		if (title == "undefined" || title == null) {
			title = "";
		}
		return decodeURI(title);
	}
	
	/**
         * Sets the title of the HTML document.
         * @param title Title value.
         */
	public static function setTitle(title:String):Void {
		_call("SWFAddress.setTitle", encodeURI(decodeURI(title)));
	}
	
	/**
         * Provides the status of the browser window.
         */
	public static function getStatus():String {
		var status:String = ((_availability)) ? 
		Std.string(ExternalInterface.call("SWFAddress.getStatus")):"";
		if (status == "undefined" || status == null) {
			status = "";
		}
		return decodeURI(status);
	}
	
	/**
         * Sets the status of the browser window.
         * @param status Status value.
         */
	public static function setStatus(status:String):Void {
		_call("SWFAddress.setStatus", encodeURI(decodeURI(status)));
	}
	
	/**
         * Resets the status of the browser window.
         */
	public static function resetStatus():Void {
		_call("SWFAddress.resetStatus");
	}
	
	/**
         * Provides the current deep linking value.
         */
	public static function getValue():String {
		return decodeURI(_strictCheck(_value || "", false));
	}
	
	/**
         * Sets the current deep linking value.
         * @param value A value which will be appended to the base link of the HTML document.
         */
	public static function setValue(value:String):Void {
		if (value == "undefined" || value == null) {
			value = "";
		}
		if (value.lastIndexOf("/") == value.length - 1) {
			value = value.substr(0, value.length - 1);
		}  //TŁ  
		value = encodeURI(decodeURI(_strictCheck(value, true)));
		//TŁ
		var path:String = getPath(value);
		if (path.charAt(0) == "/") {
			path = path.substring(1, path.length);
		}
		var queryString:String = getQueryString(value);
		if ((LoaderXMLContentView.dictIndToAliasIndSection) && (LoaderXMLContentView.dictIndToAliasIndSection[path] != null)) {
			path = LoaderXMLContentView.dictIndToAliasIndSection[path];
		}
		value = path + (((queryString != null && queryString.length)) ? ("?" + queryString):"");
		//end TŁ
		if (SWFAddress._value == value) {
			return;
		}
		SWFAddress._value = value;
		_call("SWFAddress.setValue", value);
		if (SWFAddress._init) {
			_dispatchEvent(SWFAddressEvent.CHANGE);
			_dispatchEvent(SWFAddressEvent.INTERNAL_CHANGE);
		}
		else {
			_initChanged = true;
		}
	}
	
	/**
         * Provides the deep linking value without the query string.
         */
	public static function getPath(value:String = null):String {
		if (value == null) {
			value = SWFAddress.getValue();
		}
		if (value.indexOf("?") != -1) {
			return value.split("?")[0];
		}
		else if (value.indexOf("#") != -1) {
			return value.split("#")[0];
		}
		else {
			return value;
		}
	}
	
	/**
         * Provides a list of all the folders in the deep linking path.
         */
	public static function getPathNames():Array<Dynamic> {
		var path:String = SWFAddress.getPath();
		var names:Array<Dynamic> = path.split("/");
		if (path.substr(0, 1) == "/" || path.length == 0) {
			names.splice(0, 1);
		}
		if (path.substr(path.length - 1, 1) == "/") {
			names.splice(names.length - 1, 1);
		}
		return names;
	}
	
	/**
         * Provides the query string part of the deep linking value.
         */
	public static function getQueryString(value:String = null):String {
		if (value == null) {
			value = SWFAddress.getValue();
		}
		var index:Float = value.indexOf("?");
		if (index != -1 && index < value.length) {
			return value.substr(index + 1);
		}
		return null;
	}
	
	/**
         * Provides the value of a specific query parameter as a string or array of strings.
         * @param param Parameter name.
         */
	public static function getParameter(param:String):Dynamic {
		var value:String = SWFAddress.getValue();
		var index:Float = value.indexOf("?");
		if (index != -1) {
			value = value.substr(index + 1);
			var params:Array<Dynamic> = value.split("&");
			var p:Array<Dynamic>;
			var i:Float = params.length;
			var r:Array<Dynamic> = new Array<Dynamic>();
			while (i--) {
				p = Reflect.field(params, Std.string(i)).split("=");
				if (p[0] == param) {
					r.push(p[1]);
				}
			}
			if (r.length != 0) {
				return (r.length != 1) ? r:r[0];
			}
		}
		return null;
	}
	
	/**
         * Provides a list of all the query parameter names.
         */
	public static function getParameterNames():Array<Dynamic> {
		var value:String = SWFAddress.getValue();
		var index:Float = value.indexOf("?");
		var names:Array<Dynamic> = new Array<Dynamic>();
		if (index != -1) {
			value = value.substr(index + 1);
			if (value != "" && value.indexOf("=") != -1) {
				var params:Array<Dynamic> = value.split("&");
				var i:Float = 0;
				while (i < params.length) {
					names.push(Reflect.field(params, Std.string(i)).split("=")[0]);
					i++;
				}
			}
		}
		return names;
	}
	
	//TŁ
	
	public static function getParametersObject():Dynamic {
		var arrParamName:Array<Dynamic> = SWFAddress.getParameterNames();
		var parameters:Dynamic = { };
		for (i in 0...arrParamName.length) {
			Reflect.setField(parameters, Std.string(arrParamName[i]), SWFAddress.getParameter(arrParamName[i]));
		}
		return parameters;
	}
	
	public static function getCurrentSwfAddress(indPath:Int = -1):String {
		var currentSwfAddress:String = "";
		var pathNames:Array<Dynamic> = SWFAddress.getPathNames();
		if (indPath == -1) {
			for (i in 0...pathNames.length) {
				currentSwfAddress += (["", "/"][as3hx.Compat.parseInt(i > 0)] + pathNames[i]);
			}
		}
		else if (pathNames.length > indPath) {
			currentSwfAddress = pathNames[indPath];
		}
		return currentSwfAddress;
	}
	
	public static function getParametersString(objParams:Dynamic = null):String {
		var strParameters:String = "";
		if (objParams == null) {
			strParameters = "?" + SWFAddress.getQueryString();
		}
		else {
			var i:Int = 0;
			for (nameParam in Reflect.fields(objParams)) {
				strParameters += (["?", "&"][as3hx.Compat.parseInt(i++ > 0)] + nameParam + "=" + Reflect.field(objParams, nameParam));
			}
		}
		return strParameters;
	}
	
	public static function setPathWithParameters(path:String, objParamsNewAndChanged:Dynamic = null, isReplaceParams:Bool = false):Void {
		SWFAddress.setValueWithParameters(SWFAddress.getPath(path), objParamsNewAndChanged, isReplaceParams);
	}
	
	public static function setCurrentValueWithOneParameter(nameParam:String, valueParam:Dynamic, isReplaceParams:Bool = false):Void {
		var objParams:Dynamic = { };
		Reflect.setField(objParams, nameParam, valueParam);
		SWFAddress.setCurrentValueWithParameters(objParams, isReplaceParams);
	}
	
	public static function setCurrentValueWithParameters(objParamsNewAndChanged:Dynamic = null, isReplaceParams:Bool = false):Void {
		SWFAddress.setValueWithParameters(SWFAddress.getCurrentSwfAddress(), objParamsNewAndChanged, isReplaceParams);
	}
	
	public static function setValueWithOneParameter(value:String, nameParam:String, valueParam:Dynamic, isReplaceParams:Bool = false):Void {
		var objParams:Dynamic = { };
		Reflect.setField(objParams, nameParam, valueParam);
		SWFAddress.setValueWithParameters(value, objParams, isReplaceParams);
	}
	
	public static function setValueWithCurrentParameters(value:String):Void {
		SWFAddress.setValueWithParameters(value, { }, false);
	}
	
	public static function setValueWithParameters(value:String, objParamsNewAndChanged:Dynamic = null, isReplaceParams:Bool = false):Void {
		objParamsNewAndChanged = objParamsNewAndChanged || { };
		var objParamsCurrent:Dynamic;
		if (isReplaceParams) {
			objParamsCurrent = objParamsNewAndChanged;
		}
		else {
			objParamsCurrent = SWFAddress.getParametersObject();
			for (prop in Reflect.fields(objParamsNewAndChanged)) {
				Reflect.setField(objParamsCurrent, prop, Reflect.field(objParamsNewAndChanged, prop));
			}
		}
		var oldValue:String = SWFAddress.getValue();
		var newValue:String = value + SWFAddress.getParametersString(objParamsCurrent);
		SWFAddress.setValue(newValue);
		if ((newValue == oldValue) && (ManagerSection.isForceRefresh)) {
			SWFAddress.dispatchEvent(new SWFAddressEvent(SWFAddressEvent.CHANGE));
		}
	}
}

