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
import tl.loader.LoaderXML;
import flash.utils.Dictionary;
import tl.loader.URLLoaderExt;
import tl.types.ObjectUtils;
import tl.types.StringUtils;
import tl.flashUtils.FlashUtils;
import flash.system.ApplicationDomain;

class LoaderXMLContentView extends LoaderXML {
	
	public static inline var NAME_SECTION_EMPTY:String = "empty";
	
	private var prefixClass:String;
	public static var content:Dynamic;
	public static var dictIndViewSectionToVecDescriptionSubViewSection:Dictionary = new Dictionary();
	public static var dictIndViewSectionToDescriptionParentViewSection:Dictionary = new Dictionary();
	public static var isUseAliasIndSection:Bool = true;
	public static var dictIndToAliasIndSection:Dictionary;
	public static var dictAliasIndToIndSection:Dictionary;
	
	private function new(prefixClass:String) {
		super();
		this.prefixClass = prefixClass;
	}
	
	override public function parseXML(xmlNode:FastXML):Void {
		this.initDictIndAliasViewSection();
		this.parseXMLPopup(xmlNode);
		var xmlContent:FastXML = this.parseXMLSection(xmlNode, "", "", 0);
		this.createObjFromXMLContent(xmlContent);
		new DescriptionViewSection(LoaderXMLContentView.NAME_SECTION_EMPTY, ViewSectionEmpty, null, -1);
		this.parseXMLSectionRoot(xmlNode, xmlContent);
		LoaderXMLContentView.setDictIndViewSectionToDescriptionParentViewSection();
	}
	
	private function initDictIndAliasViewSection():Void {
		if (LoaderXMLContentView.isUseAliasIndSection) {
			if (!LoaderXMLContentView.dictIndToAliasIndSection) {
				LoaderXMLContentView.dictIndToAliasIndSection = new Dictionary();
			}
			if (!LoaderXMLContentView.dictAliasIndToIndSection) {
				LoaderXMLContentView.dictAliasIndToIndSection = new Dictionary();
			}
		}
	}
	
	private function createObjFromXMLContent(xmlContent:FastXML):Void {
		var content:Dynamic = URLLoaderExt.parseXMLToObject(xmlContent);
		if (!LoaderXMLContentView.content) {
			LoaderXMLContentView.content = content;
		}
		else {
			LoaderXMLContentView.content = ObjectUtils.populateObj(content, LoaderXMLContentView.content);
		}
	}
	
