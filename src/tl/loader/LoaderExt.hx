package tl.loader;

import flash.errors.Error;
import haxe.Constraints.Function;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import tl.service.ExternalInterfaceExt;
import flash.net.URLVariables;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;

class LoaderExt extends Loader {
	
	private var onLoadComplete:Dynamic->Void;
	private var onLoadProgress:Dynamic->Void;
	private var onLoadError:Dynamic->Void;
	
	public function new(objLoaderExt:Dynamic) {
		super();
		var url:String = Std.string(objLoaderExt.url);
		this.onLoadComplete = (objLoaderExt.onLoadComplete != null) ? objLoaderExt.onLoadComplete : this.onLoadCompleteDefault;
		this.onLoadProgress = (objLoaderExt.onLoadProgress != null) ? objLoaderExt.onLoadProgress : this.onLoadProgressDefault;
		this.onLoadError = (objLoaderExt.onLoadError != null) ? objLoaderExt.onLoadError : this.onLoadErrorDefault;
		var checkPolicyFile:Bool = cast(objLoaderExt.checkPolicyFile, Bool);
		this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
		this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
		this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		var request:URLRequest = new URLRequest(url);
		if (ExternalInterfaceExt.isBrowser) {
			var variables:URLVariables = new URLVariables();
			variables.nocache = Date.now().getTime();
			request.data = variables;
		}
		var applicationDomain:ApplicationDomain;
		if (as3hx.Compat.parseInt(objLoaderExt.isApplicationDomainCurrentNew) == 1) {
			applicationDomain = new ApplicationDomain();
		}
		else {
			applicationDomain = ApplicationDomain.currentDomain;
		}  //SecurityDomain.currentDomain  
		var context:LoaderContext = new LoaderContext(checkPolicyFile, applicationDomain);
		this.load(request, context);
	}
	
	private function onLoadCompleteDefault(event:Event):Void {
		trace("The img / movie has finished loading.");
	}
	
	private function onLoadProgressDefault(event:ProgressEvent):Void {
		var ratioLoaded:Float = event.bytesLoaded / event.bytesTotal;
		var percentLoaded:Int = Math.round(ratioLoaded * 100);
	}
	
	private function onLoadErrorDefault(errorEvent:IOErrorEvent):Void {
		trace("The img / movie could not be loaded: " + errorEvent.text);
	}
	
	public function destroy():Void {
		this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
		this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.onLoadProgress);
		this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
		try {
			if (this.content) {
				this.unloadAndStop();
			}
			else {
				this.close();
			}
		} catch (e:Error) {
		}
	}
}

