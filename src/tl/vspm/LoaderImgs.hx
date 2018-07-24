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

import tl.loader.QueueLoadContent;
import flash.utils.Dictionary;
import tl.loader.progress.LoaderProgress;
import flash.display.Bitmap;

class LoaderImgs extends Dynamic {
	
	public static var instance:LoaderImgs;
	
	private var queueLoadContent:QueueLoadContent;
	private var dictUrlImgToDescriptionImg:Dictionary;
	
	public function new() {
		super();
		if (!LoaderImgs.instance) {
			LoaderImgs.instance = this;
			this.init();
		}
	}
	
	private function init():Void {
		this.queueLoadContent = new QueueLoadContent(null, null, null, this.onElementImgLoadCompleteHandler, this);
		this.dictUrlImgToDescriptionImg = new Dictionary();
	}
	
	private function createDescriptionImg(urlImg:String):DescriptionImg {
		var descriptionImg:DescriptionImg = new DescriptionImg(urlImg);
		descriptionImg.loaderProgress = new LoaderProgress();
		descriptionImg.loaderProgress.visible = false;
		descriptionImg.loaderProgress.alpha = 0;
		return descriptionImg;
	}
	
	public function addLoadImgToQueue(urlImg:String):DescriptionImg {
		var descriptionImg:DescriptionImg;
		if (this.dictUrlImgToDescriptionImg[urlImg] == null) {
			descriptionImg = this.createDescriptionImg(urlImg);
			this.queueLoadContent.addToLoadQueue(descriptionImg.urlImg, 1, 0, false, descriptionImg.loaderProgress);
			this.dictUrlImgToDescriptionImg[descriptionImg.urlImg] = descriptionImg;
		}
		else {
			descriptionImg = this.dictUrlImgToDescriptionImg[urlImg];
		}
		return descriptionImg;
	}
	
	public function loadImgs():Void {
		this.queueLoadContent.startLoading();
	}
	
	private function onElementImgLoadCompleteHandler(contentImg:Dynamic, indImg:Int):Void {
		if ((contentImg.isLoaded) && (contentImg.type == QueueLoadContent.IMAGE)) {
			var descriptionImg:DescriptionImg = cast((this.dictUrlImgToDescriptionImg[contentImg.url]), DescriptionImg);
			cast((contentImg.content), Bitmap).smoothing = true;
			descriptionImg.bmpDataImg = cast((contentImg.content), Bitmap).bitmapData;
		}
	}
	
	public function bringLoadPhotoToFrontInQueue(descriptionImg:DescriptionImg):Void {
		this.queueLoadContent.bringToFrontInLoadQueue(descriptionImg.urlImg);
	}
}

