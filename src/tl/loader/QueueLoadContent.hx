package tl.loader;

import haxe.Constraints.Function;
import tl.loader.progress.ILoaderProgress;
import tl.types.ArrayUtils;
import flash.events.Event;
import flash.display.AVM1Movie;
import flash.events.IOErrorEvent;
import tl.loader.LoaderExt;
import tl.loader.SoundExt;
import tl.utils.FunctionCallback;

class QueueLoadContent extends Dynamic {
	public var isLoading(get, never):Bool;

	
	public static inline var FINISHED_PROGRESS:String = "finishedProgress";
	
	public static inline var IMAGE:Int = 0;
	public static inline var SWF:Int = 1;
	public static inline var SOUND:Int = 2;
	public static inline var SERVER_DATA:Int = 3;
	
	private var _isLoading:Bool;
	private var isStopLoading:Bool;
	private var arrLoadContent:Array<Dynamic>;
	private var numContentToLoad:Int;
	private var onAllLoadCompleteHandler:Function;
	private var onAllLoadCompleteScope:Dynamic;
	private var isClearAfterAllLoadComplete:Bool;  //należy ustawić na false, gdy planujemy doładywać na danej kolejce nowe rzeczy (po zakończeniu poprzedniego wczytywania)  
	private var onElementLoadCompleteHandler:Function;
	private var onElementLoadCompleteScope:Dynamic;
	public var loaderProgress:ILoaderProgress;
	
	//public var percentLoadingAsset: Number, percentLoadingTotal: Number; //for use for external preloaders
	
	public function new(onAllLoadCompleteHandler:Function, onAllLoadCompleteScope:Dynamic, loaderProgress:ILoaderProgress = null, onElementLoadCompleteHandler:Function = null, onElementLoadCompleteScope:Dynamic = null, isClearAfterAllLoadComplete:Bool = true) {
		super();
		this._isLoading = false;
		this.arrLoadContent = [];
		this.numContentToLoad = -1;
		this.onAllLoadCompleteHandler = onAllLoadCompleteHandler;
		this.onAllLoadCompleteScope = onAllLoadCompleteScope;
		this.isClearAfterAllLoadComplete = isClearAfterAllLoadComplete;
		this.loaderProgress = loaderProgress;
		this.onElementLoadCompleteHandler = onElementLoadCompleteHandler;
		this.onElementLoadCompleteScope = onElementLoadCompleteScope;
	}
	
	public function addToLoadQueue(url:String, weight:Float = 1, isDataTextBinaryVariables:Int = 0, isStartLoading:Bool = false, loaderProgress:ILoaderProgress = null):Int {
		url = url || "";
		loaderProgress = loaderProgress || this.loaderProgress;
		var newObjLoadContent:Dynamic = {
			url: url,
			weight: weight,
			type: ((isDataTextBinaryVariables == 1)) ? QueueLoadContent.SERVER_DATA:this.getContentTypeFromUrl(url),
			isDataTextBinaryVariables: isDataTextBinaryVariables,
			isLoaded: false,
			loaderProgress: loaderProgress,
			content: null
		};
		this.arrLoadContent.push(newObjLoadContent);
		newObjLoadContent.indLoadContent = this.arrLoadContent.length - 1;
		if (loaderProgress != null) {
			loaderProgress.addWeightContent(weight);
		}
		if (isStartLoading) {
			this.startLoading();
		}
		return as3hx.Compat.parseInt(this.arrLoadContent.length - 1);
	}
	
	public function bringToFrontInLoadQueue(url:String):Void {
		var indObjLoadContentInLoadQueue:Int = ArrayUtils.getElementIndexByProperty(this.arrLoadContent, "url", url);
		if ((indObjLoadContentInLoadQueue != -1) && (indObjLoadContentInLoadQueue > this.numContentToLoad) && (this.numContentToLoad + 1 < this.arrLoadContent.length)) {
			this.arrLoadContent.splice(this.numContentToLoad + 1, 0, this.arrLoadContent.splice(indObjLoadContentInLoadQueue, 1)[0]);
		}
	}
	
