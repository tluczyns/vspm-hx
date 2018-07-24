package tl.loader.progress;

import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;

interface ILoaderProgress {

	function addWeightContent(weight:Float):Void ;
	function initNextLoad():Void ;
	function onLoadProgress(event:ProgressEvent):Void ;
	function setLoadProgress(ratioLoaded:Float):Void ;
}