	private function parseXMLSection(xmlSection:FastXML, predIndSection:String, predIndSectionAlias:String, depth:Int):FastXML {
		if (Std.string(xmlSection) != "") {
			if (predIndSectionAlias == "") {
				predIndSectionAlias = predIndSection;
			}
			//var xmlListSubSection: XMLList = xmlSection.*.((attribute("isSection") == "1") || (attribute("isSectionAndContent") == "1")); //xmlSection.elements()
			var xmlListSubSection:FastXMLList = xmlSection.node.elements.innerData();
			var arrSuffIndSubSectionInXMLListSubSection:Array<Dynamic> = [];
			var xmlSubSection:FastXML;
			var suffIndSubSection:String;
			for (i in 0...xmlListSubSection.length()) {
				xmlSubSection = xmlListSubSection.get(i);
				if ((as3hx.Compat.parseInt(xmlSubSection.node.attribute.innerData("isSection"))) || (as3hx.Compat.parseInt(xmlSubSection.node.attribute.innerData("isSectionAndContent")))) {
					suffIndSubSection = xmlSubSection.node.name.innerData();
					if (Lambda.indexOf(arrSuffIndSubSectionInXMLListSubSection, suffIndSubSection) == -1) {
						arrSuffIndSubSectionInXMLListSubSection.push(suffIndSubSection);
					}
				}
			}
			//iterate through subsections
			var order:Int = 0;
			if (LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[predIndSection] == null) {
				LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[predIndSection] = new Vector<DescriptionViewSection>();
			}
			for (i in 0...arrSuffIndSubSectionInXMLListSubSection.length) {
				suffIndSubSection = arrSuffIndSubSectionInXMLListSubSection[i];
				var objClasses:Dynamic = this.getObjClassContentAndViewSection(suffIndSubSection);
				var xmlListSubSectionWithSameName:FastXMLList = xmlSection.get(suffIndSubSection);
				//trace("xmlListSubSectionWithSameName:", objClasses.contentSubViewSection, xmlListSubSectionWithSameName)
				var indSubSection:String = (((predIndSection == "")) ? "":predIndSection + "/") + suffIndSubSection;
				var indSubSectionWithWoNum:String;
				for (j in 0...xmlListSubSectionWithSameName.length()) {
					var strWoNumSubSection:String = [Std.string(j), ""][as3hx.Compat.parseInt(xmlListSubSectionWithSameName.length() == 1)];
					indSubSectionWithWoNum = indSubSection + strWoNumSubSection;
					xmlSubSection = xmlListSubSectionWithSameName.get(j);
					var suffIndSubSectionAlias:String = this.getSuffIndSectionAlias(xmlSubSection);
					if (suffIndSubSectionAlias == "") {
						suffIndSubSectionAlias = suffIndSubSection + strWoNumSubSection;
					}
					var indSubSectionAlias:String = (((predIndSectionAlias == "")) ? "":predIndSectionAlias + "/") + suffIndSubSectionAlias;
					xmlSubSection = this.parseXMLSection(xmlSubSection, indSubSectionWithWoNum, indSubSectionAlias, depth + 1);
					var descriptionSubViewSection:DescriptionViewSection;
					var contentSubViewSection:ContentViewSection = new objClasses.ClassContentViewSection(xmlSubSection, order, depth);
					if (LoaderXMLContentView.isUseAliasIndSection) {
						Reflect.setField(dictIndToAliasIndSection, indSubSectionWithWoNum, indSubSectionAlias);
						if (xmlListSubSectionWithSameName.length() == 1) {
							LoaderXMLContentView.dictIndToAliasIndSection[indSubSectionWithWoNum + "0"] = indSubSectionAlias;
						}
						LoaderXMLContentView.dictAliasIndToIndSection[indSubSectionAlias] = indSubSectionWithWoNum;
					}
					descriptionSubViewSection = new DescriptionViewSection(indSubSection, objClasses.classViewSection, contentSubViewSection, ((xmlListSubSectionWithSameName.length() == 1)) ? -1:j);
					LoaderXMLContentView.addToArrDescriptionSubViewSection(predIndSection, descriptionSubViewSection);
					order++;
					if (!as3hx.Compat.parseInt(xmlListSubSectionWithSameName.get(j).att.isSectionAndContent)) {
						xmlListSubSectionWithSameName.get(j) = "empty";
					}
				}
			}
		}
		return xmlSection;
	}
	
	private function parseXMLSectionRoot(xmlNode:FastXML, xmlContent:FastXML):Void {
		if ((xmlNode.att.isSection == 1) || (xmlNode.att.isSectionAndContent == 1)) {
			var objClasses:Dynamic = this.getObjClassContentAndViewSection(xmlNode.node.name.innerData());
			if (objClasses.classViewSection) {
				new DescriptionViewSection("", objClasses.classViewSection, new objClasses.ClassContentViewSection(xmlContent), -1);
			}
		}
	}
	
	private function getObjClassContentAndViewSection(suffIndSection:String):Dynamic {
		var suffIndSectionCode:String = StringUtils.toUpperCaseFromUnderscore(suffIndSection);
		var classContentViewSection:Class<Dynamic> = this.getClassDefinition(this.prefixClass + ".content.Content" + suffIndSectionCode);
		if ((classContentViewSection == null) || (!FlashUtils.isSuperclass(classContentViewSection, ContentViewSection))) {
			classContentViewSection = ContentViewSection;
		}
		var classViewSection:Class<Dynamic> = this.getClassDefinition(this.prefixClass + ".viewSection.ViewSection" + suffIndSectionCode);
		return {
			classContentViewSection: classContentViewSection,
			classViewSection: classViewSection
		};
	}
	
	private function getSuffIndSectionAlias(xmlSection:FastXML):String {
		var objSection:Dynamic = URLLoaderExt.parseXMLToObject(xmlSection);
		var objSuffIndSectionAlias:Dynamic = objSection.name || objSection.label || objSection.title || "";
		if (Type.resolveClass(Type.getClassName(objSuffIndSectionAlias)) == Dynamic) {
			objSuffIndSectionAlias = cast((objSuffIndSectionAlias), Object).text;
		}
		var suffIndSectionAlias:String = StringUtils.depolonize(Std.string(objSuffIndSectionAlias)).toLowerCase();
		suffIndSectionAlias = StringTools.replace(suffIndSectionAlias, "%", "");
		return suffIndSectionAlias;
	}
	
