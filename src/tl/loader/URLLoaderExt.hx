package tl.loader;

import flash.errors.Error;
import haxe.Constraints.Function;
import tl.utils.FunctionCallback;
import flash.utils.Timer;
import flash.net.*;
import flash.events.*;
import flash.events.TimerEvent;
import flash.utils.ByteArray;
import tl.types.StringUtils;

class URLLoaderExt extends URLLoader {
	
	private var callback:FunctionCallback;
	private var onLoadProgress:Function;
	private var timerTimeout:Timer;
	
	private function new(objLoaderExt:Dynamic) {
		super();
		var timeTimeout:Int = ((objLoaderExt.timeTimeout != null)) ? objLoaderExt.timeTimeout:60000;
		this.callback = objLoaderExt.callback;
		this.onLoadProgress = objLoaderExt.onLoadProgress || this.onLoadProgressDefault;
		var url:String = objLoaderExt.url;
		var arrObjHeader:Array<Dynamic> = objLoaderExt.arrObjHeader || [];
		var data:Dynamic = objLoaderExt.data || new URLVariables();
		var objParams:Dynamic = objLoaderExt.objParams || { };
		var addRandomValue:Bool = ((objLoaderExt.addRandomValue != null)) ? objLoaderExt.addRandomValue:false;
		var isGetPost:Int = ((objLoaderExt.isGetPost != null)) ? objLoaderExt.isGetPost:1;
		var isTextBinaryVariables:Int = ((objLoaderExt.isTextBinaryVariables != null)) ? objLoaderExt.isTextBinaryVariables:0;
		
		this.createTimeoutForNetOperation(timeTimeout);
		this.addListeners();
		this.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
		
		var request:URLRequest = new URLRequest(url);
		//{name: "pragma", value: "no-cache"}
		var i:Int;
		var arrHeader:Array<Dynamic> = [];
		for (i in 0...arrObjHeader.length) {
			var objHeader:Dynamic = arrObjHeader[i];
			var header:URLRequestHeader = new URLRequestHeader(objHeader.name, objHeader.value);
			arrHeader.push(header);
		}
		request.requestHeaders = arrHeader;
		if (Std.is(objParams, Array)) {
			var arrParams:Array<Dynamic> = try cast(objParams, Array<Dynamic>) catch(e:Dynamic) null;
			var objParamsFromArray:Dynamic = { };
			for (i in 0...arrParams.length) {
				var param:Array<Dynamic> = Reflect.field(objParams, Std.string(i));
				Reflect.setField(objParamsFromArray, Std.string(param[0]), param[1]);
			}
			objParams = objParamsFromArray;
		}
		for (nameParam in Reflect.fields(objParams)) {
			Reflect.setField(data, nameParam, Reflect.field(objParams, nameParam));
		}
		if (arrHeader.length > 0) {
			isGetPost = 1;  //Due to a bug in Flash, a URLRequest with a GET request will not properly send headers.  
			addRandomValue = true;
		}
		if (addRandomValue) {
			Reflect.setField(data, "random", Math.random() * 10000000);
		}
		if (Std.string(data)) {
			request.data = data;
		}
		request.method = [URLRequestMethod.GET, URLRequestMethod.POST][isGetPost];
		this.dataFormat = [URLLoaderDataFormat.TEXT, URLLoaderDataFormat.BINARY, URLLoaderDataFormat.VARIABLES][isTextBinaryVariables];
		try {
			this.load(request);
		} catch (error:Error) {
			trace("Unable to load requested document:", error);
			this.callback.call([false, error].concat(this.callback.params));
		}
	}
	
	private function createTimeoutForNetOperation(timeTimeout:Float = 30000):Void {
		this.timerTimeout = new Timer(timeTimeout, 1);
		this.timerTimeout.addEventListener("timer", this.onTimeout);
		this.timerTimeout.start();
	}
	
	private function onTimeout(event:TimerEvent):Void {
		trace("onTimeout");
		this.destroy();
		this.callback.call([false, event].concat(this.callback.params));
	}
	
