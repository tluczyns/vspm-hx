package tl.loader;

import flash.display.Sprite;
import tl.loader.QueueLoadContent;
import tl.loader.progress.LoaderProgress;
import motion.Actuate;
import motion.easing.Linear;
import flash.display.DisplayObject;

class LibraryLoader extends Sprite {
	
	private static inline var TIME_HIDE_SHOW:Float = 0.2;
	
	private var loaderProgress:LoaderProgress;
	private var queueLoadContent:QueueLoadContent;
	private var arrIndSwfLib:Array<Dynamic>;
	private var isAllLibrariesLoaded:Bool;
	public var arrSwfLib:Array<Dynamic>;
	
	private function new(arrFilenameSwfLib:Array<Dynamic>) {
		super();
		this.createAndInitLoaderProgress();
		this.prepareQueueLoadContent(arrFilenameSwfLib);
	}
	
	private function createLoaderProgress():LoaderProgress {
		return new LoaderProgress();
	}
	
	private function createAndInitLoaderProgress():Void {
		this.loaderProgress = this.createLoaderProgress();
		this.addChild(this.loaderProgress);
		this.loaderProgress.alpha = 0;
		Actuate.tween(this.loaderProgress, LibraryLoader.TIME_HIDE_SHOW, {alpha: 1}).ease(Linear.easeNone).onComplete(this.startLoading);
	}
	
	private function prepareQueueLoadContent(arrFilenameSwfLib:Array<Dynamic>):Void {
		this.queueLoadContent = new QueueLoadContent(this.onContentLoadCompleteHandler, this, this.loaderProgress);
		this.loadContent(arrFilenameSwfLib);
	}
	
	private function loadContent(arrFilenameSwfLib:Array<Dynamic>):Void {
		this.arrIndSwfLib = [];
		for (i in 0...arrFilenameSwfLib.length) {
			this.arrIndSwfLib.push(this.queueLoadContent.addToLoadQueue(Std.string(arrFilenameSwfLib[i])));
		}
	}
	
	private function startLoading():Void {
		this.queueLoadContent.startLoading();
	}
	
	private function onContentLoadCompleteHandler(arrContent:Array<Dynamic>):Void {
		this.isAllLibrariesLoaded = true;
		this.arrSwfLib = new Array<Dynamic>();
		for (i in 0...this.arrIndSwfLib.length) {
			var objSwfLib:Dynamic = arrContent[this.arrIndSwfLib[i]];
			if (objSwfLib.isLoaded) {
				if (objSwfLib.type == QueueLoadContent.SWF) {
					this.arrSwfLib[i] = objSwfLib.content;
					Library.addSwf(cast((objSwfLib.content), DisplayObject));
				}
			}
			else {
				this.isAllLibrariesLoaded = false;
			}
		}
		this.hideLoaderProgress();
	}
	
	private function hideLoaderProgress():Void {
		Actuate.tween(this.loaderProgress, LibraryLoader.TIME_HIDE_SHOW, {alpha: 0}).ease(Linear.easeNone).onComplete(this.onHideLoaderProgress);
	}
	
	private function removeLoaderProgress():Void {
		this.loaderProgress.destroy();
		this.removeChild(this.loaderProgress);
		this.loaderProgress = null;
	}
	
	private function onHideLoaderProgress():Void {
		this.removeLoaderProgress();
		if (this.isAllLibrariesLoaded) {
			this.dispatchEvent(new EventLibraryLoader(EventLibraryLoader.LIBRARIES_LOAD_SUCCESS));
		}
		else {
			this.dispatchEvent(new EventLibraryLoader(EventLibraryLoader.LIBRARIES_LOAD_ERROR));
		}
	}
}

