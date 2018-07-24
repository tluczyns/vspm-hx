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

import tl.types.Singleton;
import flash.utils.Dictionary;
import flash.display.DisplayObjectContainer;

//import tl.types.DictionaryExt;
//import com.luaye.console.C;
class ManagerSection extends Singleton {
	public static var dictDescriptionViewSection(get, never):Dictionary;
	public static var currIndSection(get, set):String;

	
	//static private var _dictDescriptionViewSection: DictionaryExt = new DictionaryExt();
	private static var _dictDescriptionViewSection:Dictionary = new Dictionary();
	private static var _currIndSection:String = "";
	
	@:allow(tl.vspm)
	private static var dspObjContainerSection:DisplayObjectContainer;
	public static var startIndSection:String = "";
	public static var newIndSection:String = null;
	public static var oldIndSection:String = null;
	
	public static var isEngagingParallelViewSections:Bool = false;
	private static var isNotShowFirstViewSection:Bool;
	public static var isForceRefresh:Bool;
	
	public function new() {
		super();
	}
	
	public static function init(dspObjContainerSection:DisplayObjectContainer, startIndSection:String = ""):Void {
		ManagerSection.dspObjContainerSection = dspObjContainerSection;
		ManagerSection.startIndSection = startIndSection || ManagerSection.startIndSection;
		StateModel.addEventListener(EventStateModel.START_CHANGE_SECTION, ManagerSection.changeSection, -10);
		StateModel.init();
	}
	
	public static function removeSectionDescription(descriptionViewSection:DescriptionViewSection):Void {
		ManagerSection._dictDescriptionViewSection[descriptionViewSection.ind] = null;
	}
	
	private static function changeSection(e:EventStateModel):Void {
		var newIndSection:String = Std.string(e.data.newIndSection);
		newIndSection = ManagerSection.joinIndSectionFromArrElement(ManagerSection.splitIndSectionFromStr(newIndSection));
		if (ManagerSection._dictDescriptionViewSection[newIndSection] == null) {
			if (newIndSection.charAt(newIndSection.length - 1) == "0") {
				newIndSection = newIndSection.substring(0, newIndSection.length - 1);
			}
		}
		//trace("changeSection:", newIndSection, ManagerSection._dictDescriptionViewSection[newIndSection], ManagerSection.currIndSection)
		//C.log("changeSection:" + newIndSection+ ", " +  ManagerSection._dictDescriptionViewSection[newIndSection] + ", " + ManagerSection.currIndSection)
		if ((ManagerSection._dictDescriptionViewSection) && (ManagerSection._dictDescriptionViewSection[newIndSection] != null)) {
			if ((newIndSection != ManagerSection.currIndSection) || (ManagerSection.isForceRefresh)) {
				ManagerSection.oldIndSection = ManagerSection.currIndSection;
			}
			ManagerSection.isNotShowFirstViewSection = ((ManagerSection.newIndSection == null) && (ManagerSection.currIndSection != ""));
			ManagerSection.newIndSection = newIndSection;
			if (ManagerSection.currIndSection != "") {
				ManagerSection.stopSection();
			}
			else {
				ManagerSection.startSection();
			}
		}
	}
	
	public static function startSection():Void
	//trace("start:" + ManagerSection.currIndSection + ", " +  ManagerSection.newIndSection); //,isSetNewIndSectionToNullWhenEqualsCurrIndSection); {
		
