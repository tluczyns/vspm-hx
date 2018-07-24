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

import flash.display.Sprite;
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

//import caurina.transitions.Tweener;
/*
 * Important: 
 * Greensock library is NOT a part of this framework.
 * It is used here only to represent base hide/show animation of the view.
 * It can be easily replaced by Tweener (just comment/uncomment proper lines in this file) or any other animation library.
 */
class View extends Sprite implements IViewSection {
	public var content(get, never):ContentView;

	
	public var description:DescriptionView;
	
	private var isHideShow:Int;
	public var tMaxHideShow:TimelineMax;
	
	public function new(description:DescriptionView) {
		super();
		this.description = description;
	}
	
	private function get_content():ContentView {
		return this.description.content;
	}
	
	public function init():Void {  //override it: add elements  
		//if (!this.tMaxHideShow) this.alpha = 0;
		
	}
	
	private function hideShowTimelineMax(isHideShow:Int):Void {
		if (isHideShow == 0) {
			this.tMaxHideShow.reverse();
			if (this.tMaxHideShow.totalProgress() == 0) {
				this.hideComplete();
			}
		}
		else if (isHideShow == 1) {
			this.tMaxHideShow.play();
			if (this.tMaxHideShow.totalProgress() == 1) {
				this.startAfterShow();
			}
		}
	}
	
	private function hideShowEmpty(isHideShow:Int, timeDelayStartAfterShow:Float):Void {
		TweenMax.killDelayedCallsTo(this.startAfterShow);
		if (isHideShow == 0) {
			this.hideComplete();
		}
		else if (isHideShow == 1) {
			TweenMax.delayedCall(timeDelayStartAfterShow, this.startAfterShow);
		}
	}
	
	private function hideShow(isHideShow:Int):Void
	//Tweener.addTween(this, {alpha: isHideShow, time: 0.3, transition: "linear", onComplete: [this.hideComplete, this.startAfterShow][isHideShow]}); {
		
		if (this.tMaxHideShow) {
			this.hideShowTimelineMax(isHideShow);
		}
		else {
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0.3, {
						alpha: isHideShow,
						ease: Linear.easeNone,
						onComplete: [this.hideComplete, this.startAfterShow][isHideShow]
					});
		}
	}
	
	public function show():Void {
		this.isHideShow = 1;
		this.hideShow(1);
	}
	
	private function startAfterShow():Void {  //override it: fe. additional animation, adding listeners and mouse events  
		
	}
	
	private function stopBeforeHide():Void {  //override it: fe. removing listeners and mouse events  
		
	}
	
	public function hide():Void {
		this.stopBeforeHide();
		this.isHideShow = 0;
		this.hideShow(0);
	}
	
	private function hideComplete():Void {
		this.destroy();
	}
	
	private function destroy():Void
	//override it to remove elements {
		
		if (this.tMaxHideShow) {
			this.tMaxHideShow.kill();
			this.tMaxHideShow = null;
		}
	}
}