	private function removeTimeoutForNetOperation():Void {
		this.timerTimeout.stop();
		this.timerTimeout.removeEventListener("timer", this.onTimeout);
		this.timerTimeout = null;
	}
	
	private function addListeners():Void {
		this.addEventListener(Event.COMPLETE, this.onLoadComplete);
		this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
		this.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		this.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
	}
	
	private function removeListeners():Void {
		this.removeEventListener(Event.COMPLETE, this.onLoadComplete);
		this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
		this.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		this.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onHTTPStatus);
	}
	
	private function onLoadComplete(event:Event):Void {
		this.destroy();
		var vars:Dynamic;
		try {
			//trace("onLoadComplete:", event.target.data){
			if (this.dataFormat == URLLoaderDataFormat.TEXT) {
				vars = Std.string(event.target.data);  //new XML(event.target.data);
			}
			else if (this.dataFormat == URLLoaderDataFormat.BINARY) {
				vars = cast((event.target.data), ByteArray);
			}
			else if (this.dataFormat == URLLoaderDataFormat.VARIABLES) {
				vars = new URLVariables(event.target.data);
			}
		} catch (error:Error) {
			vars = Std.string(event.target.data);
		}
		this.callback.call([true, vars].concat(this.callback.params));
	}
	
	private function onLoadProgressDefault(event:ProgressEvent):Void {
		var ratioLoaded:Float = event.bytesLoaded / event.bytesTotal;
		var percentLoaded:Int = Math.round(ratioLoaded * 100);
	}
	
	private function onLoadError(event:ErrorEvent):Void { //IOErrorEvent SecurityErrorEvent
		trace("onLoadError: " + event);
		this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 0, 1));
		this.destroy();
		this.callback.call([false, event].concat(this.callback.params));
	}
	
	private function onHTTPStatus(event:HTTPStatusEvent):Void {  //trace("onHTTPStatus: " + event.status);  
		
	}
	
	public function generateRandomPassword(countChars:Int):String {
		var numChar:Int;
		var strPassword:String = "";
		for (i in 0...countChars) {
			do {
				numChar = Math.round(Math.random() * 255);
			} while ((!(((numChar >= 65) && (numChar <= 90)) || ((numChar >= 48) && (numChar <= 57)) || ((numChar >= 97) && (numChar <= 122)))));
			strPassword += String.fromCharCode(numChar);
		}
		return strPassword;
	}
	
	public function destroy():Void {
		if ((this.timerTimeout) && (this.timerTimeout.running)) {
			this.removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
			this.removeListeners();
			this.removeTimeoutForNetOperation();
			this.close();
		}
	}
	
	//static utils
	
	public static function parseXMLToObject(xmlNode:FastXML):Dynamic  {
		//trace("xmlNode:", xmlNode);
		var obj:Dynamic = {/*xml: xmlNode*/};
		var xmlListAttributes:FastXMLList = xmlNode.node.attributes.innerData();  //xmlNode.@ * ;  
		//trace("xmlListAttributes:", xmlListAttributes)
		for (i in 0...xmlListAttributes.length()) {
			Reflect.setField(obj, Std.string(Std.string(xmlListAttributes.get(i).node.name.innerData())), xmlListAttributes.get(i));
		}
		var xmlListElements:FastXMLList = xmlNode.node.elements.innerData();  //xmlNode.*  
		/*for (i = 0; i < xmlListElements.length(); i++) {
		trace("xmlListElements[i]", xmlListElements[i], nameXMLListElement)
		var nameXMLListElement: String = String(xmlListElements[i].name());
		if (nameXMLListElement == "null") nameXMLListElement = "text"; //element tekstowy
		obj[nameXMLListElement] = URLLoaderExt.parseXMLToObject(xmlListElements[i]);
		}*/
		var arrNameElementInXMLListElement:Array<Dynamic> = [];
		var nameXMLListElement:String;
		for (i in 0...xmlListElements.length()) {
			nameXMLListElement = Std.string(xmlListElements.get(i).node.name.innerData());
			if (nameXMLListElement == "null") {
				nameXMLListElement = "text";
			}  //element tekstowy  
			if (Lambda.indexOf(arrNameElementInXMLListElement, nameXMLListElement) == -1) {
				arrNameElementInXMLListElement.push(nameXMLListElement);
			}
		}
		for (i in 0...arrNameElementInXMLListElement.length) {
			nameXMLListElement = arrNameElementInXMLListElement[i];
			if (nameXMLListElement != "text") {
				var xmlListElementsWithSameName:FastXMLList = xmlNode.get(nameXMLListElement);
				if (xmlListElementsWithSameName.length() > 1) {
					Reflect.setField(obj, nameXMLListElement, []);
				}
				for (j in 0...xmlListElementsWithSameName.length()) {
					var objElement:Dynamic = URLLoaderExt.parseXMLToObject(xmlListElementsWithSameName.get(j));
					if (xmlListElementsWithSameName.length() > 1) {
						Reflect.field(obj, nameXMLListElement).push(objElement);
					}
					else {
						Reflect.setField(obj, nameXMLListElement, objElement);
					}
				}
			}
			else {
				Reflect.setField(obj, nameXMLListElement, xmlNode);
			}
		}
		for (attr in Reflect.fields(obj)) {
			var classAttr:Class<Dynamic> = cast((Type.resolveClass(Type.getClassName(Reflect.field(obj, attr)))), Class);
			if ((!Math.isNaN(as3hx.Compat.parseFloat(Reflect.field(obj, attr)))) && (Reflect.field(obj, attr) != "")) {
				if (as3hx.Compat.parseFloat(Reflect.field(obj, attr)) == as3hx.Compat.parseInt(Reflect.field(obj, attr))) {
					Reflect.setField(obj, attr, as3hx.Compat.parseInt(Reflect.field(obj, attr)));
				}
				else {
					Reflect.setField(obj, attr, as3hx.Compat.parseFloat(Reflect.field(obj, attr)));
				}
			}
			else if ((classAttr != Array) && (classAttr != Dynamic)) {
				Reflect.setField(obj, attr, Std.string(Reflect.field(obj, attr)).split("\\n").join("\n"));
				Reflect.setField(obj, attr, Std.string(Reflect.field(obj, attr)).split("\r").join(""));
				Reflect.setField(obj, attr, Std.string(Reflect.field(obj, attr)).split("\r").join(""));
				Reflect.setField(obj, attr, StringUtils.replace(Std.string(Reflect.field(obj, attr)), String.fromCharCode(65440), String.fromCharCode(160)));
			}
		}
		return obj;
	}
	
	public static function sortXML(source:FastXML, elementName:Dynamic, fieldName:Dynamic, options:Dynamic = null):FastXML {
		// list of elements we're going to sort
		var xmlList:FastXMLList = source.node.elements.innerData(elementName);  //elements().(name() == elementName);  
		// list of elements not included in the sort -
		// we place these back into the source node at the end
		//var xmlListExclude: XMLList = source.elements().(name() != elementName);
		var xmlListExclude:FastXMLList = source.node.elements.innerData();
		for (i in 0...xmlListExclude.length()) {
			if (xmlListExclude.get(i).node.name.innerData() == elementName) {
				//; //WARNING
				i--;
			}
		}
		xmlList = sortXMLList(xmlList, fieldName, options);
		xmlList += xmlListExclude;
		source.node.setChildren.innerData(xmlList);
		return source;
	}
	
	public static function sortXMLList(list:FastXMLList, fieldName:Dynamic, options:Dynamic = null):FastXMLList {
		var arr:Array<Dynamic> = new Array<Dynamic>();
		var ch:FastXML;
		for (ch in list) {
			arr.push(ch);
		}
		var resultArr:Array<Dynamic> = (fieldName == null) ? (options == null) ? arr.sort():arr.sort(options):arr.sortOn(fieldName, options);
		var result:FastXMLList = new FastXMLList();
		for (i in 0...resultArr.length) {
			result += resultArr[i];
		}
		return result;
	}
}
