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

class ContentView {
	
	public function new(xmlContent:FastXML) {
		super();
		var objContent:Dynamic = URLLoaderExt.parseXMLToObject(xmlContent);
		for (i in Reflect.fields(objContent)) {
			Reflect.setField(this, i, Reflect.field(objContent, i));
		}
	}
}

