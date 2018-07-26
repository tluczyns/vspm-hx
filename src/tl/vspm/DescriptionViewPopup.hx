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

import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;

class DescriptionViewPopup extends DescriptionView {
	
	public var objParamsWithValuesToShow:Dynamic;
	
	public function new(ind:String, nameClass:Class<Dynamic>, content:ContentViewPopup, objParamsWithValuesToShow:Dynamic, x:Float = 0, y:Float = 0, containerView:DisplayObjectContainer = null) {
		this.objParamsWithValuesToShow = objParamsWithValuesToShow || {};
		super(ind, nameClass, content, x, y, containerView);
	}
	
	override private function getDictDescriptionViewInManager():Dictionary {
		return ManagerPopup.dictDescriptionViewPopup;
	}
	
	private function isHideShowForParameters(parameters:Dynamic):Int {
		var isHideShow:Int = 1;
		for (param in Reflect.fields(this.objParamsWithValuesToShow)) {
			var valueParam:Dynamic = this.objParamsWithValuesToShow[param];
			var classValueParam:Class<Dynamic>;
			if (valueParam == null) {
				valueParam = 0;
			}
			if ((!Math.isNaN(as3hx.Compat.parseFloat(valueParam))) && (valueParam != "")) {
				classValueParam = Float;
			}
			else {
				classValueParam = String;
			}
			var valueParamModel:Dynamic = Reflect.field(parameters, param);
			if (valueParamModel == null) {
				valueParamModel = 0;
			}
			if (classValueParam(valueParamModel) != classValueParam(valueParam)) {
				isHideShow = 0;
			}
		}
		return isHideShow;
	}
	
	@:allow(tl.vspm)
	private function checkAndHideShowView(oldParameters:Dynamic):Void {
		var isHideShowForOldParameters:Int = this.isHideShowForParameters(oldParameters);
		var isHideShow:Int = this.isHideShowForParameters(StateModel.parameters);
		if (isHideShow != isHideShowForOldParameters) {
			if (isHideShow == 0) {
				if (this.view) {
					this.view.hide();
				}
			}
			else if (isHideShow == 1) {
				this.createView();
			}
		}
	}
	
	override private function getDefaultContainerView():DisplayObjectContainer {
		return ManagerPopup.dspObjContainerPopup;
	}
	
	override public function createView():Void {
		if (this.view == null) {
			super.createView();
		}
		if (this.view) {
			this.trackPageView();
			this.view.show();
		}
	}
	
	private function trackPageView():Void {
		if (!as3hx.Compat.parseInt(this.content.isNotTrack)) {
			StateModel.trackPageview("popup_" + this.ind);
		}
	}
}

