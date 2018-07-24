/**
 * View Section and Popup Manager (VSPM)  <https://github.com/tluczyns/vspm>
 * Frontend multilevel subpage manager developed according to MVC pattern.
 * VSPM is (c) 2009-2017 Tomasz Luczynski
 * Licensed under MIT License
 *
 * @author		Tomasz Luczynski <tluczyns@gmail.com> <http://www.programuje.pl>
 * @version		1.3
 */
package tl.vspm;


class ViewSectionWithLoading extends ViewSection {
	private var isNoneLoadingHidepreloaderLoaded(get, set):Int;

	
	private var _isNoneLoadingHidepreloaderLoaded:Int = 0;
	private var isHideShowAfterHidePreloader:Int;
	
	public function new(description:DescriptionViewSection) {
		super(description);
	}
	
	override public function show():Void
	//trace("this.isLoading:" + this.isLoading, "this.isLoaded:" + this.isLoaded); {
		
		if (this.isNoneLoadingHidepreloaderLoaded == 0) {
			if (this.startLoading()) {
				this.isNoneLoadingHidepreloaderLoaded = 1;
			}
			else {
				this.isNoneLoadingHidepreloaderLoaded = 3;
				this.initAfterLoading();
				this.showAfterLoading();
			}
		}
		else if (this.isNoneLoadingHidepreloaderLoaded == 1) {
			super.startAfterShow();
		}
		//gdy w czasie ładowania chcemy przejść sekcję głębiej
		else if (this.isNoneLoadingHidepreloaderLoaded == 2) {
			this.isHideShowAfterHidePreloader = 1;
		}
		else if (this.isNoneLoadingHidepreloaderLoaded == 3) {
			this.showAfterLoading();
		}
	}
	
	private function startLoading():Bool {
		trace("startLoading: override this");
		return true;
	}
	
	private function get_isNoneLoadingHidepreloaderLoaded():Int {
		return this._isNoneLoadingHidepreloaderLoaded;
	}
	
	private function set_isNoneLoadingHidepreloaderLoaded(value:Int):Int {
		if (value != this._isNoneLoadingHidepreloaderLoaded) {
			if ((this._isNoneLoadingHidepreloaderLoaded == 0) && (value == 1)) {
				this.addRemovePreloader(1);
			}
			else if ((this._isNoneLoadingHidepreloaderLoaded == 1) && (value == 2)) {
				this.addRemovePreloader(0);
			}
			this._isNoneLoadingHidepreloaderLoaded = value;
		}
		return value;
	}
	
	private function addRemovePreloader(isRemoveAdd:Int):Void {
		trace("addRemovePreloader: override this");
		//odpalana gdy nie ma preloadera
		if (isRemoveAdd == 0) {
			this.finishRemovePreloader();
		}
	}
	
	private function finishRemovePreloader():Void {
		if (this.isHideShowAfterHidePreloader == 0) {
			super.hideComplete();
		}
		else if (this.isHideShowAfterHidePreloader == 1) {
			this.isNoneLoadingHidepreloaderLoaded = 3;
			this.initAfterLoading();
			this.showAfterLoading();
		}
	}
	
	private function abortLoading():Void {
		trace("abortLoading: override this");
	}
	
	private function initAfterLoading():Void {
		trace("initAfterLoading: override this");
	}
	
	private function showAfterLoading():Void {
		this.hideShow(1);
	}
	
	private function finishLoading():Void {
		this.isHideShowAfterHidePreloader = 1;
		this.isNoneLoadingHidepreloaderLoaded = 2;
	}
	
	private function hideAfterLoading():Void {
		this.hideShow(0);
	}
	
	override public function hide():Void {
		this.stopBeforeHide();
		if ((this.isNoneLoadingHidepreloaderLoaded == 1) || (this.isNoneLoadingHidepreloaderLoaded == 2)) {
			this.isHideShowAfterHidePreloader = 0;
			if (this.isNoneLoadingHidepreloaderLoaded == 1) {
				this.abortLoading();
				this.isNoneLoadingHidepreloaderLoaded = 2;
			}
		}
		else if (this.isNoneLoadingHidepreloaderLoaded == 3) {
			this.hideAfterLoading();
		}
	}
}