	public function startLoading():Void {
		this.isStopLoading = false;
		if (!this._isLoading) {
			this.loadNextElementFromQueue();
		}
	}
	
	private function onLoadComplete(event:Event):Void {
		var objLoadContent:Dynamic = this.arrLoadContent[this.numContentToLoad];
		objLoadContent = this.checkAndCorrectTypeFromLoadedContent(objLoadContent);
		if ((objLoadContent.type == QueueLoadContent.IMAGE) || ((objLoadContent.type == QueueLoadContent.SWF)  /*&& (objLoadContent.content.contentLoaderInfo.actionScriptVersion == 3)*/  )) {
			objLoadContent.width = objLoadContent.content.contentLoaderInfo.width;
			objLoadContent.height = objLoadContent.content.contentLoaderInfo.height;
			if (!(Std.is(objLoadContent.content.content, AVM1Movie))) {
				objLoadContent.content = objLoadContent.content.content;
			}
		}
		objLoadContent.isLoaded = true;
		if ((this.onElementLoadCompleteHandler != null) && (this.onElementLoadCompleteScope != null) && (!this.isStopLoading)) {
			this.onElementLoadCompleteHandler.apply(this.onElementLoadCompleteScope, [objLoadContent, this.numContentToLoad]);
		}
		if (!this.isStopLoading) {
			this.loadNextElementFromQueue();
		}
	}
	
	private function onLoadError(errorEvent:IOErrorEvent):Void {
		trace("onLoadError:", errorEvent);
		var objLoadContent:Dynamic = this.arrLoadContent[this.numContentToLoad];
		objLoadContent.isLoaded = false;
		if ((this.onElementLoadCompleteHandler != null) && (this.onElementLoadCompleteScope != null)) {
			this.onElementLoadCompleteHandler.apply(this.onElementLoadCompleteScope, [objLoadContent, this.numContentToLoad]);
		}
		if (!this.isStopLoading) {
			this.loadNextElementFromQueue();
		}
	}
	
	private function onAllLoadComplete(e:Dynamic = null):Void {
		if (this.onAllLoadCompleteHandler != null) {
			this.onAllLoadCompleteHandler.apply(this.onAllLoadCompleteScope, [this.arrLoadContent]);
		}
		if (this.isClearAfterAllLoadComplete) {
			if (this.loaderProgress) {
				this.loaderProgress["removeEventListener"](QueueLoadContent.FINISHED_PROGRESS, this.onAllLoadComplete);
			}
			for (i in 0...this.arrLoadContent.length) {
				this.arrLoadContent[i] = null;
			}
			this.arrLoadContent = [];
		}
	}
	
