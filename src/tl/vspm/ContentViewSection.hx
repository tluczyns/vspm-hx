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

import tl.loader.URLLoaderExt;

class ContentViewSection extends ContentView {
	
	public var order:Int;
	public var depth:Int;
	
	public function new(xmlContent:FastXML, order:Int, depth:Int) {
		super(xmlContent);
		this.order = order;
		this.depth = depth;
	}
}

