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
import flash.display.DisplayObjectContainer;
import flash.utils.Dictionary;
import tl.types.DictionaryExt;
import tl.types.ObjectUtils;

class DescriptionView {
	
	public var ind:String;
	public var classView:Class<Dynamic>;
	public var content:ContentView;
	public var x:Float;
	public var y:Float;
	public var containerView:DisplayObjectContainer;
	public var view:View;
	
	public function new(ind:String, classView:Class<Dynamic>, content:ContentView, x:Float = 0, y:Float = 0, containerView:DisplayObjectContainer = null) {
		super();
		this.ind = ind;
		this.classView = classView;
		this.content = content;
		this.x = x;
		this.y = y;
		this.containerView = containerView;
		this.view = null;
		this.addToDictInManager();
	}
	
	private function getDictDescriptionViewInManager():Dictionary {	//DictionaryExt {
		throw new Error("getDictDescriptionViewFromManager must be implemented");
	}
	
	private function addToDictInManager():Void {
		var dictDescriptionViewInManager:Dictionary = this.getDictDescriptionViewInManager();  //DictionaryExt  
		if (dictDescriptionViewInManager[this.ind] != null) {
			cast((dictDescriptionViewInManager[this.ind]), DescriptionView).addAdditionalContent(this);
		}
		else {
			dictDescriptionViewInManager[this.ind] = this;
		}
	}
	
	@:allow(tl.vspm)
	private function addAdditionalContent(descriptionView:DescriptionView):Void {
		if (!this.classView) {
			this.classView = descriptionView.classView;
		}
		this.content = cast((ObjectUtils.populateObj(this.content, descriptionView.content)), ContentView);
	}
	
	private function getDefaultContainerView():DisplayObjectContainer {
		throw new Error("getDefaultContainerView must be implemented");
	}
	
	public function getContainerView():DisplayObjectContainer {
		return ((this.containerView != null)) ? this.containerView:this.getDefaultContainerView();
	}
	
	public function createView():Void {
		var containerView:DisplayObjectContainer = this.getContainerView();
		if ((this.view == null) && (this.classView)) {
			this.view = Type.createInstance(this.classView, [this]);
			this.view.x = this.x;
			this.view.y = this.y;
			containerView.addChild(this.view);
			containerView.setChildIndex(this.view, containerView.numChildren - 1);
			this.view.init();
		}
	}
	
	public function removeView():Void {
		var containerView:DisplayObjectContainer = this.getContainerView();
		if (this.view != null) {
			containerView.removeChild(this.view);
			this.view = null;
		}
	}
}

