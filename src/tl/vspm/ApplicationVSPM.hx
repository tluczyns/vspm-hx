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
import tl.loader.Library;
import tl.loader.EventLoaderXML;

class ApplicationVSPM extends Sprite {
	
	private var prefixClass:String;
	private var loaderXMLContent:LoaderXMLContentView;
	private var containerApplication:ContainerApplicationVSPM;
	
	public function new() {
		super();
		Library.addSwf(this);
		new LoaderImgs();
		var nameClassApplication:String = Type.getClassName(Type.getClass(this));
		this.prefixClass = nameClassApplication.substr(0, nameClassApplication.indexOf("::"));
	}
	
	public function init(pathAssets:String = "", pathFileXML:String = "xml/content.xml"):Void {
		this.loadXMLContent(pathAssets + pathFileXML);
	}
	
	private function loadXMLContent(pathXML:String, strKeyEncryption:String = ""):Void {
		this.loaderXMLContent = new LoaderXMLContentView(this.prefixClass);
		this.loaderXMLContent.loadXML(pathXML, strKeyEncryption);
		this.loaderXMLContent.addEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
	}
	
	private function initOnXMLContentLoaded(e:EventLoaderXML = null):Void {
		this.loaderXMLContent.removeEventListener(EventLoaderXML.XML_LOADED, this.initOnXMLContentLoaded);
		this.registerFonts();
		this.loadImgs();
		this.initContainers();
		this.initViews();
	}
	
	private function registerFonts():Void {
	}
	
	private function loadImgs():Void {
		LoaderImgs.instance.loadImgs();
	}
	
	private function initContainers():Void {
		var classContainerApplication:Class<Dynamic>;
		try {
			classContainerApplication = cast((Type.resolveClass(this.prefixClass + ".container.ContainerApplication")), Class);
		} catch (e:Error) {
			classContainerApplication = ContainerApplicationVSPM;
		}
		this.containerApplication = Type.createInstance(classContainerApplication, []);
		this.addChild(this.containerApplication);
	}
	
	private function initViews(startIndSection:String = ""):Void {
		ManagerPopup.init(containerApplication.containerViewPopup);
		ManagerSection.init(containerApplication.containerViewSection, startIndSection);
		Metrics.createVecMetricsFromContent(LoaderXMLContentView.content, this.stage);
	}
}

