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


interface IViewSection {
	
	
	
	var x(get, set):Float;	
	
	var y(get, set):Float;

	
	function init():Void ;
	function show():Void ;
	function hide():Void ;
}