	private function loadNextElementFromQueue():Void {
		if (this.numContentToLoad + 1 < this.arrLoadContent.length) {
			this.numContentToLoad++;
			this._isLoading = true;
			var objLoadContent:Dynamic = this.arrLoadContent[this.numContentToLoad];
			var onLoadProgress:Function;
			if (objLoadContent.loaderProgress) {
				onLoadProgress = objLoadContent.loaderProgress.onLoadProgress;
			}
			if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
				objLoadContent.content = new LoaderExt({
							url: objLoadContent.url,
							onLoadComplete: this.onLoadComplete,
							onLoadProgress: onLoadProgress,
							onLoadError: this.onLoadError
						});
			}
			else if (objLoadContent.type == QueueLoadContent.SOUND) {
				objLoadContent.content = new SoundExt({
							url: objLoadContent.url,
							isToPlay: false,
							onLoadComplete: this.onLoadComplete,
							onLoadProgress: onLoadProgress,
							onLoadError: this.onLoadError
						});
			}
			else if (objLoadContent.type == QueueLoadContent.SERVER_DATA) {
				var callback:FunctionCallback = new FunctionCallback(function(isLoaded:Bool, data:Dynamic, args:Array<Dynamic> = null):Void {
					var objLoadContent:Dynamic = this.arrLoadContent[this.numContentToLoad];
					if (isLoaded) {
						objLoadContent.content = data;
						this.onLoadComplete(null);
					}
					else {
						this.onLoadError(null);
					}
				}, this);
				objLoadContent.urlLoaderExt = new URLLoaderExt({
							url: objLoadContent.url,
							isGetPost: 1,
							isTextBinaryVariables: objLoadContent.isDataTextBinaryVariables,
							timeTimeout: [60000, 10000000][as3hx.Compat.parseInt(objLoadContent.isDataTextBinaryVariables == 1)],
							callback: callback,
							onLoadProgress: onLoadProgress
						});
			}
			else {
				this.onLoadError(null);
			}
			if (objLoadContent.loaderProgress) {
				objLoadContent.loaderProgress.initNextLoad();
			}
		}
		else {
			this._isLoading = false;
			if (this.loaderProgress) {
				this.loaderProgress.setLoadProgress(1);
				this.loaderProgress["addEventListener"](QueueLoadContent.FINISHED_PROGRESS, this.onAllLoadComplete);
			}
			else {
				this.onAllLoadComplete();
			}
		}
	}
	
	private function getContentTypeFromUrl(url:String):Int {
		var arrExtensionImage:Array<Dynamic> = ["png", "jpg", "jpeg", "gif"];
		var arrExtensionMovie:Array<Dynamic> = ["swf", "ne"];
		var arrExtensionSound:Array<Dynamic> = ["mp3", "wav"];
		var arrExtensionServerData:Array<Dynamic> = ["xml", "php"];
		var isFoundType:Bool = false;
		var type:Int = 0;
		while ((!isFoundType) && (type <= 3)) {
			var arrExtension:Array<Dynamic> = [arrExtensionImage, arrExtensionMovie, arrExtensionSound, arrExtensionServerData][type];
			var i:Int = 0;
			url = url.toLowerCase();
			while (((url.indexOf("." + arrExtension[i]) == -1)
			|| (url.indexOf("." + arrExtension[i]) != (url.length - arrExtension[i].length - 1)))
			&& (i < arrExtension.length)) {
				i++;
			}
			if (i < arrExtension.length) {
				isFoundType = true;
			}
			else {
				type++;
			}
		}
		if (isFoundType) {
			return type;
		}
		else {
			return QueueLoadContent.SERVER_DATA;
		}
	}
	
	private function checkAndCorrectTypeFromLoadedContent(objLoadContent:Dynamic):Dynamic {
		if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
			var _sw0_ = (objLoadContent.content.contentLoaderInfo.contentType);			

			switch (_sw0_) {
				case "application/x-shockwave-flash":objLoadContent.type = QueueLoadContent.SWF;
				case "image/jpeg":objLoadContent.type = QueueLoadContent.IMAGE;
				case "image/gif":objLoadContent.type = QueueLoadContent.IMAGE;
				case "image/png":objLoadContent.type = QueueLoadContent.IMAGE;
			}
		}
		return objLoadContent;
	}
	
	public function stopLoading():Void {
		this.isStopLoading = true;
		if (this.isLoading) {
			var objLoadContent:Dynamic = this.arrLoadContent[this.numContentToLoad];
			if ((objLoadContent.type == QueueLoadContent.IMAGE) || (objLoadContent.type == QueueLoadContent.SWF)) {
				objLoadContent.content.destroy();
			}
			else if (objLoadContent.type == QueueLoadContent.SOUND) {
				objLoadContent.content.destroy();
			}
			else if (objLoadContent.type == QueueLoadContent.SERVER_DATA) {
				objLoadContent.urlLoaderExt.destroy();
			}
			this._isLoading = false;
		}
	}
	
	private function get_isLoading():Bool {
		return _isLoading;
	}
}

