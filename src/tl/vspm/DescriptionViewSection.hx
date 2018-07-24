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

//import tl.types.DictionaryExt;
class DescriptionViewSection extends DescriptionView {
	
	public var indBase:String;
	public var num:Int;
	public var parent:DescriptionViewSection;
	public var isEngaged:Bool = false;
	
	public function new(ind:String, nameClass:Class<Dynamic>, content:ContentViewSection, num:Int, parent:DescriptionViewSection = null, x:Float = 0, y:Float = 0, container:DisplayObjectContainer = null) {
		super(ind + (((num == -1)) ? "":Std.string(num)), nameClass, content, x, y, container);
		this.indBase = ind;
		this.num = ((num == -1)) ? 0:num;
		this.parent = parent;
	}
	
	override private function getDictDescriptionViewInManager():Dictionary
	//DictionaryExt {
		
		return ManagerSection.dictDescriptionViewSection;
	}
	
	override private function getDefaultContainerView():DisplayObjectContainer {
		return ManagerSection.dspObjContainerSection;
	}
}

