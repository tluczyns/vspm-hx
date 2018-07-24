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

class ContainerApplicationVSPM extends Sprite {
	private var classBg(get, never):Class<Dynamic>;
	private var classContainerViewSection(get, never):Class<Dynamic>;
	private var classContainerViewPopup(get, never):Class<Dynamic>;
	private var classFg(get, never):Class<Dynamic>;

	
	private var bg:Sprite;
	public var containerViewSection:Sprite;
	public var containerViewPopup:Sprite;
	public var fg:Sprite;
	
	public function new() {
		super();
		this.createBg();
		this.createContainerViewSection();
		this.createContainerViewPopup();
		this.createFg();
	}
	
	private function createBg():Void {
		this.bg = Type.createInstance(classBg, []);
		this.addChild(this.bg);
	}
	
	private function get_classBg():Class<Dynamic> {
		return Sprite;
	}
	
	private function deleteBg():Void {
		this.removeChild(this.bg);
		this.bg = null;
	}
	
	private function get_classContainerViewSection():Class<Dynamic> {
		return Sprite;
	}
	
	private function createContainerViewSection():Void {
		this.containerViewSection = Type.createInstance(classContainerViewSection, []);
		this.addChild(this.containerViewSection);
	}
	
	private function get_classContainerViewPopup():Class<Dynamic> {
		return Sprite;
	}
	
	private function deleteContainerViewSection():Void {
		this.removeChild(this.containerViewSection);
		this.containerViewSection = null;
	}
	
	private function createContainerViewPopup():Void {
		this.containerViewPopup = Type.createInstance(classContainerViewPopup, []);
		this.addChild(this.containerViewPopup);
	}
	
	private function get_classFg():Class<Dynamic> {
		return Sprite;
	}
	
	private function deleteContainerViewPopup():Void {
		this.removeChild(this.containerViewPopup);
		this.containerViewPopup = null;
	}
	
	private function createFg():Void {
		this.fg = Type.createInstance(classFg, []);
		this.addChild(this.fg);
	}
	
	private function deleteFg():Void {
		this.removeChild(this.fg);
		this.fg = null;
	}
	
	public function destroy():Void {
		this.deleteFg();
		this.deleteContainerViewPopup();
		this.deleteContainerViewSection();
		this.deleteBg();
	}
}

