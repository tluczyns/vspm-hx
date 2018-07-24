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

import flash.errors.Error;
import flash.display.Sprite;
import flash.display.Stage;
import com.google.analytics.GATracker;

class Metrics extends Sprite {
	
	private static inline var GA:String = "ga";
	private static inline var OMNITURE:String = "omniture";
	private static var ARR_POSSIBLE_TYPE:Array<Dynamic> = [GA, OMNITURE];
	
	@:allow(tl.vspm)
	private static var vecMetrics:Vector<Metrics>;
	
	private var type:String;
	private var data:Dynamic;
	private var isOnlyForwardTrack:Bool;
	private var tracker:Dynamic;
	
	@:allow(tl.vspm)
	private static function createVecMetricsFromContent(content:Dynamic, stage:Stage):Void {
		Metrics.vecMetrics = new Vector<Metrics>();
		for (i in 0...Metrics.ARR_POSSIBLE_TYPE.length) {
			var possibleType:String = Metrics.ARR_POSSIBLE_TYPE[i];
			if (Reflect.field(content, possibleType) != null) {
				var metrics:Metrics = new Metrics();
				stage.addChild(metrics);
				metrics.init(possibleType, Reflect.field(content, possibleType));
				Metrics.vecMetrics.push(metrics);
			}
		}
	}
	
	public function new() {
		super();
	}
	
	private function init(type:String, dataPrimitive:Dynamic):Void {
		if (Metrics.ARR_POSSIBLE_TYPE.indexOf(type) != -1) {
			this.type = type;
			if (this.type == Metrics.GA) {
				this.data = Std.string(dataPrimitive.value);
			}
			else if (this.type == Metrics.OMNITURE) {
				this.data = dataPrimitive;
			}
			this.isOnlyForwardTrack = cast(as3hx.Compat.parseInt(dataPrimitive.isOnlyForwardTrack), Bool);
			if (this.data) 
			//try {{
				
				if (this.type == Metrics.GA) {
					this.tracker = new GATracker(this, Std.string(this.data));
				}
				else if (this.type == Metrics.OMNITURE) {
					this.tracker = new OmnitureTracker(this.data);
				}
			}
			else {
				throw new Error("No data in given metrics!");
			}
		}
		else {
			throw new Error("Metrics is not of possible types!");
		}
	}
	
	@:allow(tl.vspm)
	private function trackView(indView:String, isBackwardForward:Int):Void {
		if (!this.isOnlyForwardTrack || isBackwardForward == 1) 
		//trace("trackPageview:", indView){
			
			this.tracker.trackPageview(indView);
		}
	}
}

