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

import haxe.Constraints.Function;
import tl.types.Singleton;
import flash.events.EventDispatcher;
import tl.types.ObjectUtils;

//import com.google.analytics.GATracker;
//import tl.omniture.OmnitureTracker;
class StateModel extends Singleton {
	public static var parameters(get, never):Dynamic;

	
	private static var dispatcher:EventDispatcher = new EventDispatcher();
	
	private static var _parameters:Dynamic = { };
	
	public static function init():Void {
		if (!SWFAddress.hasEventListener(SWFAddressEvent.CHANGE)) {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, StateModel.handleSWFAddress);
		}
	}
	
	public static function addEventListener(type:String, func:Function, priority:Int = 0):Void {
		StateModel.dispatcher.addEventListener(type, func, false, priority);
	}
	
	public static function removeEventListener(type:String, func:Function):Void {
		StateModel.dispatcher.removeEventListener(type, func);
	}
	
	public static function dispatchEvent(type:String, data:Dynamic = null):Void {
		StateModel.dispatcher.dispatchEvent(new EventStateModel(type, data));
	}
	
	private static function get_parameters():Dynamic {
		return StateModel._parameters;
	}
	
	public static function trackPageview(indView:String, isForward:Bool = true):Void {
		for (i in 0...Metrics.vecMetrics.length) {
			Metrics.vecMetrics[i].trackView(indView, as3hx.Compat.parseInt(isForward));
		}
	}
	
	private static function handleSWFAddress(e:SWFAddressEvent):Void
	/*var currentSwfAddressValue: String = SWFAddress.getValue();
			if ((currentSwfAddressValue != StateModel.currentSwfAddressValue) || (ManagerSection.isForceReload)) {*/ {
		
		var oldParameters:Dynamic = StateModel._parameters;
		StateModel._parameters = SWFAddress.getParametersObject();
		var currentSwfAddressPath:String = SWFAddress.getPath();
		var indSectionAlias:String = ManagerSection.joinIndSectionFromArrElement(ManagerSection.splitIndSectionFromStr(currentSwfAddressPath));
		var indSection:String;
		if ((LoaderXMLContentView.dictAliasIndToIndSection) && (LoaderXMLContentView.dictAliasIndToIndSection[indSectionAlias] != null)) {
			indSection = LoaderXMLContentView.dictAliasIndToIndSection[indSectionAlias];
		}
		else {
			indSection = indSectionAlias;
		}
		
		if ((indSection != "") && (indSection != ManagerSection.currIndSection)) {
			var descriptionViewSection:DescriptionViewSection = ManagerSection.dictDescriptionViewSection[indSection];
			if (descriptionViewSection != null) {
				var contentViewSection:ContentViewSection = cast((descriptionViewSection.content), ContentViewSection);
				var isForward:Bool = !ManagerSection.isEqualsElementsIndSection(indSection, ManagerSection.currIndSection);
				if (contentViewSection == null || (!as3hx.Compat.parseInt(contentViewSection.isNotTrack) && (!as3hx.Compat.parseInt(contentViewSection.isOnlyForwardTrack) || isForward))) {
					StateModel.trackPageview(indSectionAlias, isForward);
				}
			}
		}
		if ((indSection == "") && (ManagerSection.startIndSection != "")) {
			SWFAddress.setValue(ManagerSection.startIndSection);
		}
		//trace("oldIndSection:", ManagerSection.currIndSection, ", indSection:", indSection);
		else {
			
			//trace("oldParameters:", ObjectUtils.toString(oldParameters), ", StateModel._parameters:", ObjectUtils.toString(StateModel._parameters), !ObjectUtils.equals(oldParameters, StateModel._parameters))
			if (!ObjectUtils.equals(oldParameters, StateModel._parameters)) {
				StateModel.dispatchEvent(EventStateModel.CHANGE_PARAMETERS, {
							oldParameters: oldParameters,
							newParameters: StateModel._parameters,
							oldIndSection: ManagerSection.currIndSection,
							newIndSection: indSection
						});
			}
			var newIndSection:String = (ManagerSection.newIndSection) ? ManagerSection.newIndSection:ManagerSection.currIndSection;
			if (newIndSection != indSection) {
				StateModel.dispatchEvent(EventStateModel.START_CHANGE_SECTION, {
							oldIndSection: ManagerSection.currIndSection,
							newIndSection: indSection
						});
			}
		}
	}

	public function new() {
		super();
	}
}

