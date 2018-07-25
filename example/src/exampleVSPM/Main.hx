package exampleVSPM;

import flash.display.Sprite;
import tl.loader.LibraryLoader;
import tl.app.InitUtils;
import flash.display.StageScaleMode;
import flash.events.Event;
import tl.loader.EventLibraryLoader;

//import com.greensock.TweenNano;
//import com.greensock.easing.Linear;
//import com.luaye.console.C;
@:meta(SWF(backgroundColor="0xffffff",frameRate="60",width="490",height="660"))

class Main extends Sprite {
	
	private var libraryLoader:LibraryLoader;
	private var application:Application;
	
	public function new() {
		trace("new Main");
		super();
		//C.start(this);
		InitUtils.initApp(this, StageScaleMode.NO_SCALE);
		Config.HOST = ((root.loaderInfo.parameters.host != null)) ? Std.string(root.loaderInfo.parameters.host):"";
		//TweenNano.from(this, Config.TIME_HIDE_SHOW, {alpha: 0, ease: Linear.easeNone});
		this.loadLibrary();
		this.stage.addEventListener(Event.RESIZE, this.onStageResize);
		this.stage.dispatchEvent(new Event(Event.RESIZE));
	}
	
	private function loadLibrary():Void {
		this.libraryLoader = new LibraryLoader([Config.HOST + Config.ADD_TO_PATH_SWF + "lib.swf"]);
		this.libraryLoader.addEventListener(EventLibraryLoader.LIBRARIES_LOAD_SUCCESS, this.initApplication);
	}
	
	private function initApplication(e:EventLibraryLoader):Void {
		this.application = new Application();
		this.addChild(this.application);
		this.application.init(Config.HOST);
	}
	
	private function onStageResize(event:Event):Void {
		Config.WIDTH = this.stage.stageWidth;
		Config.HEIGHT = this.stage.stageHeight;
	}
}