	private static function addToArrDescriptionSubViewSection(indSection:String, descriptionViewSection:DescriptionViewSection):Void {
		var vecDescriptionSubViewSection:Vector<DescriptionViewSection> = LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[indSection] || new Vector<DescriptionViewSection>();
		var i:Int = 0;
		while ((i < vecDescriptionSubViewSection.length) && (cast((vecDescriptionSubViewSection[i]), DescriptionViewSection).ind != descriptionViewSection.ind)) {
			i++;
		}
		if (i < vecDescriptionSubViewSection.length) {
			cast((vecDescriptionSubViewSection[i]), DescriptionViewSection).addAdditionalContent(descriptionViewSection);
		}
		else {
			vecDescriptionSubViewSection.push(descriptionViewSection);
		}
		LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[indSection] = vecDescriptionSubViewSection;
	}
	
	private static function setDictIndViewSectionToDescriptionParentViewSection():Void {
		LoaderXMLContentView.dictIndViewSectionToDescriptionParentViewSection = new Dictionary();
		for (indSection in Reflect.fields(LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection)) {
			var vecDescriptionSubViewSection:Vector<DescriptionViewSection> = LoaderXMLContentView.dictIndViewSectionToVecDescriptionSubViewSection[indSection];
			for (i in 0...vecDescriptionSubViewSection.length) {
				LoaderXMLContentView.dictIndViewSectionToDescriptionParentViewSection[vecDescriptionSubViewSection[i].ind] = ManagerSection.dictDescriptionViewSection[indSection];
			}
		}
	}
	
	//popup
	
	private function parseXMLPopup(xmlPopup:FastXML):Void {
		var xmlListSubPopup:FastXMLList = xmlPopup.node.elements.innerData();
		var xmlSubPopup:FastXML;
		var suffIndSubPopup:String;
		for (i in 0...xmlListSubPopup.length()) {
			xmlSubPopup = xmlListSubPopup.get(i);
			suffIndSubPopup = xmlSubPopup.node.name.innerData();
			if (as3hx.Compat.parseInt(xmlSubPopup.att.isPopup)) {
				var objClasses:Dynamic = this.getObjClassContentAndViewPopup(suffIndSubPopup);
				var contentSubViewPopup:ContentViewPopup = new objClasses.ClassContentViewPopup(xmlSubPopup);
				var objParamsWithValuesToShow:Dynamic = { };
				if (contentSubViewPopup.objParamsWithValuesToShow) {
					objParamsWithValuesToShow = haxe.Json.parse(contentSubViewPopup.objParamsWithValuesToShow);
				}
				var descriptionSubViewPopup:DescriptionViewPopup = new DescriptionViewPopup(suffIndSubPopup, objClasses.classViewPopup, contentSubViewPopup, objParamsWithValuesToShow);
			}
			else {
				this.parseXMLPopup(xmlSubPopup);
			}
		}
	}
	
	private function getObjClassContentAndViewPopup(suffIndPopup:String):Dynamic {
		var suffIndPopupCode:String = StringUtils.toUpperCaseFromUnderscore(suffIndPopup);
		var classContentViewPopup:Class<Dynamic> = this.getClassDefinition(this.prefixClass + ".content.ContentPopup" + suffIndPopupCode);
		if ((classContentViewPopup == null) || (!FlashUtils.isSuperclass(classContentViewPopup, ContentViewPopup))) {
			classContentViewPopup = ContentViewPopup;
		}
		var classViewPopup:Class<Dynamic> = this.getClassDefinition(this.prefixClass + ".viewPopup.ViewPopup" + suffIndPopupCode);
		return {
			classContentViewPopup: classContentViewPopup,
			classViewPopup: classViewPopup
		};
	}
	
	//helper
	
	private function getClassDefinition(nameClass:String):Class<Dynamic> {
		var classDefinition:Class<Dynamic> = null;
		try {
			if (ApplicationDomain.currentDomain.hasDefinition(nameClass)) {
				classDefinition = cast((Type.resolveClass(nameClass)), Class);
			}
		} catch (e:Error) {
		}
		return classDefinition;
	}
}