		//C.log("start:" + ManagerSection.currIndSection + ", " +  ManagerSection.newIndSection); //,isSetNewIndSectionToNullWhenEqualsCurrIndSection);
		ManagerSection.isForceRefresh = false;
		if (ManagerSection.newIndSection != null) {
			if (ManagerSection.currIndSection != ManagerSection.newIndSection) {
				var arrElementCurrIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(ManagerSection.currIndSection);
				var arrElementNewIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(ManagerSection.newIndSection);
				//arrNew nie może być krótsze niż arrCurr
				arrElementCurrIndSection.push(arrElementNewIndSection[arrElementCurrIndSection.length]);
				ManagerSection.currIndSection = ManagerSection.joinIndSectionFromArrElement(arrElementCurrIndSection);
				var descriptionViewSectionNew:DescriptionViewSection = ManagerSection._dictDescriptionViewSection[ManagerSection.currIndSection];
				if (descriptionViewSectionNew != null) {
					descriptionViewSectionNew.createView();
					if (descriptionViewSectionNew.view) {
						descriptionViewSectionNew.view.show();
					}
				}
				if ((descriptionViewSectionNew == null) || (!descriptionViewSectionNew.view)) {
					ManagerSection.startSection();
				}
			}
			else {
				var newIndSection:String = ManagerSection.newIndSection;
				ManagerSection.newIndSection = null;
				StateModel.dispatchEvent(EventStateModel.CHANGE_SECTION, {
							oldIndSection: ManagerSection.oldIndSection,
							currIndSection: ManagerSection.currIndSection,
							newIndSection: newIndSection
						});
			}
		}
	}
	
	public static function stopSection():Void
	//trace("stop:"+ManagerSection.currIndSection +", " +  ManagerSection.newIndSection, ManagerSection.isNotShowFirstViewSection, ManagerSection.isForceRefresh); {
		
		//C.log("stop:" + ManagerSection.currIndSection + ", " +  ManagerSection.newIndSection)
		var descriptionViewSectionCurrent:DescriptionViewSection = cast((ManagerSection._dictDescriptionViewSection[ManagerSection.currIndSection]), DescriptionViewSection);
		if (((ManagerSection.isNewEqualsCurrentElementsIndSection()) || (ManagerSection.newIndSection == null)) && (!ManagerSection.isForceRefresh)) {
			if ((descriptionViewSectionCurrent != null) && (descriptionViewSectionCurrent.view != null) && (!ManagerSection.isNotShowFirstViewSection)) {
				descriptionViewSectionCurrent.view.show();
			}
			else {
				ManagerSection.isNotShowFirstViewSection = false;
				ManagerSection.startSection();
			}
		}
		else {
			ManagerSection.isNotShowFirstViewSection = false;
			var indSectionNext:String = ManagerSection.getSubstringIndSection(0, ManagerSection.getLengthIndSection() - 1);
			if ((isEngagingParallelViewSections) && (ManagerSection.isEqualsElementsIndSection(indSectionNext, ManagerSection.newIndSection)) && (ManagerSection.getLengthIndSection(ManagerSection.newIndSection) > ManagerSection.getLengthIndSection(indSectionNext))) 
			//if (ManagerSection.descriptionViewSectionEngaged){
				
				cast((ManagerSection._dictDescriptionViewSection[ManagerSection.currIndSection]), DescriptionViewSection).isEngaged = true;
			}
			if (cast((ManagerSection._dictDescriptionViewSection[ManagerSection.currIndSection]), DescriptionViewSection).isEngaged) {
				ManagerSection.currIndSection = indSectionNext;
				ManagerSection.startSection();
			}
			if ((descriptionViewSectionCurrent != null) && (descriptionViewSectionCurrent.view != null)) {
				descriptionViewSectionCurrent.view.hide();
			}
			else {
				ManagerSection.finishStopSection();
			}
		}
	}
	
	public static function finishStopSection(descriptionViewSectionToDelete:DescriptionViewSection = null):Void
	//trace("finishStop:"+ManagerSection.currIndSection +", " +  ManagerSection.newIndSection); {
		
		//C.log("finishStop:" + ManagerSection.currIndSection + ", " +  ManagerSection.newIndSection)
		ManagerSection.isForceRefresh = false;
		if (descriptionViewSectionToDelete == null) {
			descriptionViewSectionToDelete = cast((ManagerSection._dictDescriptionViewSection[ManagerSection.currIndSection]), DescriptionViewSection);
		}
		if (descriptionViewSectionToDelete != null) {
			descriptionViewSectionToDelete.removeView();
		}
		if ((descriptionViewSectionToDelete == null) || (!descriptionViewSectionToDelete.isEngaged)) {
			var arrElementCurrIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(ManagerSection.currIndSection);
			arrElementCurrIndSection.splice(arrElementCurrIndSection.length - 1, 1);
			ManagerSection.currIndSection = ManagerSection.joinIndSectionFromArrElement(arrElementCurrIndSection);
			if (ManagerSection.isNewEqualsCurrentElementsIndSection()) {
				ManagerSection.startSection();
			}
			else {
				ManagerSection.stopSection();
			}
		}
		else {
			descriptionViewSectionToDelete.isEngaged = false;
		}
	}
	
	private static function isNewEqualsCurrentElementsIndSection():Bool {
		return ManagerSection.isEqualsElementsIndSection(ManagerSection.currIndSection, ManagerSection.newIndSection);
	}
	//czy current jest zawarty w new
	public static function isEqualsElementsIndSection(parCurrIndSection:String, parNewIndSection:String):Bool {
		var arrElementCurrIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(parCurrIndSection);
		var arrElementNewIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(parNewIndSection);
		var i:Int = 0;
		while ((i < arrElementCurrIndSection.length) && (i < arrElementNewIndSection.length) && (arrElementCurrIndSection[i] == arrElementNewIndSection[i])) {
			i++;
		}
		return i >= arrElementCurrIndSection.length  //|| (ManagerSection.currIndSection == ""));  ;
	}
	
	public static function getEqualsElementsIndSection(parCurrIndSection:String, parNewIndSection:String):String {
		var arrElementCurrIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(parCurrIndSection);
		var arrElementNewIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(parNewIndSection);
		var i:Int = 0;
		while ((i < arrElementCurrIndSection.length) && (i < arrElementNewIndSection.length) && (arrElementCurrIndSection[i] == arrElementNewIndSection[i])) {
			i++;
		}
		if (i >= arrElementCurrIndSection.length) {
			return ManagerSection.joinIndSectionFromArrElement(arrElementNewIndSection.slice(0, i));
		}
		else {
			return "";
		}
	}
	
	@:allow(tl.vspm)
	private static function joinIndSectionFromArrElement(arrElementIndSection:Array<Dynamic>):String {
		var strIndSection:String = arrElementIndSection.join("/");
		if (strIndSection.charAt(0) == "/") {
			strIndSection = strIndSection.substring(1, strIndSection.length);
		}
		if (strIndSection.charAt(strIndSection.length - 1) == "/") {
			strIndSection = strIndSection.substring(0, strIndSection.length - 1);
		}
		return strIndSection;
	}
	
	public static function splitIndSectionFromStr(strIndSection:String):Array<Dynamic> {
		var arrElementIndSection:Array<Dynamic>;
		if (strIndSection == null) {
			arrElementIndSection = [];
		}
		else {
			arrElementIndSection = strIndSection.split("/");
		}
		if ((arrElementIndSection.length == 1) && (arrElementIndSection[0] == "")) {
			arrElementIndSection = [];
		}
		return arrElementIndSection;
	}
	
	private static function get_dictDescriptionViewSection():Dictionary
	//DictionaryExt {
		
		return ManagerSection._dictDescriptionViewSection;
	}
	
	public static function getCurrentDescriptionViewSection():DescriptionViewSection {
		return ManagerSection.dictDescriptionViewSection[ManagerSection.currIndSection];
	}
	
	private static function get_currIndSection():String {
		return ManagerSection._currIndSection;
	}
	
	private static function set_currIndSection(value:String):String {
		if (value != ManagerSection._currIndSection) {
			var oldIndSection:String = ManagerSection._currIndSection;
			ManagerSection._currIndSection = value;
			StateModel.dispatchEvent(EventStateModel.CHANGE_CURR_SECTION, {
						currIndSection: value,
						oldIndSection: oldIndSection,
						newIndSection: ManagerSection.newIndSection
					});
		}
		return value;
	}
	
	public static function getElementIndSection(numElement:Int, indSection:String = null):String {
		if (indSection == null) {
			indSection = ManagerSection.currIndSection;
		}
		var arrElementIndSection:Array<Dynamic> = ManagerSection.splitIndSectionFromStr(indSection);
		var strElementIndSection:String = "";
		if (numElement < arrElementIndSection.length) {
			strElementIndSection = arrElementIndSection[numElement];
		}
		return strElementIndSection;
	}
	
	public static function getLengthIndSection(indSection:String = null):Int {
		if (indSection == null) {
			indSection = ManagerSection.currIndSection;
		}
		return ManagerSection.splitIndSectionFromStr(indSection).length;
	}
	
	public static function getSubstringIndSection(start:Int = 0, length:Int = -1, indSection:String = null):String {
		if (indSection == null) {
			indSection = ManagerSection.currIndSection;
		}
		if (length == -1) {
			length = ManagerSection.getLengthIndSection(indSection);
		}
		else {
			length = Math.min(length, ManagerSection.getLengthIndSection(indSection));
		}
		var substringIndSection:String = "";
		for (i in start...start + length) {
			substringIndSection += (ManagerSection.getElementIndSection(i, indSection) + ["/", ""][as3hx.Compat.parseInt(i == start + length - 1)]);
		}
		return substringIndSection;
	}
}

